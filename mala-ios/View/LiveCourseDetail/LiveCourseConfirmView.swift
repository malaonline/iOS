//
//  LiveCourseConfirmView.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/20.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

public protocol LiveCourseConfirmViewDelegate: class {
    ///  确认购买
    func OrderDidConfirm()
}


class LiveCourseConfirmView: UIView {
    
    // MARK: - Property
    /// 课程模型
    var model: LiveClassModel? {
        didSet{
            guard let model = model else { return }
                        
            priceLabel.text = String(format: "%@/", model.courseFee?.priceCNY ?? "")
            lessionsLabel.text = String(format: "%d次", model.courseLessons ?? 0)
            
            if model.isPaid {
                setBought()
            }else if let endDate = model.courseEnd, Date().timeIntervalSinceNow > endDate {
                setExpired()
            }else if let student = model.studentsCount, let capacity = model.roomCapacity, student >= capacity {
                setSoldout()
            }else {
                confirmButton.isEnabled = true
            }
        }
    }
    weak var delegate: LiveCourseConfirmViewDelegate?
    
    
    // MARK: - Components
    /// 价格容器
    private lazy var priceContainer: UIView = {
        let view = UIView(UIColor.white)
        return view
    }()
    /// 价格标签
    private lazy var priceLabel: UILabel = {
        let label = UILabel(
            text: "价格/",
            font: FontFamily.PingFangSC.Light.font(18),
            textColor: UIColor(named: .ThemeRed),
            textAlignment: .right
        )
        return label
    }()
    /// 课时数标签
    private lazy var lessionsLabel: UILabel = {
        let label = UILabel(
            text: "次数",
            font: FontFamily.PingFangSC.Light.font(10),
            textColor: UIColor(named: .ThemeRed),
            textAlignment: .right
        )
        return label
    }()
    /// 确认按钮
    private lazy var confirmButton: UIButton = {
        let button = UIButton(
            title: "立即购买",
            titleColor: UIColor.white,
            selectedTitleColor: UIColor.white,
            bgColor: UIColor(named: .ThemeBlue),
            selectedBgColor: UIColor(named: .ThemeBlue)
        )
        button.titleLabel?.font = UIFont(name: "FZLTXHK", size: 15)
        button.addTarget(self, action: #selector(LiveCourseConfirmView.buttonDidTap), for: .touchUpInside)
        button.isEnabled = false
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
    
    
    // MARK: - Private method
    private func setupUserInterface() {
        // Style
        backgroundColor = UIColor.white
        
        // SubViews
        addSubview(priceContainer)
        addSubview(confirmButton)
        priceContainer.addSubview(priceLabel)
        priceContainer.addSubview(lessionsLabel)
        
        // Autolayout
        priceContainer.snp.makeConstraints({ (maker) -> Void in
            maker.top.equalTo(self)
            maker.left.equalTo(self)
            maker.right.equalTo(self).multipliedBy(0.5)
            maker.height.equalTo(44)
            maker.bottom.equalTo(self)
        })
        confirmButton.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self)
            maker.left.equalTo(priceContainer.snp.right)
            maker.right.equalTo(self)
            maker.height.equalTo(44)
            maker.bottom.equalTo(self)
        }
        priceLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(priceContainer)
            maker.centerX.equalTo(priceContainer).offset(-17)
            maker.height.equalTo(18)
        }
        lessionsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(priceLabel.snp.right)
            maker.bottom.equalTo(priceLabel)
            maker.height.equalTo(10)
        }
    }
    
    private func setBought() {
        confirmButton.setTitle("已购买", for: .normal)
        confirmButton.setBackgroundImage(UIImage.withColor(UIColor(named: .Disabled)), for: .normal)
        confirmButton.isEnabled = false
    }
    
    private func setSoldout() {
        confirmButton.setTitle("已满", for: .normal)
        confirmButton.setBackgroundImage(UIImage.withColor(UIColor(named: .ThemeRed)), for: .normal)
        confirmButton.isEnabled = false
    }
    
    private func setExpired() {
        confirmButton.setTitle("已结束", for: .normal)
        confirmButton.setBackgroundImage(UIImage.withColor(UIColor(named: .Disabled)), for: .normal)
        confirmButton.isEnabled = false
    }
    
    
    // MARK: - Event Response
    @objc func buttonDidTap() {
        delegate?.OrderDidConfirm()
    }
}
