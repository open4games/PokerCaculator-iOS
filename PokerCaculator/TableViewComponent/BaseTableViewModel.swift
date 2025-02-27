//
//  BaseTableViewModel.swift
//  PokerX
//
//  Created by Hsiao on 2025/2/25.
//  Copyright © 2025 YOLO. All rights reserved.
//

import UIKit

private let SCREEN_WIDTH = UIScreen.main.bounds.width
private let SCREEN_HEIGHT = UIScreen.main.bounds.height

typealias ListFetchCallBack = (_ result: Bool, _ errorInfo: String?, _ first: Bool, _ noMore: Bool) -> Void

class BaseTableViewModel: NSObject, UITableViewDelegate, UITableViewDataSource {

    var sectionDataArr = [BaseTableViewSectionModel]()
    weak var viewController: UIViewController?

    private var registedCell = [String]()

    var tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), style: .plain)

    weak var scrollDelegate: UIScrollViewDelegate?
    //交互需要检测用户的拖拽tableView的事件进而影响footer在底部时的显示逻辑
    weak var footerDelegate: UIScrollViewDelegate?
    override init() {
        super.init()
        #if compiler(>=5.5)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        #endif
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.tableFooterView = UIView()
    }

    // MARK: - UITableViewDataSource & UITableViewDelegate

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionDataArr.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sectionDataArr.count {
            let sectionModel = sectionDataArr[section]
            return sectionModel.cellModelArr.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section < sectionDataArr.count {
            let sectionModel = sectionDataArr[section]
            return sectionModel.headerViewHeight
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < sectionDataArr.count {
            let sectionModel = sectionDataArr[section]
            return sectionModel.footerViewHeight
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section < sectionDataArr.count {
            let sectionModel = sectionDataArr[section]
            return sectionModel.headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section < sectionDataArr.count {
            let sectionModel = sectionDataArr[section]
            return sectionModel.footerView
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section < sectionDataArr.count {
            let sectionModel = sectionDataArr[indexPath.section]
            if indexPath.row < sectionModel.cellModelArr.count {
                let cellModel = sectionModel.cellModelArr[indexPath.row]
                return cellModel.cellHeight
            } else {
                return 0
            }
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < sectionDataArr.count {
            let sectionModel = sectionDataArr[indexPath.section]
            if indexPath.row < sectionModel.cellModelArr.count {
                let cellModel = sectionModel.cellModelArr[indexPath.row]
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellIdenfitier) {
                    if cell is BaseTableViewCell {
                        if let baseCell = cell as? BaseTableViewCell {
//                            baseCell.configCellModel(cellModel: cellModel, indexPath: indexPath)
                            baseCell.model = cellModel
                        }
                    }
                    return cell
                } else {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
                    return cell
                }
            } else {
                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {

    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollDelegate != nil {
            scrollDelegate!.scrollViewDidScroll?(scrollView)
        }
        footerDelegate?.scrollViewDidScroll?(scrollView)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollDelegate != nil {
            scrollDelegate!.scrollViewWillBeginDragging?(scrollView)
        }
        footerDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollDelegate != nil {
            scrollDelegate!.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
        footerDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollDelegate != nil {
            scrollDelegate!.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
        footerDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollDelegate != nil {
            scrollDelegate!.scrollViewWillBeginDecelerating?(scrollView)
        }
        footerDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollDelegate != nil {
            scrollDelegate!.scrollViewDidEndDecelerating?(scrollView)
        }
        footerDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if scrollDelegate != nil {
            scrollDelegate!.scrollViewDidScroll?(scrollView)
        }
        footerDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollDelegate != nil {
            scrollDelegate!.scrollViewDidEndScrollingAnimation?(scrollView)
        }
        footerDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    // MARK: - Other

    private func registerCellClassName(tableView: UITableView, cellModel: BaseTableViewCellModel) {
        let cellName = "\(String(describing: cellModel.cellType))"
        if !registedCell.contains(cellName) {
            if Bundle.main.path(forResource: cellName, ofType: "nib") != nil {
                tableView.register(UINib.init(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellModel.cellIdenfitier)
            } else {
                tableView.register(cellModel.cellType, forCellReuseIdentifier: cellModel.cellIdenfitier)
            }
            registedCell.append(cellName)
        } else {
//           print("cell已注册 \(cellName)")
        }
    }

    func reloadData() {
        for i in 0..<sectionDataArr.count {
            let sectionModel = sectionDataArr[i]
            for j in 0..<sectionModel.cellModelArr.count {
                let cellModel = sectionModel.cellModelArr[j]
                registerCellClassName(tableView: self.tableView, cellModel: cellModel)
            }
        }
        self.tableView.reloadData()
    }

}
