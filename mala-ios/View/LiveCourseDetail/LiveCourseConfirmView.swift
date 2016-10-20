//
//  LiveCourseConfirmView.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/20.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

public protocol LiveCourseConfirmViewDelegate: class {
    ///  确认购买
    func OrderDidConfirm()
}


class LiveCourseConfirmView: UIView {
    
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
    weak var delegate: LiveCourseConfirmViewDelegate?
    
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            maker.top.equalTo(self.snp.top)
            maker.left.equalTo(self.snp.left)
            maker.right.equalTo(self.snp.right)
            maker.height.equalTo(MalaScreenOnePixel)
        })
        stringLabel.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(self.snp.left).offset(12)
            maker.centerY.equalTo(self.snp.centerY)
            maker.height.equalTo(14)
        }
        priceLabel.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(stringLabel.snp.right)
            maker.width.equalTo(100)
            maker.bottom.equalTo(stringLabel.snp.bottom)
            maker.height.equalTo(14)
        }
        confirmButton.snp.makeConstraints { (maker) -> Void in
            maker.right.equalTo(self.snp.right).offset(-12)
            maker.centerY.equalTo(self.snp.centerY)
            maker.width.equalTo(144)
            maker.height.equalTo(37)
        }
    }
    
    
    // MARK: - Event Response
    @objc func buttonDidTap() {
        delegate?.OrderDidConfirm()
    }
}
