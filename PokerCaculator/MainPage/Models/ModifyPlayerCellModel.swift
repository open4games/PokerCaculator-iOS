//
//  ModifyPlayerCellModel.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/28.
//

import UIKit

class ModifyPlayerCellModel: BaseTableViewCellModel {
    
    override var cellType: AnyClass {
        return ModifyPlayerCell.self
    }
    
    override var cellHeight: CGFloat {
        return 44
    }
    
    lazy var title: String? = {
        return "Player"
    }()
    
    /// 玩家人数
    var playerCount: UInt = 0
    
    init(playerCount: UInt) {
        self.playerCount = playerCount
    }
}
