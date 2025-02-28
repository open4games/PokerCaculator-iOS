//
//  ModifyPlayerCell.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/28.
//

import UIKit

class ModifyPlayerCell: BaseTableViewCell {
    
    var updatePlayerCountCallback:((_ count: UInt) -> Void)?
    
    override func setupViews() {
        self.backgroundColor = kMainGreenColor
        self.selectionStyle = .none
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.modifyPlayerView)
    }
    
    override func updateData() {
        guard let model = self.model as? ModifyPlayerCellModel else { return }
        self.titleLabel.text = model.title
        self.modifyPlayerView.count = model.playerCount
    }
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        self.modifyPlayerView.snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
    }

    private lazy var modifyPlayerView: ModifyPlayerView = {
        let view = ModifyPlayerView(count: 1)
        view.updateCountCallback = { [weak self] (count) in
            guard let `self` = self else { return }
            self.updatePlayerCountCallback?(count)
        }
        return view
    }()
}
