//
//  CardCell.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/26.
//

import UIKit

class CardCell: BaseCollectionViewCell {
    
    override func setupViews() {
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.contentView.addSubview(self.valueLabel)
        self.contentView.addSubview(self.suiteLabel)
    }
    
    override func updateData() {
        guard let model = self.model as? CardCellModel else { return }
        self.valueLabel.text = model.rank
        self.suiteLabel.text = model.suit
        self.valueLabel.textColor = model.textColor
        self.suiteLabel.textColor = model.textColor
        
        if model.card == nil {
            self.backgroundColor = .systemGray2
        } else {
            if model.viewModel is CardCollectionViewModel {
                if model.isSelected {
                    self.backgroundColor = UIColor.lightGray
                } else {
                    self.backgroundColor = UIColor.white
                }
            } else {
                self.backgroundColor = UIColor.white
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.valueLabel.snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(10)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        self.suiteLabel.snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(10)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
    }
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 8, weight: .bold)
        return label
    }()
    
    private lazy var suiteLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 8)
        return label
    }()
    
}
