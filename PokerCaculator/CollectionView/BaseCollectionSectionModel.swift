//
//  BaseCollectionSectionModel.swift
//  PokerUp
//
//  Created by Hsiao on 2024/10/16.
//  Copyright © 2024 Open4games. All rights reserved.
//

import UIKit

class BaseCollectionSectionModel: NSObject {
    var cellModels: [BaseCollectionViewCellModel] = []
    
    var headerViewType: AnyClass? {
        return nil
    }
    
    var footerViewType: AnyClass? {
        return nil
    }
    
    var headerViewSize: CGSize {
        return .zero
    }
    
    var footerViewSize: CGSize {
        return .zero
    }
    
    var minimunLineSpacing: CGFloat {
        return 0
    }
    
    var minimumInteritemSpacing: CGFloat {
        return 0
    }
    
    lazy var headerReuseIdentifier: String? = {
        if let headerViewType = self.headerViewType {
            return NSStringFromClass(headerViewType)
        }
        return nil
    }()
    
    lazy var footerReuseIdentifier: String? = {
        if let footerViewType = self.footerViewType {
            return NSStringFromClass(footerViewType)
        }
        return nil
    }()
    
    
}
