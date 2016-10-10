//
//  LoginViewController.swift
//  mala-ios
//
//  Created by Erdi on 12/31/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit
private func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

private func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class LoginViewController: UIViewController {
    
    // MARK: - Property
    /// 弹栈闭包
    var popAction: (()->())?
    /// 关闭闭包
    var closeAction: (()->())?
    
    
    // MARK: - Components
    /// 主要布局容器
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
        return contentView
    }()
    /// 容器顶部装饰线
    private lazy var topSeparator: UIView = {
        let topSeparator = UIView()
        topSeparator.backgroundColor = MalaColor_E5E5E5_0
        return topSeparator
    }()
    /// 容器中部装饰线
    private lazy var middleSeparator: UIView = {
        let middleSeparator = UIView()
        middleSeparator.backgroundColor = MalaColor_E5E5E5_0
        return middleSeparator
    }()
    /// 容器底部装饰线
    private lazy var bottomSeparator: UIView = {
        let bottomSeparator = UIView()
        bottomSeparator.backgroundColor = MalaColor_E5E5E5_0
        return bottomSeparator
    }()
    /// 手机图标
    private lazy var phoneIcon: UIImageView = {
        let phoneIcon = UIImageView(image: UIImage(named: "phone"))
        return phoneIcon
    }()
    /// [获取验证码] 按钮
    private lazy var codeGetButton: UIButton = {
        let codeGetButton = UIButton()
        codeGetButton.layer.borderColor = MalaColor_8DBEDF_0.cgColor
        codeGetButton.layer.borderWidth = 1.0
        codeGetButton.layer.cornerRadius = 3.0
        codeGetButton.layer.masksToBounds = true
        codeGetButton.setTitle(" 获取验证码 ", for: UIControlState())
        codeGetButton.setTitleColor(UIColor.white, for: UIControlState())
        codeGetButton.setTitleColor(MalaColor_8DBEDF_0, for: .disabled)
        codeGetButton.setBackgroundImage(UIImage.withColor(MalaColor_8DBEDF_0), for: UIControlState())
        codeGetButton.setBackgroundImage(UIImage.withColor(UIColor.white), for: .disabled)
        codeGetButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        codeGetButton.addTarget(self, action: #selector(LoginViewController.codeGetButtonDidTap), for: .touchUpInside)
        return codeGetButton
    }()
    /// [手机号错误] 提示
    private lazy var phoneError: UIButton = {
        let phoneError = UIButton()
        phoneError.setImage(UIImage(named: "error"), for: UIControlState())
        phoneError.setTitleColor(MalaColor_E36A5D_0, for: UIControlState())
        phoneError.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        phoneError.setTitle("手机号错误", for: UIControlState())
        phoneError.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)
        phoneError.isHidden = true
        return phoneError
    }()
    /// 手机号码输入框
    private lazy var phoneTextField: UITextField = {
        let phoneTextField = UITextField()
        phoneTextField.keyboardType = .numberPad
        phoneTextField.placeholder = "请输入手机号"
        phoneTextField.font = UIFont.systemFont(ofSize: 14)
        phoneTextField.textColor = MalaColor_6C6C6C_0
        phoneTextField.addTarget(self, action: #selector(UITextInputDelegate.textDidChange(_:)), for: .editingChanged)
        phoneTextField.clearButtonMode = .never
        return phoneTextField
    }()
    /// 验证码图标
    private lazy var codeIcon: UIImageView = {
        let codeIcon = UIImageView(image: UIImage(named: "verifyCode"))
        return codeIcon
    }()
    /// [验证码错误] 提示
    private lazy var codeError: UIButton = {
        let codeError = UIButton()
        codeError.setImage(UIImage(named: "error"), for: UIControlState())
        codeError.setTitleColor(MalaColor_E36A5D_0, for: UIControlState())
        codeError.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        codeError.setTitle("验证码错误", for: UIControlState())
        codeError.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)
        codeError.isHidden = true
        return codeError
    }()
    /// 验证码输入框
    private lazy var codeTextField: UITextField = {
        let codeTextField = UITextField()
        codeTextField.keyboardType = .numberPad
        codeTextField.placeholder = "请输入验证码"
        codeTextField.textColor = MalaColor_6C6C6C_0
        codeTextField.font = UIFont.systemFont(ofSize: 14)
        codeTextField.addTarget(self, action: #selector(UITextInputDelegate.textDidChange(_:)), for: .editingChanged)
        return codeTextField
    }()
    /// [验证] 按钮
    private lazy var verifyButton: UIButton = {
        let verifyButton = UIButton()
        verifyButton.layer.cornerRadius = 5
        verifyButton.layer.masksToBounds = true
        verifyButton.setTitle("验证", for: UIControlState())
        verifyButton.setTitleColor(UIColor.white, for: UIControlState())
        verifyButton.setBackgroundImage(UIImage.withColor(MalaColor_8DBEDF_0), for: .disabled)
        verifyButton.setBackgroundImage(UIImage.withColor(MalaColor_88BCDE_95), for: UIControlState())
        verifyButton.addTarget(self, action: #selector(LoginViewController.verifyButtonDidTap), for: .touchUpInside)
        return verifyButton
    }()
    // 协议label
    private lazy var protocolLabel: UILabel = {
        let protocolLabel = UILabel()
        protocolLabel.font = UIFont.systemFont(ofSize: 12)
        protocolLabel.textColor = MalaColor_939393_0
        protocolLabel.text = "轻触上面验证按钮即表示你同意"
        return protocolLabel
    }()
    // 协议文字label
    private lazy var protocolString: UILabel = {
        let protocolString = UILabel()
        protocolString.font = UIFont.systemFont(ofSize: 12)
        protocolString.textColor = MalaColor_88BCDE_95
        protocolString.text = "麻辣老师用户协议"
        protocolString.isUserInteractionEnabled = true
        protocolString.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.protocolDidTap)))
        return protocolString
    }()
    
    private var callMeInSeconds = MalaConfig.callMeInSeconds()
    

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        self.title = "验证"
        self.view.backgroundColor = MalaColor_EDEDED_0
        let leftBarButtonItem = UIBarButtonItem(customView:UIButton(imageName: "close", target: self, action: #selector(LoginViewController.closeButtonDidClick)))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        
        // SubView
        view.addSubview(contentView)
        contentView.addSubview(topSeparator)
        contentView.addSubview(middleSeparator)
        contentView.addSubview(bottomSeparator)
        contentView.addSubview(phoneIcon)
        contentView.addSubview(codeGetButton)
        contentView.addSubview(phoneError)
        contentView.addSubview(phoneTextField)
        contentView.addSubview(codeIcon)
        contentView.addSubview(codeError)
        contentView.addSubview(codeTextField)
        view.addSubview(verifyButton)
        view.addSubview(protocolLabel)
        view.addSubview(protocolString)
        
        // Autolayout
        contentView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.view.snp.top).offset(12)
            maker.left.equalTo(self.view.snp.left)
            maker.right.equalTo(self.view.snp.right)
            maker.height.equalTo(93)
        }
        topSeparator.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.contentView.snp.top)
            maker.height.equalTo(MalaScreenOnePixel)
            maker.left.equalTo(self.contentView.snp.left)
            maker.right.equalTo(self.contentView.snp.right)
        }
        middleSeparator.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(self.contentView.snp.centerY)
            maker.height.equalTo(MalaScreenOnePixel)
            maker.left.equalTo(self.contentView.snp.left)
            maker.right.equalTo(self.contentView.snp.right)
        }
        bottomSeparator.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(self.contentView.snp.bottom)
            maker.height.equalTo(MalaScreenOnePixel)
            maker.left.equalTo(self.contentView.snp.left)
            maker.right.equalTo(self.contentView.snp.right)
        }
        phoneIcon.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.contentView.snp.top).offset(15)
            maker.left.equalTo(self.contentView.snp.left).offset(14)
            maker.width.equalTo(10)
            maker.height.equalTo(15)
        }
        codeGetButton.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.contentView.snp.top).offset(9)
            maker.right.equalTo(self.contentView.snp.right).offset(-12)
            maker.width.equalTo(67)
            maker.height.equalTo(27)
        }
        phoneError.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(self.codeGetButton)
            maker.right.equalTo(self.codeGetButton.snp.left).offset(-4)
            maker.width.equalTo(67)
            maker.height.equalTo(15)
        }
        phoneTextField.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(self.phoneIcon.snp.right).offset(10)
            maker.right.equalTo(self.phoneError.snp.left).offset(-5)
            maker.centerY.equalTo(self.phoneIcon.snp.centerY)
            maker.height.equalTo(25)
        }
        codeIcon.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-15)
            maker.left.equalTo(self.contentView.snp.left).offset(14)
        }
        codeError.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-9)
            maker.right.equalTo(self.contentView.snp.right).offset(-12)
            maker.width.equalTo(67)
            maker.height.equalTo(27)
        }
        codeTextField.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(self.codeIcon.snp.right).offset(7)
            maker.right.equalTo(self.codeError.snp.left).offset(-5)
            maker.centerY.equalTo(self.codeIcon.snp.centerY)
            maker.height.equalTo(25)
        }
        verifyButton.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.contentView.snp.bottom).offset(12)
            maker.left.equalTo(self.view.snp.left).offset(12)
            maker.right.equalTo(self.view.snp.right).offset(-12)
            maker.height.equalTo(37)
        }
        protocolLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.verifyButton.snp.bottom).offset(12)
            maker.left.equalTo(self.view.snp.left).offset(12)
            maker.right.equalTo(self.protocolString.snp.left)
        }
        protocolString.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(self.protocolLabel.snp.centerY)
            maker.left.equalTo(self.protocolLabel.snp.right)
            // 增加高度，扩大热区
            maker.height.equalTo(self.protocolLabel.snp.height).offset(10)
        }
    }
    
    private func validateMobile(_ mobile: String) -> Bool {
        
        // 演示账号处理
        if mobile.subStringToIndex(3) == "000" && mobile.characters.count == 4 {
            return true
        }
        
        // 正式手机号
        let mobileRegex = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"
        let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
        return mobileTest.evaluate(with: mobile)
    }
    
    ///  倒计时
    private func countDown() {
        self.callMeInSeconds = MalaConfig.callMeInSeconds()
        let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
        let timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: queue)
        timer.setTimer(start: DispatchWallTime(time: nil), interval: UInt64(TimeInterval(NSEC_PER_SEC)), leeway: 0)
        timer.setEventHandler {[weak self] () -> Void in
            
            if self?.callMeInSeconds <= 0 { // 倒计时完成
                timer.cancel()
                DispatchQueue.main.async(execute: { () -> Void in
                    self?.codeGetButton.setTitle(" 获取验证码 ", for: UIControlState())
                    self?.codeGetButton.isEnabled = true
                })
            }else { // 继续倒计时
                DispatchQueue.main.async(execute: { () -> Void in
                    self?.codeGetButton.setTitle(String(format: " %02ds后获取 ", Int((self?.callMeInSeconds)!)), for: .normal)
                    self?.codeGetButton.isEnabled = false
                })
                self?.callMeInSeconds -= 1
            }
        }
        timer.resume()
    }
    
    
    // MARK: - Event Response
    ///  用户协议点击事件
    @objc private func protocolDidTap() {
        println("用户协议点击事件")
        
        let webViewController = MalaSingleWebViewController()
        webViewController.url = ""
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        // 若当前有错误信息出现，用户开始编辑时移除错误显示
        if !phoneError.isHidden {
            phoneError.isHidden = true
        }else if !codeError.isHidden {
            codeError.isHidden = true
        }
    }
    
    @objc private func codeGetButtonDidTap() {        
        // 验证手机号
        if !validateMobile(phoneTextField.text ?? "") {
            self.phoneError.isHidden = false
            self.phoneTextField.text = ""
            self.phoneTextField.becomeFirstResponder()
            return
        }
                
        countDown()
        ThemeHUD.showActivityIndicator()
        
        // 发送SMS
        sendVerifyCodeOfMobile(self.phoneTextField.text!, failureHandler: { reason, errorMessage in
            
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            
            // 错误处理
            if let errorMessage = errorMessage {
                println("LoginViewController - SendCode Error \(errorMessage)")
            }
        }, completion: { [weak self] bool in
            ThemeHUD.hideActivityIndicator()
            println("send Verifycode -  \(bool)")
            DispatchQueue.main.async(execute: { [weak self] () -> Void in
                self?.codeTextField.becomeFirstResponder()
            })
        })
    }

    @objc private func verifyButtonDidTap() {
        // 验证信息
        if !validateMobile(phoneTextField.text ?? "") {
            self.phoneError.isHidden = false
            self.phoneTextField.text = ""
            self.phoneTextField.becomeFirstResponder()
            return
        }
        if (codeTextField.text ?? "") == "" {
            self.codeError.isHidden = false
            self.codeTextField.text = ""
            self.codeTextField.becomeFirstResponder()
            return
        }
        
        ThemeHUD.showActivityIndicator()
        
        // 验证SMS
        verifyMobile(self.phoneTextField.text!, verifyCode: self.codeTextField.text!, failureHandler: { [weak self] (reason, errorMessage) -> Void in
            
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            
            // 错误处理
            if let errorMessage = errorMessage {
                println("LoginViewController - VerifyCode Error \(errorMessage)")
            }
            
            DispatchQueue.main.async {
                self?.codeError.isHidden = false
                self?.codeTextField.text = ""
            }
        }, completion: { [weak self] (loginUser) -> Void in
            ThemeHUD.hideActivityIndicator()
            println("SMS验证成功，用户Token：\(loginUser)")
            saveTokenAndUserInfo(loginUser)
            MalaUserDefaults.isLogouted = false
            
            if loginUser.firstLogin == true {
                self?.switchViewToSaveName()
            }else {
                self?.dismiss(animated: true, completion: nil)
                getInfoWhenLoginSuccess()
            }
            
            MalaCurrentInitAction?()
        })
    }
    
    @objc private func closeButtonDidClick() {
        closeAction?()
        dismiss(animated: true, completion: nil)
    }
    
    func switchViewToSaveName() {
        DispatchQueue.main.async { [weak self] () -> Void in
            let view = SaveNameView()
            view.controller = self
            self?.view = view
        }
    }
    
    deinit {
        popAction?()
        MalaMainViewController.loadUnpaindOrder()
        println("LoginViewController - Deinit")
    }
}
