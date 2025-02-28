//
//  CardTableViewModel.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import UIKit

class CardTableViewModel: BaseTableViewModel {

    var updatePlayerCountCallback:((_ count: UInt) -> Void)?
    
    private var royalFlush = CaculateCellModel(caculateType: .royalFlush)
    private var straightFlush = CaculateCellModel(caculateType: .straightFlush)
    private var fourOfAKind = CaculateCellModel(caculateType: .fourOfAKind)
    private var fullHouse = CaculateCellModel(caculateType: .fullHouse)
    private var flush = CaculateCellModel(caculateType: .flush)
    private var straight = CaculateCellModel(caculateType: .straight)
    private var threeOfAKind = CaculateCellModel(caculateType: .threeOfAKind)
    private var twoPairs = CaculateCellModel(caculateType: .twoPairs)
    private var pair = CaculateCellModel(caculateType: .pair)
    private var highCard = CaculateCellModel(caculateType: .highCard)
    private var win = CaculateCellModel(caculateType: .win)
    private var tie = CaculateCellModel(caculateType: .tie)
    private let player = ModifyPlayerCellModel(playerCount: 1)
    
    let sectionModel = BaseTableViewSectionModel()
    
    var playerCount: UInt {
        return self.player.playerCount
    }
    
    func setupData() {
        self.player.playerCount = 1
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
    
    func updateData(dic: [CaculateResultType: Double]) {
        dic.forEach { (key, value) in
            let value = dic[key] ?? 0
            switch key {
            case .royalFlush:
                self.royalFlush.caculatedRate = value
            case .straightFlush:
                self.straightFlush.caculatedRate = value
            case .fourOfAKind:
                self.fourOfAKind.caculatedRate = value
            case .fullHouse:
                self.fullHouse.caculatedRate = value
            case .flush:
                self.flush.caculatedRate = value
            case .straight:
                self.straight.caculatedRate = value
            case .threeOfAKind:
                self.threeOfAKind.caculatedRate = value
            case .twoPairs:
                self.twoPairs.caculatedRate = value
            case .pair:
                self.pair.caculatedRate = value
            case .highCard:
                self.highCard.caculatedRate = value
            case .win:
                self.win.caculatedRate = value
            case .tie:
                self.tie.caculatedRate = value
            }
        }
        
        self.reloadData()
    }
    
    func resetAction(playerCount: UInt = 1) {
        royalFlush.caculatedRate = 0
        straightFlush.caculatedRate = 0
        fourOfAKind.caculatedRate = 0
        fullHouse.caculatedRate = 0
        flush.caculatedRate = 0
        straight.caculatedRate = 0
        threeOfAKind.caculatedRate = 0
        twoPairs.caculatedRate = 0
        pair.caculatedRate = 0
        highCard.caculatedRate = 0
        win.caculatedRate = 0
        tie.caculatedRate = 0
        player.playerCount = playerCount
        reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let cell = cell as? ModifyPlayerCell {
            cell.updatePlayerCountCallback = { [weak self] (count) in
                guard let `self` = self else { return }
                self.player.playerCount = count
                self.updatePlayerCountCallback?(count)
            }
        }
        return cell
    }
}
