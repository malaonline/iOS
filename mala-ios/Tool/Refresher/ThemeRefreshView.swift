//
//  ThemeRefreshView.swift
//  mala-ios
//
//  Created by 王新宇 on 2/17/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class ThemeRefreshView: UIView {
    
    // MARK: - Property
    private lazy var view: UIView = UIView()
    private lazy var imageView: UIImageView = UIImageView(image: UIImage(named: "refreshImage"))
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = MalaColor_939393_0
        label.text = "下拉可刷新"
        label.sizeToFit()
        return label
    }()
    /// 可刷新标记
    var isCanRefresh = false {
        didSet {
            if !isHidden {
                changeTitle()
            }
        }
    }
    /// 动画标记
    var animating = false {
        didSet {
            if !isHidden {
                setAnimating()
            }
        }
    }
    
    
    // MARK: - Constructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Method
    private func setupUserInterface() {
        // SubViews
        view.addSubview(imageView)
        view.addSubview(label)
        addSubview(view)
        
        // Autolayout
        view.snp.makeConstraints { (maker) -> Void in
            maker.height.equalTo(30)
            maker.width.equalTo(105)
            maker.center.equalTo(self.snp.center)
        }
        imageView.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(self.view.snp.centerY).offset(-MalaScreenOnePixel*3)
            maker.left.equalTo(self.view.snp.left)
        }
        label.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(self.view.snp.centerY)
            maker.right.equalTo(self.view.snp.right)
        }
        
    }
    
    private func changeTitle() {
        if isCanRefresh {
            label.text = "释放可刷新"
        }else {
            label.text = "下拉可刷新"
        }
    }
    
    private func setAnimating() {
        if animating {
            imageView.image = (UIScreen.main.scale == 3 ? UIImage(named: "refreshImage@3x.gif") : UIImage(named: "refreshImage@2x.gif"))
            label.text = "正在加载.."
        }else {
            imageView.image = UIImage(named: "refreshImage")
            label.text = "下拉可刷新"
        }
    }
}
