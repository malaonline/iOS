//
//  ThemeTagListView.swift
//  mala-ios
//
//  Created by 王新宇 on 16/7/12.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class ThemeTagListView: UIView {

    // MARK: - Property
    /// 图标图片名
    var imageName: String = "" {
        didSet {
            iconView.image = UIImage(named: imageName)
        }
    }
    /// 标签字符串数组
    var labels: [String] = [] {
        didSet {
            tagsView.labels = labels
        }
    }
    /// 标签背景色
    var labelBackgroundColor:UIColor = UIColor.lightGray {
        didSet {
            tagsView.labelBackgroundColor = labelBackgroundColor
        }
    }
    /// 标签文字颜色
    var textColor:UIColor = UIColor.white
        {
        didSet {
            tagsView.textColor = textColor
        }
    }
    
    
    // MARK: - Components
    /// 图标
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    /// 标签容器
    lazy var tagsView: TagListView = {
        let tagsView = TagListView()
        return tagsView
    }()
    
    
    // MARK: - Instance Method
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
        addSubview(iconView)
        addSubview(tagsView)
        
        // AutoLayout
        iconView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self)
            maker.top.equalTo(self).offset(2)
            maker.height.equalTo(21)
            maker.width.equalTo(21)
        }
        tagsView.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(iconView.snp.right).offset(12)
            maker.top.equalTo(self)
            maker.bottom.equalTo(self)
            maker.right.equalTo(self)
        }
    }
    
    func reset() {
        tagsView.reset()
    }
}
