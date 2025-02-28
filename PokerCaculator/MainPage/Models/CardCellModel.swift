//
//  CardCellModel.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import UIKit

class CardCellModel: BaseCollectionViewCellModel {
    
    var card: CardStruct?
    
    var isSelected: Bool = false
    
    weak var viewModel: BaseCollectionViewModel?
    
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

extension CardCellModel {
    static func == (lhs: CardCellModel, rhs: CardCellModel) -> Bool {
        if lhs === rhs {
            return true
        }
        
        if lhs.card == nil && rhs.card == nil {
            return true
        }
        
        if lhs.card == nil || rhs.card == nil {
            return false
        }
        
        return lhs.card?.suit == rhs.card?.suit && lhs.card?.rank == rhs.card?.rank
    }
}
