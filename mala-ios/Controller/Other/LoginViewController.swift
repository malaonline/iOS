//
//  LoginViewController.swift
//  mala-ios
//
//  Created by Erdi on 12/31/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Property
    /// 弹栈闭包
    var popAction: (()->())?
    /// 关闭闭包
    var closeAction: (()->())?

    
    // MARK: - Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.login
        label.font = FontFamily.PingFangSC.Regular.font(18)
        label.textColor = UIColor.white
        label.sizeToFit()
        return label
    }()
    private lazy var header: UIImageView = {
        let view = UIImageView(image: UIImage(asset: .loginFill))
        return view
    }()
    private lazy var headerLogo: UIImageView = {
        let view = UIImageView(image: UIImage(asset: .loginLogo))
        return view
    }()
    private lazy var phoneView: UIView = {
        let view = UIView.loginInputView()
        return view
    }()
    private lazy var codeView: UIView = {
        let view = UIView.loginInputView()
        return view
    }()
    private lazy var phoneViewShadow: UIView = {
        let view = UIView.loginInputShadow()
        return view
    }()
    private lazy var codeViewShadow: UIView = {
        let view = UIView.loginInputShadow()
        return view
    }()
    private lazy var phoneIcon: UIImageView = {
        let view = UIImageView(imageName: "phone")
        return view
    }()
    private lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.placeholder = L10n.inputYourNumber
        textField.font = FontFamily.PingFangSC.Regular.font(16)
        textField.textColor = UIColor(named: .ArticleSubTitle)
        textField.addTarget(self, action: #selector(LoginViewController.textDidChange), for: .editingChanged)
        textField.clearButtonMode = .never
        textField.delegate = self
        return textField
    }()
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(asset: .clearNormal), for: .normal)
        button.setBackgroundImage(UIImage(asset: .clearPress), for: .highlighted)
        button.addTarget(self, action: #selector(LoginViewController.clearButtonDidTap), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    private lazy var codeGetButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.getVerificationCode, for: .normal)
        button.setTitleColor(UIColor(named: .LoginBlue), for: .normal)
        button.setTitleColor(UIColor(named: .loginDisableBlue), for: .disabled)
        button.titleLabel?.font = FontFamily.PingFangSC.Regular.font(16)
        button.addTarget(self, action: #selector(LoginViewController.codeGetButtonDidTap), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    private lazy var codeIcon: UIImageView = {
        let codeIcon = UIImageView(imageName: "verifyCode")
        return codeIcon
    }()
    private lazy var codeTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.placeholder = L10n.verificationCode
        textField.textColor = UIColor(named: .ArticleSubTitle)
        textField.font = FontFamily.PingFangSC.Regular.font(16)
        return textField
    }()
    private lazy var verifyButton: UIButton = {
        let button = UIButton()
        button.setTitle("登    录", for: .normal)
        button.titleLabel?.font = FontFamily.PingFangSC.Regular.font(18)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(asset: .loginNormal), for: .normal)
        button.setBackgroundImage(UIImage(asset: .loginPress), for: .highlighted)
        button.setBackgroundImage(UIImage(asset: .loginPress), for: .disabled)
        button.addTarget(self, action: #selector(LoginViewController.verifyButtonDidTap), for: .touchUpInside)
        return button
    }()
    private lazy var protocolLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.PingFangSC.Regular.font(12)
        label.textColor = UIColor(named: .protocolGary)
        label.text = L10n.protocolDesc
        return label
    }()
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
        view.addTapEvent(target: self, action: #selector(LoginViewController.backgroundDidTap))
        let leftBarButtonItem = UIBarButtonItem(customView:UIButton(imageName: "close_white", target: self, action: #selector(LoginViewController.closeButtonDidClick)))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.titleView = titleLabel
        navigationItem.titleView?.alpha = 0
        
        navigationController?.navigationBar.setBackgroundImage(UIImage.withColor(UIColor(named: .loginBlue)), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // SubView
        view.addSubview(header)
        header.addSubview(headerLogo)
        
        view.addSubview(phoneView)
        view.insertSubview(phoneViewShadow, belowSubview: phoneView)
        phoneView.addSubview(phoneIcon)
        phoneView.addSubview(phoneTextField)
        phoneView.addSubview(clearButton)
        
        view.addSubview(codeView)
        view.insertSubview(codeViewShadow, belowSubview: codeView)
        codeView.addSubview(codeIcon)
        codeView.addSubview(codeTextField)
        codeView.addSubview(codeGetButton)
        
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
        phoneViewShadow.snp.makeConstraints { (maker) in
            maker.center.equalTo(phoneView)
            maker.size.equalTo(phoneView)
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
            maker.right.equalTo(clearButton.snp.left).offset(-15)
        }
        clearButton.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(phoneView)
            maker.right.equalTo(phoneView).offset(-15)
            maker.width.equalTo(20)
            maker.height.equalTo(20)
        }
        // code
        codeView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(view)
            maker.top.equalTo(phoneView.snp.bottom).offset(16)
            maker.width.equalTo(320)
            maker.height.equalTo(52)
        }
        codeViewShadow.snp.makeConstraints { (maker) in
            maker.center.equalTo(codeView)
            maker.size.equalTo(codeView)
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
            maker.right.equalTo(codeGetButton.snp.left).offset(-15)
        }
        codeGetButton.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(codeView)
            maker.right.equalTo(codeView).offset(-15)
            maker.height.equalTo(22)
            maker.width.equalTo(100)
        }
        
        verifyButton.snp.makeConstraints { (maker) in
            maker.width.equalTo(340)
            maker.height.equalTo(68)
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
        guard mobile.characters.count >= 4 else { return false }
        // 演示账号处理
        if mobile.subStringToIndex(3) == "000" && mobile.characters.count == 4 { return true }
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
                    strongSelf.codeGetButton.setTitle(L10n.getVerificationCode, for: .normal)
                    strongSelf.codeGetButton.isEnabled = true
                }
            }else { // 继续倒计时
                DispatchQueue.main.async{ () -> Void in
                    strongSelf.codeGetButton.setTitle(String(format: "%ds后获取", Int(strongSelf.callMeInSeconds)), for: .normal)
                    strongSelf.codeGetButton.isEnabled = false
                }
                strongSelf.callMeInSeconds -= 1
            }
        }
        timer.resume()
    }
    
    
    // MARK: - Keyboard Notification
    func keyboardWillShow(_ notification : Notification?) -> Void {
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
            self.titleLabel.alpha = 1
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(_ notification : Notification?) -> Void {
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
            self.titleLabel.alpha = 0
            self.view.layoutIfNeeded()
        })
    }
    
    
    // MARK: - TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 11
    }
    
    
    // MARK: - Event Response
    @objc private func clearButtonDidTap() {
        phoneTextField.text = nil
        clearButton.isHidden = true
    }
    
    @objc private func protocolDidTap() {
        let webViewController = MalaSingleWebViewController()
        webViewController.url = ""
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    @objc private func textDidChange() {
        codeGetButton.isEnabled = validateMobile(phoneTextField.text ?? "")
        clearButton.isHidden = !(phoneTextField.text?.characters.count > 0)
    }
    
    @objc private func backgroundDidTap() {
        resignResponder()
    }
    
    @objc private func codeGetButtonDidTap() {
        countDown()
        guard let phone = self.phoneTextField.text else { return }
        
        // 发送SMS
        MAProvider.sendSMS(phone: phone, failureHandler: { [weak self] error in
            self?.showToastAtCenter(L10n.networkNotReachable)
        }) { [weak self] sent in
            DispatchQueue.main.async {
                self?.showToastAtCenter(sent ? L10n.verificationCodeSentSuccess : L10n.verificationCodeSentFailure)
                self?.codeTextField.becomeFirstResponder()
            }
        }
    }

    @objc private func verifyButtonDidTap() {
        // 验证信息
        if !validateMobile(phoneTextField.text ?? "") {
            showToastAtCenter(L10n.invalidNumber)
            self.phoneTextField.text = ""
            self.phoneTextField.becomeFirstResponder()
            return
        }
        if (codeTextField.text ?? "") == "" {
            showToastAtCenter(L10n.verificationCodeNotMatch)
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
                self.showToastAtCenter(L10n.verificationCodeNotMatch)
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
        resignResponder()
        closeAction?()
        dismiss(animated: true, completion: nil)
    }
    
    private func resignResponder() {
        self.phoneTextField.resignFirstResponder()
        self.codeTextField.resignFirstResponder()
    }
    
    // 状态恢复
    func resetStatus() {
        DispatchQueue.main.async {
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
            self.resignResponder()
            MalaUserDefaults.fetchUserInfo()
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    deinit {
        popAction?()
        MalaMainViewController?.loadUnpaindOrder()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        println("LoginViewController - Deinit")
    }
}
