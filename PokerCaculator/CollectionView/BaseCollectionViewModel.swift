//
//  BaseCollectionViewModel.swift
//  PokerUp
//
//  Created by Hsiao on 2024/10/16.
//  Copyright 2024 Open4games. All rights reserved.
//

import UIKit

class BaseCollectionViewModel: NSObject {
    
    var sectionModels: [BaseCollectionSectionModel] = []
    weak var viewController: UIViewController?
    private var registedCellIdentifiers: [String] = []
    private var registedReuseableViewIdentifiers: [String] = []
    
    public var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    public var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init() {
        super.init()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.collectionViewLayout = self.layout
#if compiler(>=5.5)
        if #available(iOS 15.0, *) {
        }
#endif
    }
    
    public func setupData() {
        
    }
    
    public func reloadData() {
        for sectionModel in self.sectionModels {
            // 注册 header view
            if let headerIdentifier = sectionModel.headerReuseIdentifier,
               let headerViewType = sectionModel.headerViewType,
               !self.registedReuseableViewIdentifiers.contains(headerIdentifier) {
                self.collectionView.register(headerViewType,
                                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                          withReuseIdentifier: headerIdentifier)
                self.registedReuseableViewIdentifiers.append(headerIdentifier)
            }
            
            // 注册 footer view
            if let footerIdentifier = sectionModel.footerReuseIdentifier,
               let footerViewType = sectionModel.footerViewType,
               !self.registedReuseableViewIdentifiers.contains(footerIdentifier) {
                self.collectionView.register(footerViewType,
                                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                          withReuseIdentifier: footerIdentifier)
                self.registedReuseableViewIdentifiers.append(footerIdentifier)
            }
            
            // 注册 cells
            for cellModel in sectionModel.cellModels {
                let cellIdentifier = cellModel.cellIdentifier
                if self.registedCellIdentifiers.contains(cellIdentifier) {
                } else {
                    self.collectionView.register(cellModel.cellType, forCellWithReuseIdentifier: cellIdentifier)
                    self.registedCellIdentifiers.append(cellIdentifier)
                }
            }
        }
        self.collectionView.reloadData()
    }
    
    public func getCellModel(indexPath: IndexPath) -> BaseCollectionViewCellModel? {
        guard indexPath.section < self.sectionModels.count else {
            return nil
        }
        
        let sectionModel = self.sectionModels[indexPath.section]
        guard indexPath.row < sectionModel.cellModels.count else {
            return nil
        }
        return sectionModel.cellModels[indexPath.row]
    }
    
    public func getSectionModel(section: Int) -> BaseCollectionSectionModel? {
        guard section < self.sectionModels.count else {
            return nil
        }
        let sectionModel = self.sectionModels[section]
        return sectionModel
    }
}

extension BaseCollectionViewModel: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section < self.sectionModels.count else {
            return 0
        }
        
        let sectionModel = self.sectionModels[section]
        return sectionModel.cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.section < self.sectionModels.count else {
            return UICollectionViewCell()
        }
        let sectionModel = self.sectionModels[indexPath.section]
        guard indexPath.row < sectionModel.cellModels.count else {
            return UICollectionViewCell()
        }
        
        let cellModel = sectionModel.cellModels[indexPath.row]
        let reuseID = cellModel.cellIdentifier
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath)
        if let cell = cell as? BaseCollectionViewCell {
            cell.model = cellModel
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionModel = self.getSectionModel(section: indexPath.section) else {
            return UICollectionReusableView()
        }
        
        // 获取重用标识符和视图类型
        let reuseIdentifier: String?
        let viewType: AnyClass?
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            reuseIdentifier = sectionModel.headerReuseIdentifier
            viewType = sectionModel.headerViewType
            
        case UICollectionView.elementKindSectionFooter:
            reuseIdentifier = sectionModel.footerReuseIdentifier
            viewType = sectionModel.footerViewType
            
        default:
            return UICollectionReusableView()
        }
        
        // 确保有重用标识符和视图类型
        guard let identifier = reuseIdentifier, let type = viewType else {
            return UICollectionReusableView()
        }
        
        // 注册视图（如果还没注册）
        if !self.registedReuseableViewIdentifiers.contains(identifier) {
            self.collectionView.register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
            self.registedReuseableViewIdentifiers.append(identifier)
        }
        
        // 复用视图
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
        
//        // 如果是自定义的可重用视图，可以在这里设置数据
//        if let customView = view as? BaseCollectionReusableView {
//            customView.sectionModel = sectionModel
//        }
        
        return view
    }
    
}

extension BaseCollectionViewModel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let cellModel = self.getCellModel(indexPath: indexPath) {
            return cellModel.cellSize
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let sectionModel = self.getSectionModel(section: section) {
            return sectionModel.footerViewSize
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let sectionModel = self.getSectionModel(section: section) {
            return sectionModel.headerViewSize
        } else {
            return .zero
        }
        
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let sectionModel = self.getSectionModel(section: section) {
            return sectionModel.minimunLineSpacing
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let sectionModel = self.getSectionModel(section: section) {
            return sectionModel.minimumInteritemSpacing
        } else {
            return 0
        }
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
}
