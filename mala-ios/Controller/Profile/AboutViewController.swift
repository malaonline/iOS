//
//  AboutViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 3/15/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController, UIScrollViewDelegate {

    // MARK: - Components
    /// 容器
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: UIScreen.main.bounds)
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    /// 应用logoView
    private lazy var appLogoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppIcon60x60")
        return imageView
    }()
    /// 应用版本号label
    private lazy var appVersionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = MalaColor_333333_0
        label.text = MalaConfig.aboutAPPVersion()
        return label
    }()
    /// 版权信息label
    private lazy var copyrightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = MalaColor_939393_0
        label.text = MalaConfig.aboutCopyRightString()
        return label
    }()
    /// 描述 文字背景
    private lazy var textBackground: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "aboutText_Background"))
        return imageView
    }()
    /// 描述标题
    private lazy var titleView: AboutTitleView = {
        let view = AboutTitleView()
        view.title = MalaCommonString_Malalaoshi
        return view
    }()
    /// 关于描述label
    private lazy var aboutTextView: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = MalaColor_939393_0
        label.text = MalaConfig.aboutDescriptionHTMLString()
        label.backgroundColor = MalaColor_F2F2F2_0
        return label
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUserInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Private
    private func setupUserInterface() {
        // Style
        scrollView.backgroundColor = MalaColor_F2F2F2_0
        
        
        // SubViews
        view.addSubview(scrollView)
        scrollView.addSubview(appLogoView)
        scrollView.addSubview(appVersionLabel)
        scrollView.addSubview(copyrightLabel)
        scrollView.addSubview(textBackground)
        
        textBackground.addSubview(titleView)
        textBackground.addSubview(aboutTextView)
        
        // Autolayout
        scrollView.snp.makeConstraints { (maker) -> Void in
            maker.size.equalTo(view.snp.size)
            maker.top.equalTo(view.snp.top)
            maker.left.equalTo(view.snp.left)
        }
        appLogoView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(scrollView.snp.top).offset(24)
            maker.centerX.equalTo(scrollView.snp.centerX)
            maker.width.equalTo(MalaLayout_AboutAPPLogoViewHeight)
            maker.height.equalTo(MalaLayout_AboutAPPLogoViewHeight)
        }
        appVersionLabel.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(scrollView.snp.centerX)
            maker.top.equalTo(appLogoView.snp.bottom).offset(12)
            maker.height.equalTo(14)
        }
        copyrightLabel.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(scrollView.snp.centerX)
            maker.top.equalTo(appVersionLabel.snp.bottom).offset(12)
        }
        textBackground.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(copyrightLabel.snp.bottom).offset(12)
            maker.centerX.equalTo(scrollView.snp.centerX)
            maker.left.equalTo(scrollView.snp.left).offset(12)
            maker.right.equalTo(scrollView.snp.right).offset(-12)
        }
        titleView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(textBackground.snp.top).offset(18)
            maker.left.equalTo(textBackground.snp.left)
            maker.right.equalTo(textBackground.snp.right)
        }
        aboutTextView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(titleView.snp.bottom).offset(18)
            maker.left.equalTo(textBackground.snp.left).offset(18)
            maker.right.equalTo(textBackground.snp.right).offset(-18)
            maker.bottom.equalTo(textBackground.snp.bottom).offset(-18)
        }
        
        upateContentSize()
    }
    
    private func upateContentSize() {
        scrollView.contentSize = CGSize(width: 0, height: aboutTextView.frame.maxY)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = UIScreen.main.bounds
        scrollView.contentSize = CGSize(width: 0, height: aboutTextView.frame.maxY)
    }
}
