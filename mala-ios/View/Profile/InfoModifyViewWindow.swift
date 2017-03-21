//
//  InfoModifyViewWindow.swift
//  mala-ios
//
//  Created by 王新宇 on 16/6/12.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

open class InfoModifyViewWindow: UIViewController, UITextViewDelegate {
    
    // MARK: - Property
    /// 姓名文字
    var nameString: String? = MalaUserDefaults.studentName.value
    /// 自身强引用
    var strongSelf: InfoModifyViewWindow?
    /// 遮罩层透明度
    let tBakcgroundTansperancy: CGFloat = 0.7
    /// 布局容器（窗口）
    var window = UIView()
    /// 内容视图
    var contentView: UIView?
    /// 单击背景close窗口
    var closeWhenTap: Bool = false
    
    
    // MARK: - Components
    /// 取消按钮.[取消]
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.cancel, for: UIControlState())
        // cancelButton.setTitleColor(UIColor(named: .ThemeBlue), forState: .Normal)
        button.setTitleColor(UIColor(named: .DescGray), for: UIControlState())
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .WhiteTranslucent9)), for: UIControlState())
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .HighlightGray)), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(InfoModifyViewWindow.cancelButtonDidTap), for: .touchUpInside)
        return button
    }()
    /// 确认按钮.[去评价]
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("保存", for: UIControlState())
        button.setTitleColor(UIColor(named: .ThemeBlue), for: UIControlState())
        button.setTitleColor(UIColor(named: .DescGray), for: .highlighted)
        button.setTitleColor(UIColor(named: .DescGray), for: .disabled)
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .WhiteTranslucent9)), for: UIControlState())
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .HighlightGray)), for: .highlighted)
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .HighlightGray)), for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(InfoModifyViewWindow.saveButtonDidTap), for: .touchUpInside)
        return button
    }()
    private lazy var contentContainer: UIView = {
        let contentContainer = UIView()
        return contentContainer
    }()
    /// 按钮顶部装饰线
    private lazy var buttonTopLine: UIView = {
        let buttonTopLine = UIView(UIColor(named: .ThemeBlue))
        return buttonTopLine
    }()
    /// 按钮间隔装饰线
    private lazy var buttonSeparatorLine: UIView = {
        let buttonSeparatorLine = UIView(UIColor(named: .ThemeBlue))
        return buttonSeparatorLine
    }()
    /// 姓名文本框
    private lazy var nameLabel: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.textColor = UIColor(named: .ArticleText)
        textField.tintColor = UIColor(named: .ThemeBlue)
        textField.text = self.nameString
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(InfoModifyViewWindow.inputFieldDidChange), for: .editingChanged)
        return textField
    }()
    /// 姓名底部装饰线
    private lazy var nameLine: UIView = {
        let view = UIView(UIColor(named: .ThemeBlue))
        return view
    }()
    /// 提示文字标签
    private lazy var warningLabel: UILabel = {
        let label = UILabel(
            text: "* 请输入2-4位中文字符",
            fontSize: 11,
            textColor: UIColor(named: .ThemeRed)
        )
        return label
    }()
    
    
    // MARK: - Constructed
    init() {
        super.init(nibName: nil, bundle: nil)
        view.frame = UIScreen.main.bounds
        setupUserInterface()
        
        // 持有自己强引用，使自己在外界没有强引用时依然存在。
        strongSelf = self
    }
    
    convenience init(contentView: UIView) {
        self.init()
        view.alpha = 0
        
        // 显示Window
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(view)
        window.bringSubview(toFront: view)
        view.frame = window.bounds
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - API
    open func show() {
        animateAlert()
    }
    
    open func close() {
        closeAlert(0)
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: tBakcgroundTansperancy)
        view.addTapEvent(target: self, action: #selector(InfoModifyViewWindow.backgroundDidTap))
        window.backgroundColor = UIColor.white
        
        // SubViews
        view.addSubview(window)
        window.addSubview(contentContainer)
        window.addSubview(nameLine)
        window.addSubview(nameLabel)
        window.addSubview(warningLabel)
        window.addSubview(cancelButton)
        window.addSubview(saveButton)
        window.addSubview(buttonTopLine)
        window.addSubview(buttonSeparatorLine)
        
        // Autolayout
        window.snp.makeConstraints { (maker) -> Void in
            maker.center.equalTo(view)
            maker.width.equalTo(MalaLayout_CoursePopupWindowWidth)
            maker.height.equalTo(MalaLayout_CoursePopupWindowWidth*0.588)
        }
        contentContainer.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(window)
            maker.left.equalTo(window)
            maker.right.equalTo(window)
            maker.bottom.equalTo(buttonTopLine.snp.top)
        }
        nameLine.snp.makeConstraints { (maker) -> Void in
            maker.height.equalTo(2)
            maker.centerX.equalTo(contentContainer)
            maker.centerY.equalTo(contentContainer.snp.bottom).multipliedBy(0.65)
            maker.width.equalTo(window).multipliedBy(0.8)
        }
        nameLabel.snp.makeConstraints { (maker) -> Void in
            maker.height.equalTo(15)
            maker.centerX.equalTo(contentContainer)
            maker.bottom.equalTo(nameLine.snp.top).offset(-15)
            maker.width.equalTo(100)
        }
        warningLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(nameLine.snp.bottom).offset(10)
            maker.right.equalTo(nameLine)
        }
        cancelButton.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(window)
            maker.left.equalTo(window)
            maker.height.equalTo(44)
            maker.width.equalTo(window).multipliedBy(0.5)
        }
        saveButton.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(window)
            maker.right.equalTo(window)
            maker.height.equalTo(44)
            maker.width.equalTo(window).multipliedBy(0.5)
        }
        buttonTopLine.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(cancelButton.snp.top)
            maker.height.equalTo(MalaScreenOnePixel)
            maker.left.equalTo(window)
            maker.right.equalTo(window)
        }
        buttonSeparatorLine.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(cancelButton)
            maker.bottom.equalTo(window)
            maker.width.equalTo(MalaScreenOnePixel)
            maker.left.equalTo(cancelButton.snp.right)
        }
    }
    
    private func animateAlert() {
        view.alpha = 0;
        let originTransform = self.window.transform
        self.window.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.0);
        
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            self.view.alpha = 1.0
            self.window.transform = originTransform
        }) 
    }
    
    private func animateDismiss() {
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            self.view.alpha = 0
            self.window.transform = CGAffineTransform()
        }, completion: { (bool) -> Void in
            self.closeAlert(0)
        })
    }
    
    private func closeAlert(_ buttonIndex: Int) {
        self.view.removeFromSuperview()
        // 释放自身强引用
        self.strongSelf = nil
    }
    
    ///  保存学生姓名
    private func saveStudentsName() {
        guard let name = nameLabel.text else { return }
        
        MAProvider.saveStudentName(name: name) { result in
            println("Save Student Name - \(result)")
            
            MalaUserDefaults.studentName.value = name
            NotificationCenter.default.post(name: MalaNotification_RefreshStudentName, object: nil)
            DispatchQueue.main.async {
                self.animateDismiss()
            }
        }
    }
    
    
    // MARK: - Event Response
    @objc private func pressed(_ sender: UIButton!) {
        self.closeAlert(sender.tag)
    }
    
    @objc open  func backgroundDidTap() {
        if closeWhenTap {
            closeAlert(0)
        }
    }
    
    @objc private func cancelButtonDidTap() {
        close()
    }
    
    ///  验证姓名字符是否合规
    private func validateName(_ name: String) -> Bool {
        let nameRegex = "^[\\u4e00-\\u9fa5]{2,4}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: name)
    }
    
    ///  用户输入事件
    @objc private func inputFieldDidChange() {
        guard let name = nameLabel.text else { return }
        saveButton.isEnabled = validateName(name)
    }
    
    ///  保存按钮点击事件
    @objc private func saveButtonDidTap() {
        saveStudentsName()
    }
}
