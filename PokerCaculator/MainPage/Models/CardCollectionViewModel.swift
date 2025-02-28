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
        let cards: [CardStruct] = DeckHelper.generateDeck()
        for card in cards {
            let card = CardStruct(suit: card.suit, rank: card.rank)
            let cellModel = CardCellModel(card: card)
            cellModel.viewModel = self
            sectionModel.cellModels.append(cellModel)
        }
        self.sectionModels = [sectionModel]
    }
    
    func resetAction() {
        if let sectionModel = self.sectionModels.first {
            let cellModels = sectionModel.cellModels
            for cellModel in cellModels {
                (cellModel as? CardCellModel)?.isSelected = false
            }
            reloadData()
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.getCellModel(indexPath: indexPath) as? CardCellModel {
            if model.isSelected {
                model.isSelected = false
                self.tapCardCallback?(model)
                if let cell = self.collectionView.cellForItem(at: indexPath) as? CardCell {
                    cell.updateData()
                }
                return
            }

            let currentSelectedCount = (self.sectionModels.first?.cellModels as? [CardCellModel])?
                .filter { $0.isSelected }
                .count ?? 0
            
            if currentSelectedCount < 7 {
                model.isSelected = true
                self.tapCardCallback?(model)
                if let cell = self.collectionView.cellForItem(at: indexPath) as? CardCell {
                    cell.updateData()
                }
            }
        }
    }

}
