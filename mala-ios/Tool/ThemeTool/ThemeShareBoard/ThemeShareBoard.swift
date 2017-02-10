//
//  ThemeShareBoard.swift
//  mala-ios
//
//  Created by 王新宇 on 16/8/22.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class ThemeShareBoard: UIView {

    // MARK: - Property
    /// 老师模型
    var teacherModel: TeacherDetailModel? {
        didSet {
            collectionView.teacherModel = teacherModel
        }
    }
    
    
    // MARK: - Components
    /// 父布局容器（白色卡片）
    private lazy var content: UIView = {
        let view = UIView(UIColor(named: .SharedBoard))
        return view
    }()
    /// 标题标签
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "分享到",
            fontSize: 15,
            textColor: UIColor(named: .HeaderTitle)
        )
        return label
    }()
    /// 会员服务视图
    private lazy var collectionView: ThemeShareCollectionView = {
        let view = ThemeShareCollectionView(frame: CGRect.zero, collectionViewLayout: ThemeShareFlowLayout(frame: CGRect.zero))
        return view
    }()
    // 背景视图
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.4
        backgroundView.tag = 1099
        return backgroundView
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
        
        // SubViews
        addSubview(backgroundView)
        addSubview(content)
        content.addSubview(titleLabel)
        content.addSubview(collectionView)
        
        // Autolayout
        backgroundView.snp.makeConstraints { (maker) in
            maker.center.equalTo(self)
            maker.size.equalTo(self)
        }
        content.snp.makeConstraints { (maker) in
            maker.left.equalTo(self)
            maker.right.equalTo(self)
            maker.height.equalTo(153)
            maker.bottom.equalTo(self)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(content)
            maker.top.equalTo(content).offset(20)
            maker.height.equalTo(15)
        }
        collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(20)
            maker.left.equalTo(content).offset(12)
            maker.right.equalTo(content).offset(-12)
            maker.bottom.equalTo(content).offset(-20)
        }
    }
    
    
    deinit {
        println("ThemeShareBoard deinit")
    }
}
