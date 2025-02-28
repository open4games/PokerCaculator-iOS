//
//  MainViewController.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/25.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupViews()
        self.setupData()
    }
    
    private func setupNavigationBar() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = kMainGreenColor
            
            // 设置导航栏标题文本颜色为白色
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            
            // 设置导航栏按钮项的文本颜色为白色
            navigationController?.navigationBar.tintColor = .white
        } else {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = kMainGreenColor
            
            // 设置导航栏标题文本颜色为白色
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            // 设置导航栏按钮项的文本颜色为白色
            navigationController?.navigationBar.tintColor = .white
        }
        
        if #available(iOS 14.0, *) {
            let menuItems = [
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
    
    func setupViews() {
        self.view.backgroundColor = kMainGreenColor
        self.title = "Poker Caculator"

        let collectionView = collectionViewModel.collectionView
        collectionView.contentInset = UIEdgeInsets(top: kCardMargin, left: kCardMargin, bottom: kCardMargin, right: kCardMargin)
        self.cardBox.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.clear
        
        
        let tableView = self.tableViewModel.tableView
        tableView.backgroundColor = .clear
        self.view.addSubview(tableView)
        
        collectionView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kCardTotalHeight)
        }
    
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        tableView.tableFooterView = self.footerView
    }
    
    func setupData() {
        self.tableViewModel.setupData()
        self.tableViewModel.reloadData()
        
        self.collectionViewModel.setupData()
        self.collectionViewModel.reloadData()
    }
    
    @objc func handleTapCardAction(model: CardCellModel) {
        if model.isSelected {
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
            self.selectionView.removeCardAction(model: model)
        }
        let count = self.tableViewModel.playerCount
        let enabled = self.selectionView.handCardCellModels.count == 2
        if enabled {
            self.handleCaculateAction(playerCount: self.tableViewModel.playerCount)
        } else {
            
            self.tableViewModel.resetAction(playerCount: count)
        }
    }
    
    func handleCaculateAction(playerCount: UInt) {
        let handCards = selectionView.getHandCards()
        let pubCards = selectionView.getPubCards()
        
        DispatchQueue.main.async {
            PokerCalculator.shared.calculate(playerCount: playerCount, handCards: handCards, pubCards: pubCards) {[weak self] result in
                guard let `self` = self else { return }
                self.tableViewModel.updateData(dic: result)
            }
        }
        
    }
    
    private func findIndexPathForModel(model: CardCellModel) -> IndexPath? {
        let sectionModels = self.collectionViewModel.sectionModels
        for (sectionIndex, sectionModel) in sectionModels.enumerated() {
            if let cellModels = sectionModel.cellModels as? [CardCellModel] {
                for (itemIndex, cellModel) in cellModels.enumerated() {
                    if cellModel === model {
                        return IndexPath(item: itemIndex, section: sectionIndex)
                    }
                }
            }
        }
        return nil
    }
    
    // MARK: - Menu Actions
    private func handleReset() {
        self.tableViewModel.resetAction()
        self.selectionView.resetAction()
        self.collectionViewModel.resetAction()
    }
    
    private func handlePrivacyPolicy() {
        let vc = PrivacyViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleAppInfo() {
        let vc = AppInfoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func handleMenuAction() {
        // Fallback for iOS 13 and below
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
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
        
        [resetAction, privacyPolicyAction, appInfoAction, cancelAction].forEach {
            alertController.addAction($0)
        }
        
        present(alertController, animated: true)
    }
    
    func updatePlayerCountAction(count: UInt) {
        handleCaculateAction(playerCount: count)
    }
    
    private lazy var cardBox: UIView = {
        let w = kScreenWidth
        let h = kCardTotalHeight + Layout.safeAreaInsets.bottom
        let view = UIView(frame: CGRect(x: 0, y: 0, width: w, height: h))
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var tableViewModel: CardTableViewModel = {
        let vm = CardTableViewModel()
        vm.updatePlayerCountCallback = { [weak self] (count) in
            guard let `self` = self else { return }
            self.updatePlayerCountAction(count: count)
        }
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
    
    private lazy var footerView: UIView = {
        let w = kScreenWidth
        var h = self.selectionView.frame.size.height + self.cardBox.frame.size.height
        let view = UIView(frame: CGRect(x: 0, y: 0, width: w, height: h))
        
        view.addSubview(self.selectionView)
        view.addSubview(self.cardBox)
        
        self.selectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(self.selectionView.frame.size.height)
        }
        
        self.cardBox.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(self.cardBox.frame.size.height)
            make.top.equalTo(self.selectionView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        return view
    }()

}
