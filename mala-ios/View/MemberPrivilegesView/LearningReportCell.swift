//
//  LearningReportCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/17.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class LearningReportCell: UITableViewCell {
    
    // MARK: - Property
    /// 总练习数
    var totalNum: CGFloat = 1 {
        didSet {
            answerNumberLabel.text = String(format: "%d", Int(totalNum))
        }
    }
    /// 练习正确数
    var rightNum: CGFloat = 0 {
        didSet {
            
            // 若总练习数为零
            if totalNum == 0 {
                correctRateLabel.text = "0%"
            }else {
                correctRateLabel.text = String(format: "%.2f%%", CGFloat(rightNum/totalNum))
            }
            
        }
    }
    /// 学习报告状态
    var reportStatus: MalaLearningReportStatus = .LoggingIn {
        didSet {
            DispatchQueue.main.async(execute: { [weak self] () -> Void in
                self?.changeDisplayMode()
            })
        }
    }
    
    // MARK: - Components
    /// 父布局容器（白色卡片）
    private lazy var content: UIView = {
        let view = UIView()
        return view
    }()
    /// 按钮
    private lazy var button: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = MalaColor_8DC1DE_0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("查看我的学习报告", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    /// 学科标签
    private lazy var subjectLabel: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named:"subject_background"), for: UIControlState())
        button.setTitle("数学", for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: -2)
        button.isUserInteractionEnabled = false
        return button
    }()
    /// 标题标签
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "学习报告",
            fontSize: 15,
            textColor: MalaColor_333333_0
        )
        return label
    }()
    /// 中央垂直分割线
    private lazy var separator: UIView = {
        let view = UIView.separator(MalaColor_E5E5E5_0)
        return view
    }()
    /// 答题数标签
    private lazy var answerNumberLabel: UILabel = {
        let label = UILabel(
            text: "0",
            fontSize: 35,
            textColor: MalaColor_333333_0
        )
        label.textAlignment = .center
        return label
    }()
    /// 正确率标签
    private lazy var correctRateLabel: UILabel = {
        let label = UILabel(
            text: "0％",
            fontSize: 35,
            textColor: MalaColor_333333_0
        )
        label.textAlignment = .center
        return label
    }()
    /// 答题数图例
    private lazy var answerNumberLegend: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "answerNumber"), for: UIControlState())
        button.setTitle("答题数", for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(MalaColor_636363_0, for: UIControlState())
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)
        return button
    }()
    /// 正确率图例
    private lazy var correctRateLegend: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "correctRate"), for: UIControlState())
        button.setTitle("正确率", for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(MalaColor_636363_0, for: UIControlState())
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)
        return button
    }()
    /// 遮罩层（无数学学习报告样式）
    private lazy var layerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    /// 遮罩层图片
    private lazy var layerImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "noReport"))
        return imageView
    }()
    /// 遮罩层说明标签
    private lazy var layerLabel: UILabel = {
        let label = UILabel(
            text: "登录可查看专属学习报告哦",
            fontSize: 12,
            textColor: MalaColor_4DA3D9_0
        )
        return label
    }()
    /// loading指示器
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .white)
        view.startAnimating()
        view.hidesWhenStopped = true
        return view
    }()
    
    
    // MARK: - Instance Method
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
        changeDisplayMode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        contentView.backgroundColor = MalaColor_EDEDED_0
        content.backgroundColor = UIColor.white
        
        // SubViews
        contentView.addSubview(content)
        content.addSubview(button)
        content.addSubview(titleLabel)
        content.addSubview(separator)
        content.addSubview(subjectLabel)
        content.addSubview(answerNumberLabel)
        content.addSubview(correctRateLabel)
        content.addSubview(answerNumberLegend)
        content.addSubview(correctRateLegend)
        
        content.addSubview(layerView)
        layerView.addSubview(layerImage)
        layerView.addSubview(layerLabel)
        button.addSubview(loadingView)
        
        // Autolayout
        content.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp.top).offset(8)
            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
            make.height.equalTo(212)
            make.bottom.equalTo(self.contentView.snp.bottom)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(content.snp.top).offset(16)
            make.left.equalTo(content.snp.left).offset(12)
            make.height.equalTo(15)
        }
        subjectLabel.snp.makeConstraints { (make) in
            make.top.equalTo(content.snp.top).offset(-4)
            make.right.equalTo(content.snp.right).offset(-12)
            make.width.equalTo(40.5)
            make.height.equalTo(34)
        }
        separator.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalTo(content.snp.centerX)
            make.width.equalTo(MalaScreenOnePixel)
            make.bottom.equalTo(button.snp.top).offset(-20)
        }
        answerNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(button.snp.left)
            make.right.equalTo(separator.snp.left)
            make.bottom.equalTo(separator.snp.bottom)
            make.height.equalTo(35)
        }
        correctRateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(separator.snp.right)
            make.right.equalTo(button.snp.right)
            make.bottom.equalTo(separator.snp.bottom)
            make.height.equalTo(35)
        }
        answerNumberLegend.snp.makeConstraints { (make) in
            make.centerX.equalTo(answerNumberLabel.snp.centerX)
            make.top.equalTo(separator.snp.top).offset(8)
        }
        correctRateLegend.snp.makeConstraints { (make) in
            make.centerX.equalTo(correctRateLabel.snp.centerX)
            make.top.equalTo(separator.snp.top).offset(8)
        }
        button.snp.makeConstraints { (make) in
            make.height.equalTo(37)
            make.left.equalTo(content.snp.left).offset(12)
            make.right.equalTo(content.snp.right).offset(-12)
            make.bottom.equalTo(content.snp.bottom).offset(-20)
        }
        
        layerView.snp.makeConstraints { (make) in
            make.left.equalTo(content)
            make.right.equalTo(content)
            make.top.equalTo(content)
            make.bottom.equalTo(button.snp.top)
        }
        layerLabel.snp.makeConstraints { (make) in
            make.height.equalTo(12)
            make.centerX.equalTo(layerView.snp.centerX)
            make.bottom.equalTo(layerView.snp.bottom).offset(-15)
        }
        layerImage.snp.makeConstraints { (make) in
            make.width.equalTo(92)
            make.height.equalTo(95)
            make.centerX.equalTo(layerView.snp.centerX)
            make.bottom.equalTo(layerLabel.snp.top).offset(-15)
        }
        loadingView.snp.makeConstraints { (make) in
            make.centerX.equalTo(button.snp.centerX).offset(-16*3.5)
            make.centerY.equalTo(button.snp.centerY)
        }
    }
    
    /// 根据当前学习报告状态状态，渲染对应UI样式
    private func changeDisplayMode() {
        
        println("渲染对应UI样式:")
        
        // 解除绑定事件
        button.removeTarget(self, action: #selector(LearningReportCell.login), for: .touchUpInside)
        button.removeTarget(self, action: #selector(LearningReportCell.showReportDemo), for: .touchUpInside)
        button.removeTarget(self, action: #selector(LearningReportCell.showMyReport), for: .touchUpInside)
        button.removeTarget(self, action: #selector(LearningReportCell.reloadStatus), for: .touchUpInside)
        
        /// 渲染UI样式
        switch  self.reportStatus {
        case .Error:
            
            // 数据获取错误
            titleLabel.isHidden = true
            subjectLabel.isHidden = true
            layerView.isHidden = false
            loadingView.isHidden = false
            loadingView.stopAnimating()
            
            layerLabel.text = "学习报告数据获取失败"
            button.setTitle("重新获取", for: UIControlState())
            button.addTarget(self, action: #selector(LearningReportCell.reloadStatus), for: .touchUpInside)
            break
           
        case .LoggingIn:
            
            // 登录中
            titleLabel.isHidden = true
            subjectLabel.isHidden = true
            layerView.isHidden = false
            loadingView.isHidden = false
            loadingView.startAnimating()
            
            layerLabel.text = "正在获取学习报告数据..."
            button.setTitle("获取状态中", for: UIControlState())
            break
            
        case .UnLogged:
            
            // 未登录
            titleLabel.isHidden = true
            subjectLabel.isHidden = true
            layerView.isHidden = false
            loadingView.stopAnimating()
            
            layerLabel.text = "登录可查看专属学习报告哦"
            button.setTitle("登录", for: UIControlState())
            button.addTarget(self, action: #selector(LearningReportCell.login), for: .touchUpInside)
            break
            
        case .UnSigned:
            
            // 未报名
            titleLabel.isHidden = true
            subjectLabel.isHidden = true
            layerView.isHidden = false
            loadingView.stopAnimating()
            
            layerLabel.text = "学习报告目前只支持数学科目"
            button.setTitle("查看学习报告样本", for: UIControlState())
            button.addTarget(self, action: #selector(LearningReportCell.showReportDemo), for: .touchUpInside)
            break
            
        case .UnSignedMath:
            
            // 未报名数学
            titleLabel.isHidden = true
            subjectLabel.isHidden = true
            layerView.isHidden = false
            loadingView.stopAnimating()
            
            layerLabel.text = "学习报告目前只支持数学科目"
            button.setTitle("查看学习报告样本", for: UIControlState())
            button.addTarget(self, action: #selector(LearningReportCell.showReportDemo), for: .touchUpInside)
            break
            
        case .MathSigned:
            
            // 报名数学
            titleLabel.isHidden = false
            subjectLabel.isHidden = false
            layerView.isHidden = true
            loadingView.stopAnimating()
            
            button.setTitle("查看我的学习报告 ", for: UIControlState())
            button.addTarget(self, action: #selector(LearningReportCell.showMyReport), for: .touchUpInside)
            break
        }
    }
    
    
    // MARK: - Event Response
    /// 登录
    @objc private func login() {
        println("登录")
        NotificationCenter.default.post(name: Notification.Name(rawValue: MalaNotification_ShowLearningReport), object: -1)
    }
    /// 显示学习报告样本
    @objc private func showReportDemo() {
        println("样本")
        NotificationCenter.default.post(name: Notification.Name(rawValue: MalaNotification_ShowLearningReport), object: 0)
    }
    /// 显示我的学习报告
    @objc private func showMyReport() {
        println("报告")
        NotificationCenter.default.post(name: Notification.Name(rawValue: MalaNotification_ShowLearningReport), object: 1)
    }
    /// 重新获取学习报告
    @objc private func reloadStatus() {
        println("重新获取")
        NotificationCenter.default.post(name: Notification.Name(rawValue: MalaNotification_ReloadLearningReport), object: nil)
    }
}
