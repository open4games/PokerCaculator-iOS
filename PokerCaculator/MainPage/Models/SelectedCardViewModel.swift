//
//  SelectedCardViewModel.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import UIKit

/// 选中的牌的类型
enum CardSelectedType {
    /// 手牌
    case hand
    /// 公共牌
    case pub
}

class SelectedCardViewModel: BaseCollectionViewModel {
    
    var type: CardSelectedType = .hand
    
    init(type: CardSelectedType) {
        self.type = type
    }
    
    override func setupData() {
        self.layout.minimumInteritemSpacing = kCardMargin
        let sectionModel = BaseCollectionSectionModel()
        if self.type == .hand {
            let model1 = CardCellModel(card: nil)
            let model2 = CardCellModel(card: nil)
            sectionModel.cellModels = [model1, model2]
        } else if self.type == .pub {
            let model1 = CardCellModel(card: nil)
            let model2 = CardCellModel(card: nil)
            let model3 = CardCellModel(card: nil)
            let model4 = CardCellModel(card: nil)
            let model5 = CardCellModel(card: nil)
            sectionModel.cellModels = [model1, model2, model3, model4, model5]
        }

        self.sectionModels = [sectionModel]
    }

}
