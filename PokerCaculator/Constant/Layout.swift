//
//  Layout.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import Foundation
import UIKit

struct Layout {
    // Window
    static var keyWindow: UIWindow? {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
    
    // Safe Area
    static var safeAreaInsets: UIEdgeInsets {
        return keyWindow?.safeAreaInsets ?? .zero
    }
    
    // Screen Size
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    // Navigation Bar
    static var navigationBarHeight: CGFloat {
        return 44.0
    }
    
    // Status Bar
    static var statusBarHeight: CGFloat {
        return keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    // Tab Bar
    static var tabBarHeight: CGFloat {
        return 49.0
    }
    
    // Bottom Safe Area (for iPhone X and later)
    static var bottomSafeAreaHeight: CGFloat {
        return safeAreaInsets.bottom
    }
    
    // Top Safe Area (including status bar)
    static var topSafeAreaHeight: CGFloat {
        return safeAreaInsets.top
    }
    
    // Total Navigation Height (Status Bar + Navigation Bar)
    static var totalNavigationHeight: CGFloat {
        return statusBarHeight + navigationBarHeight
    }
    
    // Content Area Size (Screen size minus safe areas)
    static var contentAreaSize: CGSize {
        return CGSize(
            width: screenWidth - safeAreaInsets.left - safeAreaInsets.right,
            height: screenHeight - safeAreaInsets.top - safeAreaInsets.bottom
        )
    }
}
