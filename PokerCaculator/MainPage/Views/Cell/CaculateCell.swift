//
//  CaculateCell.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import UIKit

class CaculateCell: BaseTableViewCell {
    
    var updatePlayerCountCallback:((_ count: UInt) -> Void)?

    override func setupViews() {
        self.backgroundColor = kMainGreenColor
        self.selectionStyle = .none
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.valueLabel)
    }
    
    override func updateData() {
        guard let model = self.model as? CaculateCellModel else { return }
        self.titleLabel.text = model.title
        self.valueLabel.text = model.value
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        self.valueLabel.snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private lazy var valueLabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()

}
