//
//  Const.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import Foundation
import UIKit

/// 牌之间的间距
let kCardMargin = 10.0
/// 牌的高度与宽度的比例
let kCardHeightWidthRatio = 1.3
/// 屏幕的宽度
let kScreenWidth = UIScreen.main.bounds.size.width
/// 水平方向间距总和
let kTotalMarginH = 14 * kCardMargin
/// 单张牌的宽度
let kCardWidth = (kScreenWidth - kTotalMarginH) / 13
/// 单张牌的高度
let kCardHeight = kCardWidth * kCardHeightWidthRatio
/// 整个控件的高度
let kCardTotalHeight = kCardHeight * 4 + kCardMargin * 5
