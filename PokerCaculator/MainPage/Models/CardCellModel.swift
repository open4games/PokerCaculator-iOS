//
//  CardCellModel.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import UIKit

class CardCellModel: BaseCollectionViewCellModel {
    
    var isInSelectionView: Bool = false
    var card: CardStruct?
    var isSelected: Bool = false
    
    lazy var rank: String? = {
        return self.card?.rank.displayName
    }()
    
    lazy var suit: String? = {
        return self.card?.suit.displayName
    }()
    
    lazy var textColor: UIColor = {
        var result = UIColor.red
        if self.card?.suit == .spade || self.card?.suit == .club {
            result = .black
        }
        return result
    }()
    
    override var cellType: AnyClass {
        return CardCell.self
    }
    
    override var cellSize: CGSize {
        return CGSize(width: kCardWidth, height: kCardHeight)
    }
    
    init(card: CardStruct?) {
        self.card = card
    }
}

// MARK: - Equatable
extension CardCellModel {
    static func == (lhs: CardCellModel, rhs: CardCellModel) -> Bool {
        // 如果两个对象引用相同，它们是相等的
        if lhs === rhs {
            return true
        }
        
        // 如果两个对象的卡牌都为nil，认为它们相等
        if lhs.card == nil && rhs.card == nil {
            return true
        }
        
        // 如果只有一个对象的卡牌为nil，它们不相等
        if lhs.card == nil || rhs.card == nil {
            return false
        }
        
        // 比较卡牌的花色和点数
        return lhs.card?.suit == rhs.card?.suit && lhs.card?.rank == rhs.card?.rank
    }
}
