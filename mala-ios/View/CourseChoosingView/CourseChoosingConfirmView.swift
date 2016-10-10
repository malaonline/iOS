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
            DispatchQueue.main.async(execute: { [weak self] () -> Void in
                self?.priceLabel.text = self?.price.amountCNY
            })
        }
    }
    private var myContext = 0
    weak var delegate: CourseChoosingConfirmViewDelegate?
    
    
    // MARK: - Components
    private lazy var topLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.4
        return view
    }()
    /// 价格说明标签
    private lazy var stringLabel: UILabel = {
        let stringLabel = UILabel()
        stringLabel.font = UIFont.systemFont(ofSize: 14)
        stringLabel.textColor = MalaColor_333333_0
        stringLabel.text = "还需支付:"
        return stringLabel
    }()
    /// 金额标签
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = MalaColor_E26254_0
        priceLabel.textAlignment = .left
        priceLabel.text = "￥0.00"
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
        confirmButton.addTarget(self, action: #selector(PaymentBottomView.buttonDidTap), for: .touchUpInside)
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
        topLine.snp_makeConstraints({ (make) -> Void in
            make.top.equalTo(self.snp_top)
            make.left.equalTo(self.snp_left)
            make.right.equalTo(self.snp_right)
            make.height.equalTo(MalaScreenOnePixel)
        })
        stringLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp_left).offset(12)
            make.centerY.equalTo(self.snp_centerY)
            make.height.equalTo(14)
        }
        priceLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(stringLabel.snp_right)
            make.width.equalTo(100)
            make.bottom.equalTo(stringLabel.snp_bottom)
            make.height.equalTo(14)
        }
        confirmButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self.snp_right).offset(-12)
            make.centerY.equalTo(self.snp_centerY)
            make.width.equalTo(144)
            make.height.equalTo(37)
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
