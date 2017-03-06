//
//  QRCodeView.swift
//  mala-ios
//
//  Created by 王新宇 on 2016/11/10.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit
import QRCode

class QRCodeView: UIView {

    // MARK: - Property
    /// 要生成二维码的链接
    var url: String = "" {
        didSet {
            codeView.image = QRCode(url)?.image
        }
    }
    /// 支付价格
    var price: Int = 0 {
        didSet {
            priceLabel.text = price.amountCNY
        }
    }
    
    
    // MARK: - Components
    /// "共计"文字
    private lazy var totalString: UILabel = {
        let label = UILabel(
            text: "共计",
            font: FontFamily.PingFangSC.Regular.font(13),
            textColor: UIColor(named: .ArticleTitle),
            textAlignment: .right
        )
        return label
    }()
    /// 价格
    private lazy var priceLabel: UILabel = {
        let label = UILabel(
            text: "¥ 480.00",
            font: FontFamily.PingFangSC.Regular.font(18),
            textColor: UIColor(named: .ThemeRed),
            textAlignment: .left
        )
        return label
    }()
    /// 分割线
    private lazy var line: UIView = {
        let view = UIView(UIColor(named: .SeparatorLine))
        return view
    }()
    /// 支付提示文字
    private lazy var tipPayString: UILabel = {
        let label = UILabel(
            text: "请扫下方二维码进行支付",
            font: FontFamily.PingFangSC.Regular.font(12),
            textColor: UIColor(named: .ArticleText)
        )
        return label
    }()
    /// 二维码
    private lazy var codeView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        backgroundColor = UIColor.white
        price = ServiceResponseOrder.amount == 0 ? MalaCurrentCourse.getAmount() ?? 0 : ServiceResponseOrder.amount
        
        // SubViews
        addSubview(totalString)
        addSubview(priceLabel)
        addSubview(line)
        addSubview(tipPayString)
        addSubview(codeView)
        
        // Autolayout
        totalString.snp.makeConstraints { (maker) in
            maker.top.equalTo(self).offset(15)
            maker.right.equalTo(priceLabel.snp.left).offset(-5)
            maker.height.equalTo(18.5)
        }
        priceLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(totalString)
            maker.left.equalTo(self.snp.right).multipliedBy(0.412)
            maker.height.equalTo(25)
        }
        line.snp.makeConstraints { (maker) in
            maker.top.equalTo(totalString.snp.bottom).offset(15)
            maker.centerX.equalTo(self)
            maker.height.equalTo(MalaScreenOnePixel)
            maker.width.equalTo(self).multipliedBy(0.96)
        }
        tipPayString.snp.makeConstraints { (maker) in
            maker.top.equalTo(line.snp.bottom).offset(12)
            maker.centerX.equalTo(self)
            maker.height.equalTo(13)
        }
        codeView.snp.makeConstraints { (maker) in
            maker.top.equalTo(tipPayString.snp.bottom).offset(12)
            maker.width.equalTo(codeView.snp.height)
            maker.centerX.equalTo(self)
            maker.bottom.equalTo(self).offset(-12)
        }
    }
}
