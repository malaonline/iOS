//
//  PaymentBottomView.swift
//  mala-ios
//
//  Created by 王新宇 on 2/29/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

public protocol PaymentBottomViewDelegate: class {
    ///  确认交易
    func paymentDidConfirm()
}

class PaymentBottomView: UIView {
    
    weak var delegate: PaymentBottomViewDelegate?
    
    // MARK: - Components
    /// 确定按钮
    private lazy var confirmButton: UIButton = {
        let confirmButton = UIButton()
        confirmButton.backgroundColor = MalaColor_E26254_0
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        confirmButton.setTitle("支付", for: UIControlState())
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
        self.backgroundColor = UIColor.clear
        
        // SubViews
        addSubview(confirmButton)
        
        // Autolayout
        confirmButton.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(self).offset(12)
            maker.right.equalTo(self).offset(-12)
            maker.centerY.equalTo(self)
            maker.height.equalTo(37)
        }
    }
    
    
    // MARK: - Event Response
    @objc func buttonDidTap() {
        delegate?.paymentDidConfirm()
    }
}
