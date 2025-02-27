//
//  CardTableViewModel.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import UIKit

class CardTableViewModel: BaseTableViewModel {

    func setupData() {
        let royalFlush = CaculateCellModel(caculateType: .royalFlush)
        let straightFlush = CaculateCellModel(caculateType: .straightFlush)
        let fourOfAKind = CaculateCellModel(caculateType: .fourOfAKind)
        let fullHouse = CaculateCellModel(caculateType: .fullHouse)
        let flush = CaculateCellModel(caculateType: .flush)
        let straight = CaculateCellModel(caculateType: .straight)
        let threeOfAKind = CaculateCellModel(caculateType: .threeOfAKind)
        let twoPairs = CaculateCellModel(caculateType: .twoPairs)
        let pair = CaculateCellModel(caculateType: .pair)
        let highCard = CaculateCellModel(caculateType: .highCard)
        let win = CaculateCellModel(caculateType: .win)
        let tie = CaculateCellModel(caculateType: .tie)
        let player = CaculateCellModel(caculateType: .player)
        
        let sectionModel = BaseTableViewSectionModel()
        sectionModel.cellModelArr = [
            royalFlush,
            straightFlush,
            fourOfAKind,
            fullHouse,
            flush,
            straight,
            threeOfAKind,
            twoPairs,
            pair,
            highCard,
            win,
            tie,
            player,
        ]
        self.sectionDataArr = [sectionModel]
    }
}
