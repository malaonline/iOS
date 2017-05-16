//
//  MalaBaseMemberCardCell.swift
//  mala-ios
//
//  Created by 王新宇 on 11/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

class MalaBaseMemberCardCell: UITableViewCell {
    
    enum memberCardState {
        case normal
        case disabled
        case loading
    }
    
    // MARK: - Property
    var state: memberCardState = .normal {
        didSet {
            switch state {
            case .normal:
                actionButton.setTitle(_buttonTitle, for: .normal)
                imageIcon.image = UIImage(asset: _icon)
                loading.isHidden = true
                loading.stopAnimating()
            case .disabled:
                actionButton.setTitle(_disabledTitle, for: .normal)
                imageIcon.image = UIImage(asset: _disabledIcon)
                loading.isHidden = true
                loading.stopAnimating()
            case .loading:
                actionButton.setTitle("正在加载", for: .normal)
                imageIcon.image = UIImage(asset: _icon)
                loading.isHidden = false
                loading.layer.add(animation, forKey: "Mala.Base.Member.CardCell.Animation")
            }
        }
    }
    var _icon: ImageAsset = .none
    var _disabledIcon: ImageAsset = .none
    var _title: String = ""
    var _disabledTitle: String = "" 
    var _buttonTitle: String = ""

    // MARK: - Components
    /// container card
    lazy var content: UIView = {
        let view = UIView(UIColor.white)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    lazy var contentShadow: UIView = {
        let view = UIView(UIColor.clear)
        view.layer.shadowColor = UIColor(named: .themeShadowBlue).cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowOpacity = 1.0
        return view
    }()
    /// default components
    lazy var defaultContainer: UIView = {
        let view = UIView(UIColor.white)
        return view
    }()
    /// icon
    lazy var imageIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(asset: .noteNormal)
        return imageView
    }()
    /// description label
    lazy var label: UILabel = {
        let label = UILabel(
            text: "",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .protocolGary)
        )
        return label
    }()
    /// button
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.titleLabel?.font = FontFamily.PingFangSC.Regular.font(18)
        button.setBackgroundImage(UIImage(asset: .noteButtonNormal), for: .normal)
        button.setBackgroundImage(UIImage(asset: .noteButtonPress), for: .highlighted)
        button.setBackgroundImage(UIImage(asset: .noteButtonPress), for: .selected)
        return button
    }()
    private lazy var loading: UIImageView = {
        let imageView = UIImageView(image: UIImage(asset: .buttonLoading))
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var animation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(-(.pi / 2), 0.0, 0.0, 1.0))
        animation.duration = 0.25
        animation.isCumulative = true
        animation.repeatCount = MAXFLOAT
        return animation
    }()
    
    // MARK: - Instance Method
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        contentView.backgroundColor = UIColor(named: .themeLightBlue)
        
        // SubViews
        contentView.addSubview(contentShadow)
        contentShadow.addSubview(content)
        
        
        // Autolayout
        contentShadow.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(10)
            maker.left.equalTo(contentView).offset(10)
            maker.right.equalTo(contentView).offset(-10)
            maker.bottom.equalTo(contentView)
            
        }
        content.snp.makeConstraints { (maker) in
            maker.center.equalTo(contentShadow)
            maker.size.equalTo(contentShadow)
        }
    }
    
    func setupDefaultStyle(image: ImageAsset, disabledImage: ImageAsset, title: String, disabledTitle: String, buttonTitle: String) {
        // Resource
        _icon = image
        _disabledIcon = disabledImage
        _title = title
        _disabledTitle = disabledTitle
        _buttonTitle = buttonTitle
        
        imageIcon.image = UIImage(asset: _icon)
        label.text = _title
        actionButton.setTitle(_buttonTitle, for: .normal)
        
        // SubViews
        content.addSubview(defaultContainer)
        defaultContainer.addSubview(imageIcon)
        defaultContainer.addSubview(label)
        defaultContainer.addSubview(actionButton)
        actionButton.addSubview(loading)
        
        // Autolayout
        defaultContainer.snp.makeConstraints { (maker) in
            maker.center.equalTo(content)
            maker.size.equalTo(content)
        }
        imageIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(content).offset(24)
            maker.centerX.equalTo(content)
            maker.width.equalTo(89)
            maker.height.equalTo(107)
            maker.bottom.equalTo(label.snp.top).offset(-18)
        }
        label.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageIcon.snp.bottom).offset(18)
            maker.centerX.equalTo(content)
            maker.height.equalTo(20)
            maker.bottom.equalTo(label.snp.top).offset(-18)
        }
        actionButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(label.snp.bottom)
            maker.centerX.equalTo(content)
            maker.width.equalTo(240)
            maker.height.equalTo(65)
            maker.bottom.equalTo(content).offset(-10)
        }
        loading.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(actionButton)
            maker.right.equalTo(actionButton.titleLabel!.snp.left).offset(-6)
            maker.height.equalTo(22)
            maker.width.equalTo(22)
        }
    }
}
