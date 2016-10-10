//
//  TeacherDetailsSignupView.swift
//  mala-ios
//
//  Created by Elors on 1/8/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

// MARK: - SignupButtonDelegate
protocol SignupButtonDelegate: class, NSObjectProtocol {
    func signupButtonDidTap(_ sender: UIButton)
    func likeButtonDidTap(_ sender: DOFavoriteButton)
}

// MARK: - TeacherDetailsSignupView
class TeacherDetailsSignupView: UIView {
    
    // MARK: - Property
    weak var delegate: SignupButtonDelegate?
    /// 是否已上架标识
    var isPublished: Bool = false {
        didSet {
            println("已上架标识 - \(isPublished)")
            adjustUIWithPublished()
        }
    }
    /// 是否已收藏标识
    var isFavorite: Bool = false {
        didSet {
            println("已收藏标识 - \(isFavorite)")
            adjustUIWithFavorite()
        }
    }
    
    
    // MARK: - Components
    /// 装饰线
    private lazy var topLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.25
        return view
    }()
    /// 收藏操作区域
    private lazy var likeView: UIView = {
        let view = UIView()
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TeacherDetailsSignupView.likeButtonDidTap)))
//        view.userInteractionEnabled = true
        return view
    }()
    /// 收藏文字描述
    private lazy var likeString: UIButton = {
        let button = UIButton()
        button.setTitle("收藏", for: UIControlState())
        button.setTitle("已收藏", for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.setTitleColor(MalaColor_6C6C6C_0, for: UIControlState())
        button.isUserInteractionEnabled = false
        return button
    }()
    /// 收藏按钮
    private lazy var likeButton: DOFavoriteButton = {
        let button = DOFavoriteButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44), image: UIImage(named: "heart"))
        button.imageColorOn = MalaColor_F76E6D_0
        button.circleColor = MalaColor_F76E6D_0
        button.lineColor = MalaColor_F76E6D_0
        button.addTarget(self, action: #selector(TeacherDetailsSignupView.likeButtonDidTap(_:)), for: .touchUpInside)
        // TODO: temp disable likeButton
        button.isUserInteractionEnabled = false
        return  button
    }()
    /// 报名按钮
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("马上报名", for: UIControlState())
        button.setTitle("该老师已下架", for: .disabled)
        button.setTitleColor(MalaColor_FFFFFF_9, for: UIControlState())
        button.setBackgroundImage(UIImage.withColor(MalaColor_7FB4DC_0), for: UIControlState())
        button.setBackgroundImage(UIImage.withColor(MalaColor_E0E0E0_0), for: .disabled)
        button.setBackgroundImage(UIImage.withColor(MalaColor_B2CDE1_0), for: .highlighted)
        button.addTarget(self, action: #selector(TeacherDetailsSignupView.signupButtonDidTap(_:)), for: .touchUpInside)
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
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        self.backgroundColor = MalaColor_F6F6F6_96

        // SubViews
        addSubview(topLine)
        addSubview(likeView)
        likeView.addSubview(likeButton)
        likeView.addSubview(likeString)
        addSubview(button)
        
        // Autolayout
        topLine.snp_makeConstraints({ (make) -> Void in
            make.left.equalTo(0)
            make.width.equalTo(MalaScreenWidth)
            make.top.equalTo(self.snp_top)
            make.height.equalTo(MalaScreenOnePixel)
        })
        likeView.snp_makeConstraints({ (make) -> Void in
            make.top.equalTo(topLine.snp_bottom)
            make.left.equalTo(self.snp_left)
            make.bottom.equalTo(self.snp_bottom)
            make.right.equalTo(self.snp_right).multipliedBy(0.422)
        })
        likeButton.snp_makeConstraints({ (make) -> Void in
            make.centerX.equalTo(likeView.snp_centerX)
            make.centerY.equalTo(likeView.snp_centerY).offset(-8)
            make.height.equalTo(44)
            make.width.equalTo(44)
        })
        likeString.snp_makeConstraints({ (make) -> Void in
            make.centerX.equalTo(likeView.snp_centerX)
            make.centerY.equalTo(likeView.snp_centerY).offset(10)
            make.height.equalTo(10)
            make.width.equalTo(40)
        })
        button.snp_makeConstraints({ (make) -> Void in
            make.top.equalTo(topLine.snp_bottom)
            make.left.equalTo(likeView.snp_right)
            make.bottom.equalTo(self.snp_bottom)
            make.right.equalTo(self.snp_right)
        })
    }
    
    ///  根据上架情况调整UI
    private func adjustUIWithPublished() {
        if isPublished {
            button.isEnabled = true
            button.isUserInteractionEnabled = true
        }else {
            button.isEnabled = false
            button.isUserInteractionEnabled = false
        }
    }
    
    ///  根据收藏情况调整UI
    private func adjustUIWithFavorite() {
        likeButton.isSelected = isFavorite
        if likeButton.isSelected  {
            likeButton.select()
        }else {
            likeButton.deselect()
        }
        likeString.isSelected = isFavorite
    }
    
    
    // MARK: - Event Response
    @objc private func signupButtonDidTap(_ sender: UIButton) {
        delegate?.signupButtonDidTap(sender)
    }
 
    @objc private func likeButtonDidTap(_ sender: DOFavoriteButton) {
        
        // 屏蔽1.25秒内操作，防止连续点击
        likeButton.isUserInteractionEnabled = false
        delay(1.25) {
            self.likeButton.userInteractionEnabled = true
        }
        
        delegate?.likeButtonDidTap(sender)
    }
    
    deinit {
        println("TeacherDetailsSignupView Deinit")
    }
}
