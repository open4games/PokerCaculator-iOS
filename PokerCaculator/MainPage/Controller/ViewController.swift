//
//  ViewController.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/25.
//

import UIKit
import SnapKit

let kMainGreenColor = UIColor(red: 55/255, green: 92/255, blue: 56/255, alpha: 1.0)

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.configureNavigationBarAppearance()
        self.setupViews()
        self.setupData()
    }
    
    private func setupNavigationBar() {
        if #available(iOS 14.0, *) {
            let menuItems = [
                UIAction(title: "Add Player", image: UIImage(systemName: "person.badge.plus"), handler: { [weak self] _ in
                    self?.handleAddPlayer()
                }),
                UIAction(title: "Reset", image: UIImage(systemName: "arrow.clockwise"), handler: { [weak self] _ in
                    self?.handleReset()
                }),
                UIAction(title: "Privacy Policy", image: UIImage(systemName: "hand.raised.fill"), handler: { [weak self] _ in
                    self?.handlePrivacyPolicy()
                }),
                UIAction(title: "App Info", image: UIImage(systemName: "info.circle"), handler: { [weak self] _ in
                    self?.handleAppInfo()
                })
            ]
            
            let menu = UIMenu(title: "", children: menuItems)
            let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), menu: menu)
            navigationItem.rightBarButtonItem = menuButton
        } else {
            // Fallback for iOS 13 and below
            let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(handleMenuAction))
            navigationItem.rightBarButtonItem = menuButton
        }
    }
    
    private func configureNavigationBarAppearance() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = kMainGreenColor
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
        } else {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = kMainGreenColor
        }
    }
    
    func setupViews() {
        self.view.backgroundColor = kMainGreenColor
        self.title = "Poker Caculator"
        
        self.view.addSubview(self.cardBox)
        let collectionView = collectionViewModel.collectionView
        collectionView.contentInset = UIEdgeInsets(top: kCardMargin, left: kCardMargin, bottom: kCardMargin, right: kCardMargin)
        self.cardBox.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.clear
        
        self.view.addSubview(self.selectionView)
        
        let tableView = self.tableViewModel.tableView
        tableView.backgroundColor = .clear
        self.view.addSubview(tableView)
        
        let boxH = kCardTotalHeight + Layout.safeAreaInsets.bottom
        self.cardBox.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(boxH)
            make.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kCardTotalHeight)
        }
        
        self.selectionView.snp.makeConstraints { make in
            make.size.equalTo(self.selectionView.frame.size)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.cardBox.snp.top)
        }
    
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(selectionView.snp.top).offset(-10)
        }
    }
    
    func setupData() {
        self.tableViewModel.setupData()
        self.tableViewModel.reloadData()
        
        self.collectionViewModel.setupData()
        self.collectionViewModel.reloadData()
    }
    
    @objc func handleTapCardAction(model: CardCellModel) {
        if model.isSelected {
            // 如果是选中状态，添加到selectionView
            // selectionView内部会处理是添加到hand还是pub
            let success = self.selectionView.addCardAction(model: model)
            
            // 如果添加失败（例如已达到最大数量限制），则恢复卡片的未选中状态
            if !success {
                model.isSelected = false
                // 找到对应的cell并更新UI
                let sectionModels = self.collectionViewModel.sectionModels
                for (sectionIndex, sectionModel) in sectionModels.enumerated() {
                    if let cellModels = sectionModel.cellModels as? [CardCellModel] {
                        for (itemIndex, cellModel) in cellModels.enumerated() {
                            if cellModel === model {
                                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                                if let cell = self.collectionViewModel.collectionView.cellForItem(at: indexPath) as? CardCell {
                                    cell.updateData()
                                }
                                break
                            }
                        }
                    }
                }

            }
        } else {
            // 如果是取消选中状态，从selectionView中移除
            self.selectionView.removeCardAction(model: model)
        }
    }
    
    // 辅助方法：根据模型查找对应的IndexPath
    private func findIndexPathForModel(model: CardCellModel) -> IndexPath? {
        if let sectionModels = self.collectionViewModel.sectionModels as? [BaseCollectionSectionModel] {
            for (sectionIndex, sectionModel) in sectionModels.enumerated() {
                if let cellModels = sectionModel.cellModels as? [CardCellModel] {
                    for (itemIndex, cellModel) in cellModels.enumerated() {
                        if cellModel === model {
                            return IndexPath(item: itemIndex, section: sectionIndex)
                        }
                    }
                }
            }
        }
        return nil
    }
    
    // MARK: - Menu Actions
    private func handleAddPlayer() {
        // TODO: Implement add player functionality
    }
    
    private func handleReset() {
        // 清空所有选中的牌
        
        // 1. 清空CardSelectedViews中的手牌和公共牌
        self.selectionView.clearAllCards()
        
        // 2. 重置CardCollectionViewModel中所有牌的选中状态
        if let sectionModels = self.collectionViewModel.sectionModels as? [BaseCollectionSectionModel] {
            for sectionModel in sectionModels {
                if let cellModels = sectionModel.cellModels as? [CardCellModel] {
                    for cellModel in cellModels {
                        cellModel.isSelected = false
                    }
                }
            }
        }
        
        // 3. 刷新CollectionView以更新UI
        self.collectionViewModel.collectionView.reloadData()
        
        print("已重置所有选中的牌")
    }
    
    private func handlePrivacyPolicy() {
        // TODO: Show privacy policy
    }
    
    private func handleAppInfo() {
        // TODO: Show app info
    }
    
    @objc private func handleMenuAction() {
        // Fallback for iOS 13 and below
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addPlayerAction = UIAlertAction(title: "Add Player", style: .default) { [weak self] _ in
            self?.handleAddPlayer()
        }
        
        let resetAction = UIAlertAction(title: "Reset", style: .default) { [weak self] _ in
            self?.handleReset()
        }
        
        let privacyPolicyAction = UIAlertAction(title: "Privacy Policy", style: .default) { [weak self] _ in
            self?.handlePrivacyPolicy()
        }
        
        let appInfoAction = UIAlertAction(title: "App Info", style: .default) { [weak self] _ in
            self?.handleAppInfo()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        [addPlayerAction, resetAction, privacyPolicyAction, appInfoAction, cancelAction].forEach {
            alertController.addAction($0)
        }
        
        present(alertController, animated: true)
    }
    
    private lazy var cardBox: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var tableViewModel: CardTableViewModel = {
        let vm = CardTableViewModel()
        return vm
    }()
    
    private lazy var collectionViewModel: CardCollectionViewModel = {
        let vm = CardCollectionViewModel()
        vm.tapCardCallback = { [weak self] (model) in
            guard let `self` = self else { return }
            self.handleTapCardAction(model: model)
        }
        return vm
    }()
    
    private lazy var selectionView: CardSelectedViews = {
        let view = CardSelectedViews(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 100))
        view.backgroundColor = .clear
        return view
    }()

}
