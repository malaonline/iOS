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
    var state: memberCardState = .normal

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
    
    func setupDefaultStyle(image: ImageAsset, title: String, buttonTitle: String) {
        // Resource
        imageIcon.image = UIImage(asset: image)
        label.text = title
        actionButton.setTitle(buttonTitle, for: .normal)
        
        // SubViews
        content.addSubview(imageIcon)
        content.addSubview(label)
        content.addSubview(actionButton)
        
        // Autolayout
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
    }
}
