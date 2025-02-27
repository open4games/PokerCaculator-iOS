//
//  BaseCollectionViewCellModel.swift
//  PokerUp
//
//  Created by Hsiao on 2024/10/16.
//  Copyright © 2024 Open4games. All rights reserved.
//

import UIKit

class BaseCollectionViewCellModel: NSObject {
    
    var cellType: AnyClass {
        return BaseTableViewCell.self
    }
    
    lazy var cellIdentifier: String = {
        return NSStringFromClass(cellType)
    }()
    
    var cellSize: CGSize {
        return CGSize.zero
    }

}
