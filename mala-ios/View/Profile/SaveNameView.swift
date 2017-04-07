//
//  SaveNameView.swift
//  mala-ios
//
//  Created by 王新宇 on 3/12/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class SaveNameView: UIView, UITextFieldDelegate {

    // MARK: - Property
    var controller: UIViewController?
    
    
    // MARK: - Components
    /// 输入区域背景
    private lazy var inputBackground: UIView = {
        let inputBackground = UIView()
        inputBackground.backgroundColor = UIColor.white
        return inputBackground
    }()
    /// 输入控件
    private lazy var inputField: UITextField = {
        let inputField = UITextField()
        inputField.textAlignment = .center
        inputField.placeholder = "请输入学生姓名"
        inputField.font = UIFont.systemFont(ofSize: 14)
        inputField.textColor = UIColor(named: .ArticleText)
        inputField.tintColor = UIColor(named: .ThemeBlue)
        inputField.addTarget(self, action: #selector(SaveNameView.inputFieldDidChange), for: .editingChanged)
        return inputField
    }()
    /// 描述label
    private lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor(named: .HeaderTitle)
        descLabel.font = UIFont.systemFont(ofSize: 12)
        descLabel.text = "请填写真实姓名，不得超过4个汉字"
        return descLabel
    }()
    /// [验证] 按钮
    private lazy var finishButton: UIButton = {
        let finishButton = UIButton()
        finishButton.layer.cornerRadius = 5
        finishButton.layer.masksToBounds = true
        finishButton.setTitle("完成", for: UIControlState())
        finishButton.setTitleColor(UIColor.white, for: UIControlState())
        finishButton.setBackgroundImage(UIImage.withColor(UIColor(named: .LoginBlue)), for: .disabled)
        finishButton.setBackgroundImage(UIImage.withColor(UIColor(named: .ThemeBlueTranslucent95)), for: UIControlState())
        finishButton.addTarget(self, action: #selector(SaveNameView.finishButtonDidTap), for: .touchUpInside)
        finishButton.isEnabled = false
        return finishButton
    }()
    
    
    // MARK: - Constructed
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
        backgroundColor = UIColor(named: .CardBackground)
        
        // SubViews
        addSubview(inputBackground)
        addSubview(inputField)
        addSubview(descLabel)
        addSubview(finishButton)
        
        // Autolayout
        inputBackground.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self).offset(12)
            maker.left.equalTo(self)
            maker.right.equalTo(self)
            maker.height.equalTo(MalaLayout_ProfileModifyViewHeight)
        }
        inputField.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(inputBackground)
            maker.right.equalTo(inputBackground)
            maker.centerY.equalTo(inputBackground)
        }
        descLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(inputBackground.snp.bottom).offset(12)
            maker.left.equalTo(self).offset(12)
            maker.height.equalTo(12)
        }
        finishButton.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(descLabel.snp.bottom).offset(12)
            maker.left.equalTo(self).offset(12)
            maker.right.equalTo(self).offset(-12)
            maker.height.equalTo(37)
        }
    }
    
    private func validateName(_ name: String) -> Bool {
        let nameRegex = "^[\\u4e00-\\u9fa5]{2,4}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: name)
    }
    
    
    // MARK: - Event Response
    @objc private func inputFieldDidChange() {
        guard let name = inputField.text else { return }
        finishButton.isEnabled = validateName(name)
    }
    
    @objc private func finishButtonDidTap() {
        guard let name = inputField.text else { return }
        
        MAProvider.saveStudentName(name: name) { result in
            println("Save Student Name - \(result as Optional)")
            
            guard let result = result, result == true else {
                self.showToastAtBottom(L10n.networkNotReachable)
                return
            }
            
            MalaUserDefaults.studentName.value = name
            MalaUserDefaults.fetchUserInfo()
            self.closeButtonDidClick()
        }
    }
    
    @objc private func closeButtonDidClick() {
        controller?.dismiss(animated: true, completion: nil)
    }
}
