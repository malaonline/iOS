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
    /// 应用logo
    private lazy var appLogoView: UIImageView = {
        let imageView = UIImageView(imageName: MalaConfig.appIcon())
        return imageView
    }()
    /// 应用版本号label
    private lazy var appVersionLabel: UILabel = {
        let label = UILabel(
            text: MalaConfig.aboutAPPVersion(),
            fontSize: 14,
            textColor: MalaColor_333333_0
        )
        return label
    }()
    /// 版权信息label
    private lazy var copyrightLabel: UILabel = {
        let label = UILabel(
            text: MalaConfig.aboutCopyRightString(),
            fontSize: 12,
            textColor: MalaColor_939393_0,
            textAlignment: .center
        )
        label.numberOfLines = 2
        return label
    }()
    /// 描述 文字背景
    private lazy var textBackground: UIView = {
        let view = UIView(UIColor.white)
        view.layer.borderColor = MalaColor_979797_0.cgColor
        view.layer.borderWidth = MalaScreenOnePixel
        return view
    }()
    /// 描述标题
    private lazy var titleView: AboutTitleView = {
        let view = AboutTitleView()
        view.title = MalaCommonString_Malalaoshi
        return view
    }()
    /// 关于描述label
    private lazy var aboutTextView: UILabel = {
        let label = UILabel(
            text: MalaConfig.aboutDescriptionHTMLString(),
            fontSize: 13,
            textColor: MalaColor_939393_0,
            textAlignment: .center,
            backgroundColor: UIColor.clear
        )
        label.numberOfLines = 0
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
            maker.size.equalTo(view)
            maker.center.equalTo(view)
        }
        appLogoView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(scrollView).offset(24)
            maker.centerX.equalTo(scrollView)
            maker.width.equalTo(62)
            maker.height.equalTo(62)
        }
        appVersionLabel.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(scrollView)
            maker.top.equalTo(appLogoView.snp.bottom).offset(12)
            maker.height.equalTo(14)
        }
        copyrightLabel.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(scrollView)
            maker.top.equalTo(appVersionLabel.snp.bottom).offset(12)
        }
        textBackground.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(copyrightLabel.snp.bottom).offset(12)
            maker.centerX.equalTo(scrollView)
            maker.left.equalTo(scrollView).offset(12)
            maker.right.equalTo(scrollView).offset(-12)
        }
        titleView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(textBackground).offset(18)
            maker.left.equalTo(textBackground)
            maker.right.equalTo(textBackground)
        }
        aboutTextView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(titleView.snp.bottom).offset(18)
            maker.left.equalTo(textBackground).offset(18)
            maker.right.equalTo(textBackground).offset(-18)
            maker.bottom.equalTo(textBackground).offset(-18)
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
