//
//  BaseViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/4/11.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit
import Kingfisher

open class BaseViewController: UIViewController {
    
    // MARK: - Components
    /// 导航栏返回按钮
    lazy var backBarButton: UIButton = {
        let backBarButton = UIButton(
            imageName: "leftArrow_black",
            highlightImageName: "leftArrow_black",
            target: self,
            action: #selector(BaseViewController.popSelf)
        )
        return backBarButton
    }()
    /// 无筛选结果缺省面板
    lazy var defaultView: MalaDefaultPanel = {
        let defaultView = MalaDefaultPanel()
        defaultView.isHidden = true
        return defaultView
    }()
    

    // MARK: - Life Cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        KingfisherManager.shared.cache.clearMemoryCache()
    }
    

    // MARK: - Private
    private func setupDefaultViewIfNeed() {
        if defaultView.superview == nil {
            // SubViews
            view.addSubview(defaultView)
            
            // AutoLayout
            defaultView.snp.makeConstraints { (maker) -> Void in
                maker.center.equalTo(view)
                maker.size.equalTo(view)
            }
        }
    }
    
    private func configure() {
        
        // 设置BarButtomItem间隔
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = -2
        
        // leftBarButtonItem
        let leftBarButtonItem = UIBarButtonItem(customView: backBarButton)
        navigationItem.leftBarButtonItems = [spacer, leftBarButtonItem]
    }

    
    // MARK: - Event Response
    @objc func popSelf() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func turnBackButtonBlack() {
        backBarButton.setImage(UIImage(named: "leftArrow_black"), for: UIControlState())
    }
    
    @objc func turnBackButtonWhite() {
        backBarButton.setImage(UIImage(named: "leftArrow"), for: UIControlState())
    }
    
    
    // MARK: - API
    func showDefaultView() {
        setupDefaultViewIfNeed()
        defaultView.isHidden = false
    }
    
    func hideDefaultView() {
        setupDefaultViewIfNeed()
        defaultView.isHidden = true
    }
}
