//
//  BaseCollectionViewCell.swift
//  PokerUp
//
//  Created by Hsiao on 2024/10/16.
//  Copyright © 2024 Open4games. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    var model: BaseCollectionViewCellModel? {
        didSet {
            self.updateData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
    public func updateData() {
    }
}
