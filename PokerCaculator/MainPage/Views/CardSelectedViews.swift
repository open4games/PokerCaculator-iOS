//
//  CardSelectedViews.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import UIKit

class CardSelectedViews: UIView {
    
    var handCardCellModels: [CardCellModel] = []
    var pubCardCellModels: [CardCellModel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        let pubCollectionView = self.pubCardsViewModel.collectionView
        let handCollectionView = self.handCarsViewModel.collectionView
        
        pubCollectionView.backgroundColor = .clear
        handCollectionView.backgroundColor = .clear
        
        self.addSubview(pubCollectionView)
        self.addSubview(handCollectionView)
        self.addSubview(self.pubLabel)
        
        let pubW = kCardWidth * 6 + kCardMargin * 4
        let handW = kCardWidth * 2 + kCardMargin * 1
        
        pubCollectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(kCardHeight)
            make.top.equalToSuperview().offset(kCardMargin)
            make.width.equalTo(pubW)
        }
        
        handCollectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(kCardHeight)
            make.bottom.equalToSuperview().offset(-kCardMargin)
            make.width.equalTo(handW)
        }
        
        self.pubLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pubCollectionView.snp.bottom).offset(2)
        }
        
    }
    
    func setupData() {
        self.handCarsViewModel.setupData()
        self.handCarsViewModel.reloadData()
        
        self.pubCardsViewModel.setupData()
        self.pubCardsViewModel.reloadData()
        
        self.updatePubTitle()
    }
    
    func addCardAction(model: CardCellModel) -> Bool {
        // 打印当前状态，用于调试
        print("当前手牌数量: \(self.handCardCellModels.count), 公共牌数量: \(self.pubCardCellModels.count)")
        model.isInSelectionView = true
        if self.handCardCellModels.count < 2 {
            // 如果hand区域还没满，添加到hand
            self.handCardCellModels.append(model)
            let sectionModel = BaseCollectionSectionModel()
            sectionModel.cellModels = self.handCardCellModels
            self.handCarsViewModel.sectionModels = [sectionModel]
            self.handCarsViewModel.reloadData()
            print("添加到手牌后，手牌数量: \(self.handCardCellModels.count)")
            return true
        } else if self.pubCardCellModels.count < 5 {
            // 如果hand满了且pub还没满，添加到pub
            self.pubCardCellModels.append(model)
            let sectionModel = BaseCollectionSectionModel()
            sectionModel.cellModels = self.pubCardCellModels
            self.pubCardsViewModel.sectionModels = [sectionModel]
            self.pubCardsViewModel.reloadData()
            self.updatePubTitle()
            print("添加到公共牌后，公共牌数量: \(self.pubCardCellModels.count)")
            return true
        }
        // 如果hand和pub都满了，返回失败
        print("手牌和公共牌都已满")
        return false
    }
    
    func removeCardAction(model: CardCellModel) {
        // 打印当前状态
        print("移除前 - 手牌数量: \(self.handCardCellModels.count), 公共牌数量: \(self.pubCardCellModels.count)")
        
        var removed = false
        
        // 从手牌中查找并移除
        if let index = self.handCardCellModels.firstIndex(where: { $0 === model }) {
            self.handCardCellModels.remove(at: index)
            let sectionModel = BaseCollectionSectionModel()
            sectionModel.cellModels = self.handCardCellModels
            self.handCarsViewModel.sectionModels = [sectionModel]
            self.handCarsViewModel.reloadData()
            removed = true
            model.isInSelectionView = false
            print("从手牌中移除了一张牌")
        }
        
        // 从公共牌中查找并移除
        if let index = self.pubCardCellModels.firstIndex(where: { $0 === model }) {
            self.pubCardCellModels.remove(at: index)
            let sectionModel = BaseCollectionSectionModel()
            sectionModel.cellModels = self.pubCardCellModels
            self.pubCardsViewModel.sectionModels = [sectionModel]
            self.pubCardsViewModel.reloadData()
            removed = true
            model.isInSelectionView = false
            print("从公共牌中移除了一张牌")
            self.updatePubTitle()
        }
        
        if !removed {
            print("警告：未找到要移除的牌")
        }
        
        // 打印移除后的状态
        print("移除后 - 手牌数量: \(self.handCardCellModels.count), 公共牌数量: \(self.pubCardCellModels.count)")
    }
    
    // 清空所有选中的牌
    func clearAllCards() {
        // 清空手牌数组
        self.handCardCellModels.removeAll()
        
        // 清空公共牌数组
        self.pubCardCellModels.removeAll()
        
        // 更新手牌UI
        let handSectionModel = BaseCollectionSectionModel()
        handSectionModel.cellModels = [CardCellModel(card: nil), CardCellModel(card: nil)]
        self.handCarsViewModel.sectionModels = [handSectionModel]
        self.handCarsViewModel.reloadData()
        
        // 更新公共牌UI
        let pubSectionModel = BaseCollectionSectionModel()
        pubSectionModel.cellModels = [CardCellModel(card: nil), CardCellModel(card: nil), CardCellModel(card: nil), CardCellModel(card: nil), CardCellModel(card: nil)]
        self.pubCardsViewModel.sectionModels = [pubSectionModel]
        self.pubCardsViewModel.reloadData()
        self.updatePubTitle()
        print("已清空所有选中的牌")
    }
    
    private func updatePubTitle() {
        var title = "Pre-flop"
        let pubCount = self.pubCardCellModels.count
        if pubCount < 1 {
            title = "Flop"
        } else if pubCount < 4 {
            title = "Turn"
        } else if pubCount == 4 {
            title = "River"
        } else if pubCount == 5 {
            title = "Showdown"
        }
        self.pubLabel.text = title
    }
    
    private lazy var handCarsViewModel: SelectedCardViewModel = {
        let vm = SelectedCardViewModel(type: .hand)
        return vm
    }()
    
    private lazy var pubCardsViewModel: SelectedCardViewModel = {
        let vm = SelectedCardViewModel(type: .pub)
        return vm
    }()
    
    private lazy var pubLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

}
