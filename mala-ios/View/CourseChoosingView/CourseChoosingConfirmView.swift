//
//  CourseChoosingConfirmView.swift
//  mala-ios
//
//  Created by 王新宇 on 1/22/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

public protocol CourseChoosingConfirmViewDelegate: class {
    ///  确认购买
    func OrderDidconfirm()
}


class CourseChoosingConfirmView: UIView {

    // MARK: - Property
    /// 需支付金额
    var price: Int = 0 {
        didSet{
            DispatchQueue.main.async {
                self.priceLabel.text = self.price.amountCNY
            }
        }
    }
    private var myContext = 0
    weak var delegate: CourseChoosingConfirmViewDelegate?
    
    
    // MARK: - Components
    private lazy var topLine: UIView = {
        let view = UIView(UIColor.black)
        view.alpha = 0.4
        return view
    }()
    /// 价格说明标签
    private lazy var stringLabel: UILabel = {
        let stringLabel = UILabel(
            text: "还需支付:",
            fontSize: 14,
            textColor: MalaColor_333333_0
        )
        return stringLabel
    }()
    /// 金额标签
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel(
            text: "￥0.00",
            fontSize: 14,
            textColor: MalaColor_E26254_0,
            textAlignment: .left
        )
        return priceLabel
    }()
    /// 确定按钮
    private lazy var confirmButton: UIButton = {
        let confirmButton = UIButton()
        confirmButton.backgroundColor = MalaColor_E26254_0
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        confirmButton.setTitle("确定", for: UIControlState())
        confirmButton.setTitleColor(UIColor.white, for: UIControlState())
        confirmButton.layer.cornerRadius = 5
        confirmButton.layer.masksToBounds = true
        confirmButton.addTarget(self, action: #selector(CourseChoosingConfirmView.buttonDidTap), for: .touchUpInside)
        return confirmButton
    }()
    
    
    // MARK: - Constructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Override
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 当选课条件改变时，更新总价
        self.price = MalaCurrentCourse.getAmount() ?? 0
    }
    
    
    // MARK: - Private method
    private func setupUserInterface() {
        // Style
        self.backgroundColor = UIColor.white
        
        // SubViews
        addSubview(topLine)
        addSubview(stringLabel)
        addSubview(priceLabel)
        addSubview(confirmButton)
        
        // Autolayout
        topLine.snp.makeConstraints({ (maker) -> Void in
            maker.top.equalTo(self)
            maker.left.equalTo(self)
            maker.right.equalTo(self)
            maker.height.equalTo(MalaScreenOnePixel)
        })
        stringLabel.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(self).offset(12)
            maker.centerY.equalTo(self)
            maker.height.equalTo(14)
        }
        priceLabel.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(stringLabel.snp.right)
            maker.width.equalTo(100)
            maker.bottom.equalTo(stringLabel)
            maker.height.equalTo(14)
        }
        confirmButton.snp.makeConstraints { (maker) -> Void in
            maker.right.equalTo(self).offset(-12)
            maker.centerY.equalTo(self)
            maker.width.equalTo(144)
            maker.height.equalTo(37)
        }
    }
    
    private func configure() {
        MalaCurrentCourse.addObserver(self, forKeyPath: "originalPrice", options: .new, context: &myContext)
    }
    
    
    // MARK: - Event Response
    @objc func buttonDidTap() {
        delegate?.OrderDidconfirm()
    }
    
    deinit {
        MalaCurrentCourse.removeObserver(self, forKeyPath: "originalPrice", context: &myContext)
    }
}
