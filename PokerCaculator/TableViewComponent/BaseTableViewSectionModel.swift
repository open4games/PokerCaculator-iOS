//
//  BaseTableViewSectionModel.swift
//  PokerX
//
//  Created by Hsiao on 2025/2/25.
//  Copyright © 2025 YOLO. All rights reserved.
//

import UIKit

class BaseTableViewSectionModel: NSObject {

    var cellModelArr = [BaseTableViewCellModel]()

    var headerViewHeight: CGFloat {
        return 0
    }

    var footerViewHeight: CGFloat {
        return 0
    }

    var headerView: UIView {
        return UIView()
    }

    var footerView: UIView {
        return UIView()
    }

}
