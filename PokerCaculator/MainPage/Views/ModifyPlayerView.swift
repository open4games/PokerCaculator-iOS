//
//  ModifyPlayerView.swift
//  PokerCaculator
//
//  Created by Hsiao on 2025/2/27.
//

import UIKit

/// 最多人数
private let kMaxCount = 10
/// 最少人数
private let kMinCount = 1

class ModifyPlayerView: UIView {
    
    var updateCountCallback:((_ count: UInt) -> Void)?

    var count: UInt = 1 {
        didSet {
            self.countLabel.text = "\(self.count)"
        }
    }
    
    init(count: UInt) {
        super.init(frame: .zero)
        self.count = count
        self.setupViews()
        self.setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(self.subtractBtn)
        self.addSubview(self.countLabel)
        self.addSubview(self.addBtn)
    }
    
    func setupData() {
        self.count = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subtractBtn.snp.remakeConstraints { make in
            make.centerY.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        self.countLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(self.subtractBtn.snp.right).offset(5)
            make.width.equalTo(40)
        }
        self.addBtn.snp.remakeConstraints { make in
            make.centerY.top.bottom.right.equalToSuperview()
            make.left.equalTo(self.countLabel.snp.right).offset(5)
        }
    }
    
    @objc func handleAddAction() {
        guard self.count < kMaxCount else {
            return
        }
        self.count += 1
        self.updateCountCallback?(self.count)
    }
    
    @objc func handleSubtractAction() {
        guard self.count > kMinCount else {
            return
        }
        self.count -= 1
        self.updateCountCallback?(self.count)
    }
    
    private lazy var addBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("+", for:  .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(handleAddAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var subtractBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("-", for:  .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(handleSubtractAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
}
