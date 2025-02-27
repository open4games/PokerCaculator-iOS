//
//  BaseTableViewCellModel.swift
//  PokerX
//
//  Created by Hsiao on 2025/2/25.
//  Copyright © 2025 YOLO. All rights reserved.
//

import UIKit

class BaseTableViewCellModel: NSObject {
    var cellHeight: CGFloat {
        return 40
    }

    var cellType: AnyClass {
        return BaseTableViewCell.self
    }

    var cellIdenfitier: String {
        return NSStringFromClass(self.cellType)
    }
}
