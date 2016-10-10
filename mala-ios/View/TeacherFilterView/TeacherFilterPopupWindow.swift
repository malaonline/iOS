//
//  TeacherFilterPopupWindow.swift
//  mala-ios
//
//  Created by Elors on 1/16/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

open class TeacherFilterPopupWindow: UIViewController {

    // MARK: - Property
    /// 自身强引用
    var strongSelf: TeacherFilterPopupWindow?
    /// 遮罩层透明度
    let tBakcgroundTansperancy: CGFloat = 0.7
    /// 布局容器（窗口）
    var window = UIView()
    /// 标题文字
    var tTitle: String = "  筛选年级  " {
        didSet {
            self.themeTitle.text = "  "+tTitle+"  "
        }
    }
    /// 图标名称
    var tIcon: String = "grade" {
        didSet {
            self.themeIcon.image = UIImage(named: tIcon)
        }
    }
    /// 内容视图
    var contentView: UIView?
    /// 单击背景close窗口
    var closeWhenTap: Bool = false
    
    
    // MARK: - Components
    private lazy var themeIcon: UIImageView = {
        let themeIcon = UIImageView()
        themeIcon.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        themeIcon.layer.cornerRadius = 32
        themeIcon.layer.masksToBounds = true
        themeIcon.backgroundColor = UIColor.lightGray
        themeIcon.image = UIImage(named: self.tIcon)
        return themeIcon
    }()
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setBackgroundImage(UIImage(named: "close_normal"), for: .normal)
        closeButton.setBackgroundImage(UIImage(named: "close_press"), for: .selected)
        closeButton.addTarget(self, action: #selector(TeacherFilterPopupWindow.pressed(_:)), for: .touchUpInside)
        return closeButton
    }()
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setBackgroundImage(UIImage(named: "leftArrow_normal"), for: .normal)
        cancelButton.setBackgroundImage(UIImage(named: "leftArrow_press"), for: .selected)
        cancelButton.addTarget(self, action: #selector(TeacherFilterPopupWindow.cancelButtonDidTap), for: .touchUpInside)
        cancelButton.isHidden = true
        return cancelButton
    }()
    private lazy var confirmButton: UIButton = {
        let confirmButton = UIButton()
        confirmButton.setBackgroundImage(UIImage(named: "confirm_normal"), for: .normal)
        confirmButton.setBackgroundImage(UIImage(named: "confirm_press"), for: .selected)
        confirmButton.addTarget(self, action: #selector(TeacherFilterPopupWindow.confirmButtonDidTap), for: .touchUpInside)
        confirmButton.isHidden = true
        return confirmButton
    }()
    private lazy var themeTitle: UILabel = {
        let themeTitle = UILabel()
        themeTitle.font = UIFont(name: "HelveticaNeue", size: 15)
        themeTitle.backgroundColor = UIColor.white
        themeTitle.textColor = MalaColor_939393_0
        themeTitle.text = self.tTitle
        return themeTitle
    }()
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = MalaColor_DADADA_0
        return separator
    }()
    private lazy var contentContainer: UIView = {
        let contentContainer = UIView()
        return contentContainer
    }()
    /// 页标指示器
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = MalaColor_C7DEEE_0
        pageControl.currentPageIndicatorTintColor = MalaColor_82B4D9_0
        
        // 添加横线
        let view = UIView()
        view.backgroundColor = MalaColor_C7DEEE_0
        pageControl.addSubview(view)
        view.snp.makeConstraints({ (maker) in
            maker.left.equalTo(pageControl.snp.left)
            maker.right.equalTo(pageControl.snp.right)
            maker.height.equalTo(MalaScreenOnePixel)
            maker.centerY.equalTo(pageControl.snp.centerY)
        })
        return pageControl
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
        self.view.alpha = 0
        
        // 显示Window
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(view)
        window.bringSubview(toFront: view)
        view.frame = window.bounds
        // 设置属性
        self.contentView = contentView
        if let view = contentView as? FilterView {
            view.container = self
        }
        updateUserInterface()
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
    
    
    // MARK: - Override
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if closeWhenTap {
            // 若触摸点不位于Window视图，关闭弹窗
            if let point = touches.first?.location(in: window), !window.point(inside: point, with: nil) {
                closeAlert(0)
            }
        }
    }
    

    // MARK: - API
    open func show() {
        animateAlert()
    }
    
    open func setButtonStatus(_ showClose: Bool, showCancel: Bool, showConfirm: Bool) {
        closeButton.isHidden = !showClose
        cancelButton.isHidden = !showCancel
        confirmButton.isHidden = !showConfirm
    }
    
    open func setPageControl(_ number: Int) {
        self.pageControl.currentPage = number
    }
    
    open func close() {
        closeAlert(0)
    }
    
   
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: tBakcgroundTansperancy)
        window.backgroundColor = UIColor.white
        
        // SubViews
        view.addSubview(window)
        window.addSubview(themeIcon)
        window.addSubview(closeButton)
        window.addSubview(cancelButton)
        window.addSubview(confirmButton)
        window.addSubview(themeTitle)
        window.insertSubview(separator, belowSubview: themeTitle)
        window.addSubview(pageControl)
        window.addSubview(contentContainer)
        
        // Autolayout
        window.snp.makeConstraints { (maker) -> Void in
            maker.center.equalTo(self.view.snp.center)
            maker.width.equalTo(MalaLayout_FilterWindowWidth)
            maker.height.equalTo(MalaLayout_FilterWindowHeight)
        }
        themeIcon.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(self.window.snp.centerX)
            maker.top.equalTo(self.window.snp.top).offset(-20)
            maker.width.equalTo(64)
            maker.height.equalTo(64)
        }
        closeButton.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.window.snp.top).offset(7)
            maker.left.equalTo(self.window.snp.left).offset(5)
        }
        cancelButton.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.window.snp.top).offset(7)
            maker.left.equalTo(self.window.snp.left).offset(5)
        }
        confirmButton.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.window.snp.top).offset(7)
            maker.right.equalTo(self.window.snp.right).offset(-5)
        }
        themeTitle.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.themeIcon.snp.bottom).offset(16)
            maker.centerX.equalTo(self.themeIcon.snp.centerX)
            maker.height.equalTo(15)
        }
        separator.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(self.themeTitle.snp.centerY)
            maker.left.equalTo(self.window.snp.left).offset(26)
            maker.right.equalTo(self.window.snp.right).offset(-26)
            maker.height.equalTo(MalaScreenOnePixel)
        }
        pageControl.snp.makeConstraints { (maker) -> Void in
            maker.width.equalTo(36)
            maker.height.equalTo(6)
            maker.bottom.equalTo(self.window.snp.bottom).offset(-10)
            maker.centerX.equalTo(self.window.snp.centerX)
        }
        contentContainer.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.themeTitle.snp.bottom).offset(12)
            maker.left.equalTo(self.window.snp.left).offset(26)
            maker.right.equalTo(self.window.snp.right).offset(-26)
            maker.bottom.equalTo(self.pageControl.snp.top).offset(-10)
        }
    }
    
    private func updateUserInterface() {
        // SubViews
        contentContainer.addSubview(self.contentView!)
        
        // Autolayout
        contentView!.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.contentContainer.snp.top)
            maker.left.equalTo(self.contentContainer.snp.left)
            maker.right.equalTo(self.contentContainer.snp.right)
            maker.bottom.equalTo(self.contentContainer.snp.bottom)
        }
    }
    
    private func animateAlert() {
        view.alpha = 0;
        let originTransform = self.window.transform
        self.window.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.0);
        
        UIView.animate(withDuration: 0.35) { () -> Void in
            self.view.alpha = 1.0
            self.window.transform = originTransform
        }
    }
    
    private func closeAlert(_ buttonIndex: Int) {
        self.view.removeFromSuperview()
        // 释放自身强引用
        self.strongSelf = nil
    }
    
    
    // MARK: - Event Response
    @objc private func pressed(_ sender: UIButton!) {
        self.closeAlert(sender.tag)
    }
    
    @objc private func cancelButtonDidTap() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MalaNotification_PopFilterView), object: nil)
    }
    
    @objc private func confirmButtonDidTap() {
        confirmButton.isUserInteractionEnabled = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MalaNotification_ConfirmFilterView), object: nil)
    }
    
    deinit{
        println("TeacherFilterPopupWindow - Deinit")
    }
}
