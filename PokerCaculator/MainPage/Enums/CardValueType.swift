//
//  CardValueType.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import Foundation

/// 点数枚举（含数值映射）
enum CardValueType: Int, CaseIterable {
    /// A
    case ace = 1
    /// 2
    case two = 2
    /// 3
    case three = 3
    /// 4
    case four = 4
    /// 5
    case five = 5
    /// 6
    case six = 6
    /// 7
    case seven = 7
    /// 8
    case eight = 8
    /// 9
    case nine = 9
    /// 10
    case ten = 10
    /// J
    case jack = 11
    /// Q
    case queen = 12
    /// K
    case king = 13
    
    var displayName: String {
        switch self {
        case .ace: return "A"
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        default: return "\(self.rawValue)"
        }
    }
    
    // 扩展：判断是否为 face card（J/Q/K/A）
    var isFaceCard: Bool {
        return self == .jack || self == .queen || self == .king || self == .ace
    }
}
