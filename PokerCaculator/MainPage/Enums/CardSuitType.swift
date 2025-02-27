//
//  CardSuitType.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import Foundation

/// 花色枚举
enum CardSuitType: Int, CaseIterable {
    /// 黑桃
    case spade = 1
    /// 红心
    case heart
    /// 梅花
    case club
    /// 方块
    case diamond
    
    var displayName: String {
        switch self {
        case .spade: return "♠️"
        case .heart: return "♥️"
        case .club: return "♣️"
        case .diamond: return "♦️"
        }
    }
}
