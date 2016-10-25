//
//  MalaDefaultPanel.swift
//  mala-ios
//
//  Created by 王新宇 on 3/28/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class MalaDefaultPanel: UIView {

    // MARK: - Property
    /// 图片名称
    var imageName: String = "" {
        didSet {
            imageView.image = UIImage(named: imageName)
            imageView.sizeToFit()
        }
    }
    /// 描述文字
    var text: String = "" {
        didSet {
            label.text = text
            label.sizeToFit()
        }
    }
    /// 描述文字
    var descText: String = "" {
        didSet {
            descLabel.text = descText
            descLabel.sizeToFit()
        }
    }
    /// 按钮描述文字
    var buttonTitle: String = "" {
        didSet {
            button.setTitle(buttonTitle, for: UIControlState())
        }
    }
    
    
    // MARK: - Components
    /// 图片视图
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    /// 文字标签
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = MalaColor_939393_0
        label.textAlignment = .center
        return label
    }()
    /// 描述标签
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = MalaColor_939393_0
        label.textAlignment = .center
        return label
    }()
    /// 按钮
    private lazy var button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.layer.borderColor = MalaColor_8DBEDE_0.cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(MalaColor_8DBEDE_0, for: UIControlState())
        return button
    }()
    
    
    // MARK: - Constructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private
    private func setupUserInterface() {
        // SubViews
        addSubview(imageView)
        addSubview(label)
        addSubview(descLabel)
        
        // Autolayout
        label.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(self).offset(-50)
            maker.centerX.equalTo(self)
            maker.height.equalTo(13)
        }
        imageView.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(self)
            maker.bottom.equalTo(label.snp.top).offset(-8)
        }
        descLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(label.snp.bottom).offset(12)
            maker.centerX.equalTo(self)
            maker.height.equalTo(13)
        }
    }
    
    ///  按钮点击事件
    func addTarget(_ target: AnyObject?, action: Selector) {
        
        addSubview(button)
        button.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(self)
            maker.top.equalTo(label.snp.bottom).offset(25)
            maker.height.equalTo(36)
            maker.width.equalTo(164)
        }
        
        button.addTarget(target, action: action, for: .touchUpInside)
    }
}
