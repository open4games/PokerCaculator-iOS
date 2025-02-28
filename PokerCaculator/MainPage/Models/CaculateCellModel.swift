//
//  CaculateCellModel.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import UIKit

class CaculateCellModel: BaseTableViewCellModel {
    
    var caculateType: CaculateResultType?
    
    override var cellType: AnyClass {
        return CaculateCell.self
    }
    
    override var cellHeight: CGFloat {
        return 44
    }
    
    lazy var title: String? = {
        return self.caculateType?.info?.title
    }()
    
    var value: String? {
        return String(format: "%.2f%%", self.caculatedRate)
    }
    
    /// 计算的概率
    var caculatedRate: Double = 0
    
    init(caculateType: CaculateResultType) {
        self.caculateType = caculateType
    }

}
