//
//  CaculateType.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import Foundation

enum CaculateType {
    case royalFlush
    case straightFlush
    case fourOfAKind
    case fullHouse
    case flush
    case straight
    case threeOfAKind
    case twoPairs
    case pair
    case highCard
    case win
    case tie
    case player
    
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
        case .player:
            title = "Player"
        }
        
        return CaculateInfo(title: title)
    }
}

struct CaculateInfo {
    var title: String
}
