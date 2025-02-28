//
//  PokerCaculator.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/27.
//

import Foundation

// MARK: - 扩展CardStruct以支持比较操作
extension CardStruct: Comparable {
    public static func < (lhs: CardStruct, rhs: CardStruct) -> Bool {
        return lhs.numericalValue < rhs.numericalValue
    }
    
    // 获取用于计算的数值，A可以作为最大牌
    var calculationValue: Int {
        if rank == .ace {
            return 14 // A在计算中视为14点
        }
        return rank.rawValue
    }
}

// MARK: - Deck 辅助类
class DeckHelper {
    /// 生成一副扑克牌
    static func generateDeck() -> [CardStruct] {
        var deck = [CardStruct]()
        
        for suit in CardSuitType.allCases {
            for rank in CardRankType.allCases {
                deck.append(CardStruct(suit: suit, rank: rank))
            }
        }
        return deck
    }
    
    static func drawRandomCard(deck: inout [CardStruct]) -> CardStruct? {
        if deck.isEmpty {
            return nil
        }
        deck.shuffle()
        return deck.removeFirst()
    }
    
    static func removeCard(deck: inout [CardStruct], card: CardStruct) {
        deck.removeAll { $0 == card }
    }
    
    static func removeCards(deck: inout [CardStruct], cards: [CardStruct]) {
        for card in cards {
            removeCard(deck: &deck, card: card)
        }
    }
}

// MARK: - HandTypeEvaluator 类
class HandTypeEvaluator {
    /// 检查是否为同花顺或皇家同花顺
    static func checkStraightFlush(hand: [CardStruct]) -> CaculateResultType? {
        // 按花色分组
        var suitGroups = [CardSuitType: [CardStruct]]()
        
        for card in hand {
            if suitGroups[card.suit] == nil {
                suitGroups[card.suit] = [card]
            } else {
                suitGroups[card.suit]?.append(card)
            }
        }
        
        // 检查每个花色组是否有5张或更多的牌
        for (_, cards) in suitGroups {
            if cards.count >= 5 {
                // 按点数排序
                let sortedCards = cards.sorted { $0.calculationValue < $1.calculationValue }
                
                // 检查是否有顺子
                if let straightType = checkStraight(hand: sortedCards) {
                    // 检查是否为皇家同花顺
                    if straightType == .royalFlush {
                        return .royalFlush
                    }
                    return .straightFlush
                }
            }
        }
        
        return nil
    }
    
    /// 检查是否为顺子
    static func checkStraight(hand: [CardStruct]) -> CaculateResultType? {
        guard hand.count >= 5 else { return nil }
        
        // 去重并按点数排序
        var uniqueValues = Set<Int>()
        for card in hand {
            uniqueValues.insert(card.calculationValue)
        }
        
        let sortedValues = Array(uniqueValues).sorted()
        
        // 特殊情况：A-2-3-4-5 顺子
        if uniqueValues.contains(14) && uniqueValues.contains(2) && uniqueValues.contains(3) && uniqueValues.contains(4) && uniqueValues.contains(5) {
            return .straight
        }
        
        // 检查是否有5张连续的牌
        var consecutiveCount = 1
        var startIndex = 0
        
        while startIndex <= sortedValues.count - 5 {
            consecutiveCount = 1
            for i in startIndex..<sortedValues.count - 1 {
                if sortedValues[i + 1] - sortedValues[i] == 1 {
                    consecutiveCount += 1
                    if consecutiveCount >= 5 {
                        // 检查是否为皇家同花顺 (10-J-Q-K-A)
                        if sortedValues[i + 1] == 14 && sortedValues[i] == 13 && sortedValues[i - 1] == 12 && sortedValues[i - 2] == 11 && sortedValues[i - 3] == 10 {
                            return .royalFlush
                        }
                        return .straight
                    }
                } else if sortedValues[i + 1] - sortedValues[i] > 1 {
                    startIndex = i + 1
                    break
                }
            }
            startIndex += 1
        }
        
        return nil
    }
    
    /// 检查是否为同花
    static func hasFlush(hand: [CardStruct]) -> Bool {
        var suitCounts = [CardSuitType: Int]()
        
        for card in hand {
            suitCounts[card.suit, default: 0] += 1
        }
        
        return suitCounts.values.contains { $0 >= 5 }
    }
    
    /// 检查是否有n张相同点数的牌
    static func hasNOfAKind(hand: [CardStruct], n: Int) -> Bool {
        var rankCounts = [Int: Int]()
        
        for card in hand {
            rankCounts[card.calculationValue, default: 0] += 1
        }
        
        return rankCounts.values.contains { $0 >= n }
    }
    
    /// 检查是否为葫芦（一组三条加一组对子）
    static func hasFullHouse(hand: [CardStruct]) -> Bool {
        var rankCounts = [Int: Int]()
        
        for card in hand {
            rankCounts[card.calculationValue, default: 0] += 1
        }
        
        let hasThreeOfAKind = rankCounts.values.contains { $0 >= 3 }
        let pairCount = rankCounts.values.filter { $0 >= 2 }.count
        
        // 如果有四条，那么也满足"有三条"的条件，所以需要特别检查
        if hasThreeOfAKind && pairCount >= 2 {
            // 检查是否只是一个四条
            let hasFourOfAKind = rankCounts.values.contains { $0 >= 4 }
            if hasFourOfAKind && pairCount == 1 {
                return false
            }
            return true
        }
        
        return false
    }
    
    /// 检查是否为两对
    static func hasTwoPair(hand: [CardStruct]) -> Bool {
        var rankCounts = [Int: Int]()
        
        for card in hand {
            rankCounts[card.calculationValue, default: 0] += 1
        }
        
        let pairCount = rankCounts.values.filter { $0 >= 2 }.count
        return pairCount >= 2
    }
    
    /// 评估手牌类型
    static func evaluateHand(hand: [CardStruct]) -> CaculateResultType {
        guard hand.count >= 5 else {
            return .highCard
        }
        
        // 按照点数对手牌进行排序
        let sortedHand = hand.sorted()
        
        // 检查是否为同花顺或皇家同花顺
        if let straightFlushType = checkStraightFlush(hand: sortedHand) {
            return straightFlushType
        }
        
        // 检查是否为四条
        if hasNOfAKind(hand: sortedHand, n: 4) {
            return .fourOfAKind
        }
        
        // 检查是否为葫芦
        if hasFullHouse(hand: sortedHand) {
            return .fullHouse
        }
        
        // 检查是否为同花
        if hasFlush(hand: sortedHand) {
            return .flush
        }
        
        // 检查是否为顺子
        if let _ = checkStraight(hand: sortedHand) {
            return .straight
        }
        
        // 检查是否为三条
        if hasNOfAKind(hand: sortedHand, n: 3) {
            return .threeOfAKind
        }
        
        // 检查是否为两对
        if hasTwoPair(hand: sortedHand) {
            return .twoPairs
        }
        
        // 检查是否为一对
        if hasNOfAKind(hand: sortedHand, n: 2) {
            return .pair
        }
        
        // 如果以上都不是，则为高牌
        return .highCard
    }
    
    /// 评估最佳手牌
    static func evaluateBestHand(hand: [CardStruct], communityCards: [CardStruct]) -> CaculateResultType {
        // 将手牌和公共牌合并
        var allCards = hand
        allCards.append(contentsOf: communityCards)
        // 评估手牌类型
        return evaluateHand(hand: allCards)
    }
    
    /// 比较两种手牌类型的大小
    static func compareHandTypes(_ type1: CaculateResultType, _ type2: CaculateResultType) -> Int {
        let order: [CaculateResultType] = [
            .royalFlush,
            .straightFlush,
            .fourOfAKind,
            .fullHouse,
            .flush,
            .straight,
            .threeOfAKind,
            .twoPairs,
            .pair,
            .highCard
        ]
        
        guard let index1 = order.firstIndex(of: type1),
              let index2 = order.firstIndex(of: type2) else {
            return 0 // 如果找不到类型，则认为相等
        }
        
        if index1 < index2 {
            return 1 // type1更大
        } else if index1 > index2 {
            return -1 // type2更大
        } else {
            return 0 // 相等
        }
    }
}

// MARK: - PokerCalculator 类
class PokerCalculator {
    private static let NUM_SIMULATIONS = 10000 // 模拟次数
    
    static var shared: PokerCalculator = {
        return PokerCalculator()
    }()
    
    private init() {}
    
    func calculate(playerCount: UInt, handCards: [CardStruct], pubCards: [CardStruct], complete: ((_ result: [CaculateResultType: Double]) -> Void)) {
        // 定义手牌
        var wins = 0
        var ties = 0
        var resultMap = [CaculateResultType: Double]()
        
        // 记录每种牌型出现的次数
        var handTypeRecordDic: [CaculateResultType: Int] = [:]
        let handTypes: [CaculateResultType] = [
            .royalFlush,
            .straightFlush,
            .fourOfAKind,
            .fullHouse,
            .flush,
            .straight,
            .threeOfAKind,
            .twoPairs,
            .pair,
            .highCard
        ]
        
        for type in handTypes {
            handTypeRecordDic[type] = 0
        }
        
        // 进行多次模拟
        for _ in 0..<PokerCalculator.NUM_SIMULATIONS {
            var deck = DeckHelper.generateDeck()

            DeckHelper.removeCards(deck: &deck, cards: handCards)
            DeckHelper.removeCards(deck: &deck, cards: pubCards)
            
            // 如果没有指定玩家手牌，则随机生成
            var finalPlayHand = handCards
            if finalPlayHand.isEmpty {
                if let card1 = DeckHelper.drawRandomCard(deck: &deck),
                   let card2 = DeckHelper.drawRandomCard(deck: &deck) {
                    finalPlayHand = [card1, card2]
                }
            }
            
            // 如果没有指定公共牌，则随机生成
            var finalCommunityCards = pubCards
            let neededCommunityCards = 5 - finalCommunityCards.count
            
            for _ in 0..<neededCommunityCards {
                if let card = DeckHelper.drawRandomCard(deck: &deck) {
                    finalCommunityCards.append(card)
                }
            }
            
            // 生成其他玩家的手牌
            var opponentsHands = [[CardStruct]]()
            for _ in 0..<(playerCount - 1) {
                if let card1 = DeckHelper.drawRandomCard(deck: &deck),
                   let card2 = DeckHelper.drawRandomCard(deck: &deck) {
                    opponentsHands.append([card1, card2])
                }
            }
            
            // 评估玩家的手牌
            let playerHandType = HandTypeEvaluator.evaluateBestHand(hand: finalPlayHand, communityCards: finalCommunityCards)
            
            // 记录玩家的牌型
            handTypeRecordDic[playerHandType, default: 0] += 1
            
            // 评估对手的手牌
            var bestHands = [CaculateResultType]()
            for opponentHand in opponentsHands {
                bestHands.append(HandTypeEvaluator.evaluateBestHand(hand: opponentHand, communityCards: finalCommunityCards))
            }
            
            // 判断玩家的胜负
            var isWin = false
            var isTie = false
            
            for opponentHandType in bestHands {
                let comparison = HandTypeEvaluator.compareHandTypes(playerHandType, opponentHandType)
                
                if comparison < 0 {
                    isWin = true
                    break
                } else if comparison == 0 {
                    isTie = true
                }
            }
            
            if isWin {
                if isTie {
                    ties += 1
                } else  {
                    wins += 1
                }
            }
        }
        
        // 输出每种牌型的概率
        for type in handTypes {
            let probability = Double(handTypeRecordDic[type] ?? 0) / Double(PokerCalculator.NUM_SIMULATIONS) * 100
            resultMap[type] = probability
        }
        
        // 计算胜率和平局率
        let winRate = Double(wins) / Double(PokerCalculator.NUM_SIMULATIONS) * 100
        let tieRate = Double(ties) / Double(PokerCalculator.NUM_SIMULATIONS) * 100
        
        resultMap[CaculateResultType.win] = winRate
        resultMap[CaculateResultType.tie] = tieRate
        print("resultMap=\(resultMap)")
        complete(resultMap)
    }
}
