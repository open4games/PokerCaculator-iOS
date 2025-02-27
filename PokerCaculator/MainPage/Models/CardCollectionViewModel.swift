//
//  CardCollectionViewModel.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import UIKit

class CardCollectionViewModel: BaseCollectionViewModel {
    
    var tapCardCallback: ((_ model: CardCellModel) -> Void)?
    
    override func setupData() {
        
        self.layout.minimumLineSpacing = kCardMargin
        self.layout.minimumInteritemSpacing = kCardMargin
        
        let sectionModel = BaseCollectionSectionModel()
        for i in 1...4 {
            if let suit = CardSuitType(rawValue: i){
                for j in 1...13 {
                    if let rank = CardValueType(rawValue: j) {
                        let card = CardStruct(suit: suit, rank: rank)
                        let cellModel = CardCellModel(card: card)
                        sectionModel.cellModels.append(cellModel)
                    }
                }
            }
        }
        
        self.sectionModels = [sectionModel]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.getCellModel(indexPath: indexPath) as? CardCellModel {
            // 如果当前卡片是选中状态，允许取消选中
            if model.isSelected {
                model.isSelected = false
                self.tapCardCallback?(model)
                if let cell = self.collectionView.cellForItem(at: indexPath) as? CardCell {
                    cell.updateData()
                }
                return
            }
            
            // 如果当前卡片是未选中状态，需要检查是否可以选中
            // 获取当前已选中的卡片数量
            let currentSelectedCount = (self.sectionModels.first?.cellModels as? [CardCellModel])?
                .filter { $0.isSelected }
                .count ?? 0
            
            // 德州扑克最多选择7张牌（2张手牌 + 5张公共牌）
            if currentSelectedCount < 7 {
                model.isSelected = true
                self.tapCardCallback?(model)
                if let cell = self.collectionView.cellForItem(at: indexPath) as? CardCell {
                    cell.updateData()
                }
            } else {
                // 可以在这里添加提示，告诉用户已经达到最大选择数量
                print("已达到最大选择数量：7张牌")
                // 可以使用UIAlertController或Toast提示用户
            }
        }
    }

}
