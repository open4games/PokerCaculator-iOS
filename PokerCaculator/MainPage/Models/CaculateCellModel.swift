//
//  CaculateCellModel.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import UIKit

class CaculateCellModel: BaseTableViewCellModel {
    
    var caculateType: CaculateType?
    
    override var cellType: AnyClass {
        return CaculateCell.self
    }
    
    override var cellHeight: CGFloat {
        return 44
    }
    
    lazy var title: String? = {
        return self.caculateType?.info?.title
    }()
    
    lazy var value: String? = {
        return ""
    }()
    
    init(caculateType: CaculateType) {
        self.caculateType = caculateType
    }

}
