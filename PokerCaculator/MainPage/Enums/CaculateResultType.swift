//
//  CaculateType.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import Foundation

// MARK: - 牌型的类型
enum CaculateResultType {
    /// 皇家同花顺：同一花色的10、J、Q、K、A
    case royalFlush
    /// 同花顺：同一花色的连续五张牌
    case straightFlush
    /// 四条：四张相同点数的牌
    case fourOfAKind
    /// 葫芦：三张相同点数的牌+一对
    case fullHouse
    /// 同花：五张相同花色的牌
    case flush
    /// 顺子：五张连续点数的牌
    case straight
    /// 三条：三张相同点数的牌
    case threeOfAKind
    /// 两对：两个对子
    case twoPairs
    /// 对子：一对相同点数的牌
    case pair
    /// 高牌：不符合以上任何牌型的牌
    case highCard
    /// 胜率
    case win
    /// 平局率
    case tie
    
    var info: CaculateInfo? {
        var title = ""
        switch self {
        case .royalFlush:
            title = "Royal Flush"
        case .straightFlush:
            title = "Straight Flush"
        case .fourOfAKind:
            title = "Four of a Kind"
        case .fullHouse:
            title = "Full House"
        case .flush:
            title = "Flush"
        case .straight:
            title = "Straight"
        case .threeOfAKind:
            title = "Three of a Kind"
        case .twoPairs:
            title = "Two Pairs"
        case .pair:
            title = "Pair"
        case .highCard:
            title = "High Card"
        case .win:
            title = "Win"
        case .tie:
            title = "Tie"
        }
        
        return CaculateInfo(title: title)
    }
}

struct CaculateInfo {
    var title: String
}
