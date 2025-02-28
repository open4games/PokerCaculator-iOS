//
//  CardStruct.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import Foundation

/// 扑克牌结构体
struct CardStruct: Equatable {
    
    let suit: CardSuitType
    let rank: CardRankType
    
    var fullDescription: String {
        "\(suit.displayName) \(rank.displayName)"
    }
    
    var numericalValue: Int {
        rank.rawValue
    }
    
    static func == (lhs: CardStruct, rhs: CardStruct) -> Bool {
        return lhs.suit == rhs.suit && lhs.rank == rhs.rank
    }
}
