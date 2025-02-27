//
//  BaseTableViewCell.swift
//  PokerX
//
//  Created by Hsiao on 2025/2/25.
//  Copyright © 2025 YOLO. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    var model: BaseTableViewCellModel? {
        didSet {
            self.updateData()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func cellIdentifier() -> String {
        NSStringFromClass(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setupViews() {

    }
    
    func updateData() {
        
    }

}
