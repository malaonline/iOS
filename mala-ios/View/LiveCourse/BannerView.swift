//
//  BannerView.swift
//  mala-ios
//
//  Created by 王新宇 on 2016/11/8.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class BannerView: UIView {
    
    // MARK: - Components
    /// Banner按钮
    lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.3
        button.setImage(UIImage(named: "live_banner"), for: .normal)
        return button
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
        // Style
        backgroundColor = UIColor(named: .RegularBackground)
        
        // SubViews
        addSubview(button)
        
        // AutoLayout
        button.snp.makeConstraints { (maker) in
            maker.top.equalTo(self)
            maker.left.equalTo(self)
            maker.right.equalTo(self)
            maker.bottom.equalTo(self).offset(-6)
        }
    }
    
    
    @objc private func buttonDidTap() {
        (viewController as? LiveCourseViewController)?.bannerDidTap()
    }
    
}
