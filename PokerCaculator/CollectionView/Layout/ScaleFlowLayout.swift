//
//  ScaleFlowLayout.swift
//  PokerUp
//
//  Created by Hsiao on 2024/12/25.
//  Copyright © 2024 Open4games. All rights reserved.
//

import UIKit

/// A custom UICollectionViewFlowLayout that scales cells based on their distance from the center
/// Supports both vertical and horizontal scrolling with center item at full size and adjacent items scaled down
class ScaleFlowLayout: UICollectionViewFlowLayout {
    
    /// Minimum scale ratio for cells furthest from center
    var minScaleRatio: CGFloat = 0.7
    
    /// Spacing between cells
    var lineSpacing: CGFloat = 10 {
        didSet {
            minimumInteritemSpacing = lineSpacing
        }
    }
    
    /// Standard item size before scaling
    var standardItemSize: CGSize = .zero {
        didSet {
            itemSize = standardItemSize
        }
    }
    
    /// Whether to align cells to the end (right for vertical, bottom for horizontal)
    var isEndAligned: Bool = true
    
    /// Scale threshold distance, default is (itemSize + spacing) / 2
    var scaleThreshold: CGFloat?
    
    override init() {
        super.init()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        minimumInteritemSpacing = lineSpacing
        minimumLineSpacing = 0
        sectionInset = .zero
    }
    
    override func prepare() {
        super.prepare()
        guard collectionView != nil else {
            return
        }
        
        // Ensure valid item size
        if standardItemSize == .zero {
            standardItemSize = CGSize(width: 100, height: 100)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView,
              let superAttributes = super.layoutAttributesForElements(in: rect)?.map({ $0.copy() as! UICollectionViewLayoutAttributes })
        else { return nil }
        
        // Calculate collection view center point
        let centerPoint: CGFloat
        if scrollDirection == .vertical {
            centerPoint = collectionView.bounds.size.height / 2.0 + collectionView.contentOffset.y
        } else {
            centerPoint = collectionView.bounds.size.width / 2.0 + collectionView.contentOffset.x
        }
        
        // Calculate scale threshold
        let threshold = scaleThreshold ?? (scrollDirection == .vertical ? 
                                           (standardItemSize.height + lineSpacing) / 2 : 
                                            (standardItemSize.width + lineSpacing) / 2)
        
        for attribute in superAttributes {
            guard attribute.representedElementCategory == .cell else { continue }
            
            // Calculate distance from center
            let distance: CGFloat
            if scrollDirection == .vertical {
                distance = abs(attribute.center.y - centerPoint)
            } else {
                distance = abs(attribute.center.x - centerPoint)
            }
            
            // Calculate scale based on distance
            let scale: CGFloat
            if distance < threshold {
                let normalizedDistance = distance / threshold
                scale = 1.0 - (normalizedDistance * (1.0 - minScaleRatio))
            } else {
                scale = minScaleRatio
            }
            
            // Save original frame
            let originalFrame = attribute.frame
            
            // Apply scale transform
            attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            if isEndAligned {
                // Calculate scaled size
                let scaledSize = CGSize(
                    width: standardItemSize.width * scale,
                    height: standardItemSize.height * scale
                )
                
                if scrollDirection == .vertical {
                    // Right align for vertical scrolling
                    let rightAlignedX = collectionView.bounds.width - scaledSize.width
                    attribute.center = CGPoint(
                        x: rightAlignedX + scaledSize.width / 2,
                        y: originalFrame.midY
                    )
                } else {
                    // Bottom align for horizontal scrolling
                    let bottomAlignedY = collectionView.bounds.height - scaledSize.height
                    attribute.center = CGPoint(
                        x: originalFrame.midX,
                        y: bottomAlignedY + scaledSize.height / 2
                    )
                }
            }
        }
        
        return superAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }
        
        // Calculate visible rect
        let targetRect: CGRect
        if scrollDirection == .vertical {
            targetRect = CGRect(x: 0, y: proposedContentOffset.y,
                                width: collectionView.bounds.width,
                                height: collectionView.bounds.height)
        } else {
            targetRect = CGRect(x: proposedContentOffset.x, y: 0,
                                width: collectionView.bounds.width,
                                height: collectionView.bounds.height)
        }
        
        // Get layout attributes for visible area
        guard let layoutAttributes = self.layoutAttributesForElements(in: targetRect) else {
            return proposedContentOffset
        }
        
        // Calculate center point
        let centerPoint: CGFloat
        if scrollDirection == .vertical {
            centerPoint = proposedContentOffset.y + collectionView.bounds.height / 2
        } else {
            centerPoint = proposedContentOffset.x + collectionView.bounds.width / 2
        }
        
        // Find closest cell to center
        var closestAttribute: UICollectionViewLayoutAttributes?
        var minDistance = CGFloat.greatestFiniteMagnitude
        
        for attribute in layoutAttributes {
            guard attribute.representedElementCategory == .cell else { continue }
            
            let distance: CGFloat
            if scrollDirection == .vertical {
                distance = abs(attribute.center.y - centerPoint)
            } else {
                distance = abs(attribute.center.x - centerPoint)
            }
            
            if distance < minDistance {
                minDistance = distance
                closestAttribute = attribute
            }
        }
        
        // Calculate offset to center the closest cell
        if let closestAttribute = closestAttribute {
            if scrollDirection == .vertical {
                let targetY = closestAttribute.center.y - collectionView.bounds.height / 2
                return CGPoint(x: proposedContentOffset.x, y: targetY)
            } else {
                let targetX = closestAttribute.center.x - collectionView.bounds.width / 2
                return CGPoint(x: targetX, y: proposedContentOffset.y)
            }
        }
        
        return proposedContentOffset
    }
}
