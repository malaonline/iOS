//
//  LoginViewController.swift
//  mala-ios
//
//  Created by Erdi on 12/31/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Property
    /// 弹栈闭包
    var popAction: (()->())?
    /// 关闭闭包
    var closeAction: (()->())?
    
    // MARK: - Components
    private lazy var header: UIImageView = {
        let view = UIImageView(image: UIImage(asset: .loginFill))
        return view
    }()
    private lazy var headerLogo: UIImageView = {
        let view = UIImageView(image: UIImage(asset: .loginLogo))
        return view
    }()
    private lazy var phoneView: UIView = {
        let view = UIView(UIColor.white)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.addShadow(offset: 4, color: UIColor(named: .loginShadow), opacity: 1)
        return view
    }()
    private lazy var codeView: UIView = {
        let view = UIView(UIColor.white)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.addShadow(offset: 4, color: UIColor(named: .loginShadow), opacity: 1)
        return view
    }()
    /// 手机图标
    private lazy var phoneIcon: UIImageView = {
        let phoneIcon = UIImageView(imageName: "phone")
        return phoneIcon
    }()
    /// 获取验证码按钮
    private lazy var codeGetButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.getVerificationCode, for: .normal)
        button.setTitleColor(UIColor(named: .LoginBlue), for: .normal)
        button.setTitleColor(UIColor(named: .loginDisableBlue), for: .disabled)
        button.titleLabel?.font = FontFamily.PingFangSC.Regular.font(16)
        button.addTarget(self, action: #selector(LoginViewController.codeGetButtonDidTap), for: .touchUpInside)
        return button
    }()
    /// [手机号错误] 提示
    private lazy var phoneError: UIButton = {
        let phoneError = UIButton()
        phoneError.setImage(UIImage(asset: .error), for: UIControlState())
        phoneError.setTitleColor(UIColor(named: .OrderStatusRed), for: UIControlState())
        phoneError.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        phoneError.setTitle(L10n.invalidNumber, for: UIControlState())
        phoneError.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)
        phoneError.isHidden = true
        return phoneError
    }()
    /// 手机号码输入框
    private lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.placeholder = L10n.inputYourNumber
        textField.font = FontFamily.PingFangSC.Regular.font(16)
        textField.textColor = UIColor(named: .ArticleSubTitle)
        textField.addTarget(self, action: #selector(UITextInputDelegate.textDidChange(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(LoginViewController.didBeginEditing), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(LoginViewController.didEndEditing), for: .editingDidEnd)
        textField.clearButtonMode = .never 
        return textField
    }()
    /// 验证码图标
    private lazy var codeIcon: UIImageView = {
        let codeIcon = UIImageView(imageName: "verifyCode")
        return codeIcon
    }()
    /// [验证码错误] 提示
    private lazy var codeError: UIButton = {
        let codeError = UIButton()
        codeError.setImage(UIImage(asset: .error), for: UIControlState())
        codeError.setTitleColor(UIColor(named: .OrderStatusRed), for: UIControlState())
        codeError.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        codeError.setTitle(L10n.verificationCodeNotMatch, for: UIControlState())
        codeError.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)
        codeError.isHidden = true
        return codeError
    }()
    /// 验证码输入框
    private lazy var codeTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.placeholder = L10n.verificationCode
        textField.textColor = UIColor(named: .ArticleSubTitle)
        textField.font = FontFamily.PingFangSC.Regular.font(16)
        textField.addTarget(self, action: #selector(UITextInputDelegate.textDidChange(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(LoginViewController.didBeginEditing), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(LoginViewController.didEndEditing), for: .editingDidEnd)
        return textField
    }()
    /// 登录按钮
    private lazy var verifyButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        button.setTitle("登  录", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .loginBlue)), for: .normal)
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .loginDisableBlue)), for: .highlighted)
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .loginDisableBlue)), for: .disabled)
        button.addTarget(self, action: #selector(LoginViewController.verifyButtonDidTap), for: .touchUpInside)
        return button
    }()
    // 协议label
    private lazy var protocolLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.PingFangSC.Regular.font(12)
        label.textColor = UIColor(named: .protocolGary)
        label.text = L10n.protocolDesc
        return label
    }()
    // 协议文字label
    private lazy var protocolString: UILabel = {
        let label = UILabel()
        label.font = FontFamily.PingFangSC.Regular.font(14)
        label.textColor = UIColor(named: .loginBlue)
        label.text = L10n.malaUserProtocol
        label.isUserInteractionEnabled = true
        label.addTapEvent(target: self, action: #selector(LoginViewController.protocolDidTap))
        return label
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
        view.backgroundColor = UIColor(named: .loginLightBlue)
        let leftBarButtonItem = UIBarButtonItem(customView:UIButton(imageName: "close_white", target: self, action: #selector(LoginViewController.closeButtonDidClick)))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        navigationController?.navigationBar.setBackgroundImage(UIImage.withColor(UIColor(named: .loginBlue)), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // SubView
        view.addSubview(header)
        header.addSubview(headerLogo)
        
        view.addSubview(phoneView)
        phoneView.addSubview(phoneIcon)
        phoneView.addSubview(phoneTextField)
        
        view.addSubview(codeView)
        codeView.addSubview(codeIcon)
        codeView.addSubview(codeTextField)
        codeView.addSubview(codeGetButton)
        
//        view.addSubview(phoneError)
//        view.addSubview(codeError)
        view.addSubview(verifyButton)
        view.addSubview(protocolLabel)
        view.addSubview(protocolString)
        
        // Autolayout
        header.snp.makeConstraints { (maker) in
            maker.top.equalTo(view)
            maker.width.equalTo(view).multipliedBy(1.2)
            maker.centerX.equalTo(view)
            maker.height.equalTo(183)
        }
        headerLogo.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(header)
            maker.bottom.equalTo(header.snp.bottom).offset(-45)
        }
        // phone
        phoneView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(view)
            maker.centerY.equalTo(header.snp.bottom)
            maker.width.equalTo(320)
            maker.height.equalTo(52)
        }
        phoneIcon.snp.makeConstraints { (maker) in
            maker.width.equalTo(16)
            maker.height.equalTo(22)
            maker.centerY.equalTo(phoneView)
            maker.left.equalTo(phoneView).offset(10)
        }
        phoneTextField.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(phoneView)
            maker.height.equalTo(22)
            maker.left.equalTo(phoneView).offset(41)
            maker.right.equalTo(phoneView).offset(-15)
        }
        // code
        codeView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(view)
            maker.top.equalTo(phoneView.snp.bottom).offset(16)
            maker.width.equalTo(320)
            maker.height.equalTo(52)
        }
        codeIcon.snp.makeConstraints { (maker) in
            maker.width.equalTo(24.3)
            maker.height.equalTo(17.7)
            maker.centerY.equalTo(codeView)
            maker.left.equalTo(codeView).offset(10)
        }
        codeTextField.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(codeView)
            maker.height.equalTo(22)
            maker.left.equalTo(codeView).offset(41)
            maker.right.equalTo(codeView).offset(-15)
        }
        codeGetButton.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(codeView)
            maker.right.equalTo(codeView).offset(-15)
            maker.height.equalTo(22)
        }
        
        verifyButton.snp.makeConstraints { (maker) in
            maker.width.equalTo(320)
            maker.height.equalTo(48)
            maker.centerX.equalTo(view)
            maker.top.equalTo(codeView.snp.bottom).offset(60)
        }
        // protocol
        protocolLabel.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(view)
            maker.bottom.equalTo(protocolString.snp.top).offset(-2)
        }
        protocolString.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(view)
            maker.bottom.equalTo(view).offset(-30)
        }
    }
    
    private func validateMobile(_ mobile: String) -> Bool {
        
        // 演示账号处理
        if mobile.subStringToIndex(3) == "000" && mobile.characters.count == 4 {
            return true
        }
        
        // 正式手机号
        let mobileRegex = "^1[3|4|5|7|8][0-9]\\d{8}$"
        let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
        return mobileTest.evaluate(with: mobile)
    }
    
    ///  倒计时
    private func countDown() {
        self.callMeInSeconds = MalaConfig.callMeInSeconds()
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .default))
        
        timer.scheduleRepeating(deadline: .now(), interval: 1)
        timer.setEventHandler { [weak self] in
            
            guard let strongSelf = self else { return }
            
            if strongSelf.callMeInSeconds <= 0 { // 倒计时完成
                timer.cancel()
                DispatchQueue.main.async{ () -> Void in
                    strongSelf.codeGetButton.setTitle(L10n.getVerificationCode, for: UIControlState())
                    strongSelf.codeGetButton.isEnabled = true
                }
            }else { // 继续倒计时
                DispatchQueue.main.async{ () -> Void in
                    strongSelf.codeGetButton.setTitle(String(format: " %02ds后获取 ", Int(strongSelf.callMeInSeconds)), for: .normal)
                    strongSelf.codeGetButton.isEnabled = false
                }
                strongSelf.callMeInSeconds -= 1
            }
        }
        timer.resume()
    }
    
    
    // MARK: - Event Response
    ///  用户协议点击事件
    @objc private func protocolDidTap() {
        let webViewController = MalaSingleWebViewController()
        webViewController.url = ""
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    @objc private func didBeginEditing() {
        header.snp.remakeConstraints({ (maker) in
            maker.top.equalTo(view)
            maker.width.equalTo(view).multipliedBy(1.2)
            maker.centerX.equalTo(view)
            maker.height.equalTo(0)
        })
        phoneView.snp.remakeConstraints { (maker) in
            maker.centerX.equalTo(view)
            maker.top.equalTo(view).offset(15)
            maker.width.equalTo(320)
            maker.height.equalTo(52)
        }
        
        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func didEndEditing() {
        header.snp.remakeConstraints { (maker) in
            maker.top.equalTo(view)
            maker.width.equalTo(view).multipliedBy(1.2)
            maker.centerX.equalTo(view)
            maker.height.equalTo(183)
        }
        phoneView.snp.remakeConstraints { (maker) in
            maker.centerX.equalTo(view)
            maker.centerY.equalTo(header.snp.bottom)
            maker.width.equalTo(320)
            maker.height.equalTo(52)
        }
        
        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
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
        guard let phone = self.phoneTextField.text else { return }
        
        // 发送SMS
        MAProvider.sendSMS(phone: phone, failureHandler: { [weak self] error in
            self?.ShowToast(L10n.networkNotReachable)
        }) { [weak self] sent in
            DispatchQueue.main.async {
                self?.ShowToast(sent ? L10n.verificationCodeSentSuccess : L10n.verificationCodeSentFailure)
                self?.codeTextField.becomeFirstResponder()
            }
        }
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
        
        guard let phone = self.phoneTextField.text else { return }
        guard let code = self.codeTextField.text else { return }
        // 验证SMS
        MAProvider.verifySMS(phone: phone, code: code, failureHandler: { (error) in
            self.resetStatus()
        }) { (loginUser) in
            
            println("信息获取成功：\(loginUser as Optional)")
            
            guard let loginUser = loginUser else {
                self.resetStatus()
                self.ShowToast(L10n.verificationCodeNotMatch)
                return
            }
            
            MalaUserDefaults.storeAccountInfo(loginUser)
            MalaUserDefaults.isLogouted = false
             
            if loginUser.firstLogin == true {
                self.switchViewToSaveName()
            }else {
                self.close(animated: true)
            }
            MalaCurrentInitAction?()
        }
    }
    
    @objc private func closeButtonDidClick() {
        
        self.phoneTextField.resignFirstResponder()
        self.codeTextField.resignFirstResponder()
        
        closeAction?()
        dismiss(animated: true, completion: nil)
    }
    
    // 状态恢复
    func resetStatus() {
        DispatchQueue.main.async {
            self.codeError.isHidden = false
            self.codeTextField.text = ""
        }
    }
    
    func switchViewToSaveName() {
        DispatchQueue.main.async {
            let view = SaveNameView()
            view.controller = self
            self.view = view
        }
    }
    
    func close(animated flag: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            MalaUserDefaults.fetchUserInfo()
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    deinit {
        popAction?()
        MalaMainViewController?.loadUnpaindOrder()
        println("LoginViewController - Deinit")
    }
}
