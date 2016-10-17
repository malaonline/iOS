//
//  CommentViewCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/6/7.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class CommentViewCell: UITableViewCell {

    // MARK: - Property
    /// 单个课程模型
    var model: StudentCourseModel? {
        didSet {
            // 设置单个课程模型
            teacherLabel.text = model?.teacher?.name
            subjectLabel.text = (model?.grade ?? "") + " " + (model?.subject ?? "")
            setDateString()
            schoolLabel.text = model?.school
            
            // 老师头像
            avatarView.ma_setImage(model?.teacher?.avatar, placeholderImage: UIImage(named: "profileAvatar_placeholder"))
            // 课程评价状态
            if model?.comment != nil {
                // 已评价
                setStyleCommented()
                
            }else if model?.is_expired == true {
                // 过期
                setStyleExpired()
                
            }else {
                // 未评价
                setStyleNoComments()
            }
        }
    }
    
    // MARK: - Components
    /// 主要布局容器
    private lazy var content: UIView = {
        let view = UIView(UIColor.white)
        view.layer.shadowOffset = CGSize(width: 0, height: MalaScreenOnePixel)
        view.layer.shadowColor = MalaColor_D7D7D7_0.cgColor
        view.layer.shadowOpacity = 1
        return view
    }()
    /// 课程信息布局容器
    private lazy var mainLayoutView: UIView = {
        let view = UIView()
        return view
    }()
    /// 课程评价状态标示
    private lazy var statusIcon: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "uncomment"), for: UIControlState())
        button.setBackgroundImage(UIImage(named: "commented"), for: .highlighted)
        button.setBackgroundImage(UIImage(named: "comment_expired"), for: .disabled)
        button.setTitle("待 评", for: UIControlState())
        button.setTitle("已 评", for: .highlighted)
        button.setTitle("过 期", for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.isUserInteractionEnabled = false
        return button
    }()
    /// 老师头像
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "profileAvatar_placeholder"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 55/2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    /// 老师姓名图标
    private lazy var teacherIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "comment_teacher_normal"))
        return imageView
    }()
    /// 老师姓名
    private lazy var teacherLabel: UILabel = {
        let label = UILabel(
            text: "教师姓名",
            fontSize: 13,
            textColor: MalaColor_8FBCDD_0
        )
        return label
    }()
    /// 学科信息图标
    private lazy var subjectIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "comment_subject"))
        return imageView
    }()
    /// 学科信息
    private lazy var subjectLabel: UILabel = {
        let label = UILabel(
            text: "年级-学科",
            fontSize: 13,
            textColor: MalaColor_6C6C6C_0
        )
        return label
    }()
    /// 上课时间图标
    private lazy var timeSlotIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "comment_time"))
        return imageView
    }()
    /// 上课日期信息
    private lazy var timeSlotLabel: UILabel = {
        let label = UILabel(
            text: "上课时间",
            fontSize: 13,
            textColor: MalaColor_6C6C6C_0
        )
        return label
    }()
    /// 上课时间信息
    private lazy var timeLabel: UILabel = {
        let label = UILabel(
            text: "",
            fontSize: 13,
            textColor: MalaColor_939393_0
        )
        return label
    }()
    /// 上课地点图标
    private lazy var schoolIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "comment_location"))
        return imageView
    }()
    /// 上课地点
    private lazy var schoolLabel: UILabel = {
        let label = UILabel(
            text: "上课地点",
            fontSize: 13,
            textColor: MalaColor_6C6C6C_0
        )
        return label
    }()
    /// 中部分割线
    private lazy var separatorLine: UIView = {
        let view = UIView(MalaColor_DADADA_0)
        return view
    }()
    /// 评分面板
    private lazy var floatRating: FloatRatingView = {
        let floatRating = FloatRatingView()
        floatRating.backgroundColor = UIColor.white
        floatRating.editable = false
        return floatRating
    }()
    /// 底部布局容器
    private lazy var bottomLayoutView: UIView = {
        let view = UIView()
        return view
    }()
    /// 已过期文字标签
    private lazy var expiredLabel: UILabel = {
        let label = UILabel(
            text: "评价已过期",
            fontSize: 12,
            textColor: MalaColor_939393_0
        )
        return label
    }()
    /// 评论按钮
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = MalaColor_E26254_0.cgColor
        button.layer.borderWidth = MalaScreenOnePixel
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        
        button.setBackgroundImage(UIImage.withColor(UIColor.white), for: UIControlState())
        button.setBackgroundImage(UIImage.withColor(MalaColor_FFF0EE_0), for: .highlighted)
        button.setTitle("去评价", for: UIControlState())
        button.setTitleColor(MalaColor_E26254_0, for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(CommentViewCell.toComment), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    /// 查看评论按钮
    private lazy var showCommentButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = MalaColor_82B4D9_0.cgColor
        button.layer.borderWidth = MalaScreenOnePixel
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        
        button.setBackgroundImage(UIImage.withColor(UIColor.white), for: UIControlState())
        button.setBackgroundImage(UIImage.withColor(MalaColor_E6F1FC_0), for: .highlighted)
        button.setTitle("查看评价", for: UIControlState())
        button.setTitleColor(MalaColor_82B4D9_0, for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(CommentViewCell.showComment), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    
    // MARK: - Constructed
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        contentView.backgroundColor = MalaColor_EDEDED_0
        
        // SubViews
        contentView.addSubview(content)
        content.addSubview(mainLayoutView)
        content.addSubview(separatorLine)
        content.addSubview(bottomLayoutView)
        content.addSubview(floatRating)
        
        mainLayoutView.addSubview(avatarView)
        mainLayoutView.addSubview(statusIcon)
        
        mainLayoutView.addSubview(teacherIcon)
        mainLayoutView.addSubview(teacherLabel)
        mainLayoutView.addSubview(subjectIcon)
        mainLayoutView.addSubview(subjectLabel)
        mainLayoutView.addSubview(timeSlotIcon)
        mainLayoutView.addSubview(timeSlotLabel)
        mainLayoutView.addSubview(timeLabel)
        mainLayoutView.addSubview(schoolIcon)
        mainLayoutView.addSubview(schoolLabel)
        
        bottomLayoutView.addSubview(expiredLabel)
        bottomLayoutView.addSubview(commentButton)
        bottomLayoutView.addSubview(showCommentButton)
        
        // Autolayout
        content.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.contentView.snp.top).offset(6)
            maker.left.equalTo(self.contentView.snp.left).offset(12)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-6)
            maker.right.equalTo(self.contentView.snp.right).offset(-12)
        }
        mainLayoutView.snp.makeConstraints { (maker) in
            maker.top.equalTo(content.snp.top)
            maker.left.equalTo(content.snp.left)
            maker.height.equalTo(252)
            maker.right.equalTo(content.snp.right)
            maker.bottom.equalTo(separatorLine.snp.top)
        }
        separatorLine.snp.makeConstraints { (maker) in
            maker.top.equalTo(mainLayoutView.snp.bottom).offset(14)
            maker.height.equalTo(MalaScreenOnePixel)
            maker.left.equalTo(content).offset(5)
            maker.right.equalTo(content).offset(-5)
        }
        floatRating.snp.makeConstraints { (maker) in
            maker.center.equalTo(separatorLine.snp.center)
            maker.height.equalTo(20)
            maker.width.equalTo(80)
        }
        bottomLayoutView.snp.makeConstraints { (maker) in
            maker.top.equalTo(separatorLine.snp.bottom)
            maker.bottom.equalTo(content.snp.bottom)
            maker.left.equalTo(content.snp.left)
            maker.right.equalTo(content.snp.right)
            maker.height.equalTo(50)
        }
        statusIcon.snp.makeConstraints { (maker) in
            maker.right.equalTo(mainLayoutView.snp.right).offset(-30)
            maker.top.equalTo(mainLayoutView.snp.top).offset(-6)
        }
        avatarView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(statusIcon.snp.centerX)
            maker.top.equalTo(statusIcon.snp.bottom).offset(10)
            maker.height.equalTo(55)
            maker.width.equalTo(55)
        }
        teacherIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(mainLayoutView.snp.top).offset(14)
            maker.left.equalTo(mainLayoutView.snp.left).offset(12)
            maker.height.equalTo(14)
            maker.width.equalTo(14)
        }
        teacherLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherIcon.snp.top)
            maker.left.equalTo(teacherIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        subjectIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherIcon.snp.bottom).offset(14)
            maker.left.equalTo(mainLayoutView.snp.left).offset(12)
            maker.height.equalTo(14)
            maker.width.equalTo(14)
        }
        subjectLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(subjectIcon.snp.top)
            maker.left.equalTo(subjectIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        timeSlotIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(subjectIcon.snp.bottom).offset(14)
            maker.left.equalTo(mainLayoutView.snp.left).offset(12)
            maker.height.equalTo(14)
            maker.width.equalTo(14)
        }
        timeSlotLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(timeSlotIcon.snp.top)
            maker.left.equalTo(timeSlotIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        timeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(timeSlotLabel)
            maker.left.equalTo(timeSlotLabel.snp.right).offset(5)
            maker.height.equalTo(13)
        }
        schoolIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(timeSlotIcon.snp.bottom).offset(14)
            maker.left.equalTo(mainLayoutView.snp.left).offset(12)
            maker.height.equalTo(15)
            maker.width.equalTo(14)
        }
        schoolLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(schoolIcon.snp.top)
            maker.left.equalTo(schoolIcon.snp.right).offset(10)
            maker.height.equalTo(13)
            maker.bottom.equalTo(mainLayoutView.snp.bottom).offset(-14)
        }
        expiredLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(12)
            maker.center.equalTo(bottomLayoutView.snp.center)
        }
        commentButton.snp.makeConstraints { (maker) in
            maker.center.equalTo(bottomLayoutView.snp.center)
            maker.width.equalTo(96)
            maker.height.equalTo(24)
        }
        showCommentButton.snp.makeConstraints { (maker) in
            maker.center.equalTo(bottomLayoutView.snp.center)
            maker.width.equalTo(96)
            maker.height.equalTo(24)
        }
    }
    
    ///  设置日期样式
    private func setDateString() {
        
        guard let start = model?.start else {
            return
        }
        
        let dateString = getDateString(start, format: "yyyy-MM-dd")
        let startString = getDateString(start, format: "HH:mm")
        let endString = getDateString(date: NSDate(timeIntervalSince1970: start).addingHours(2) as NSDate?, format: "HH:mm")
        
        timeSlotLabel.text = String(format: "%@", dateString)
        timeLabel.text = String(format: "%@-%@", startString, endString)
    }
    
    ///  设置过期样式
    private func setStyleExpired() {
        showCommentButton.isHidden = true
        commentButton.isHidden = true
        statusIcon.isHighlighted = false
        statusIcon.isEnabled = false
        expiredLabel.isHidden = false
        floatRating.isHidden = true
    }
    
    ///  设置已评论样式
    private func setStyleCommented() {
        commentButton.isHidden = true
        showCommentButton.isHidden = false
        statusIcon.isEnabled = true
        statusIcon.isHighlighted = true
        expiredLabel.isHidden = true
        floatRating.isHidden = false
        floatRating.rating = Float((model?.comment?.score) ?? 0)
    }
    
    ///  设置待评论样式
    private func setStyleNoComments() {
        commentButton.isHidden = false
        showCommentButton.isHidden = true
        statusIcon.isHighlighted = false
        statusIcon.isEnabled = true
        expiredLabel.isHidden = true
        floatRating.isHidden = true
    }
    
    
    // MARK: - Event Response
    ///  去评价
    @objc private func toComment() {
        let commentWindow = CommentViewWindow(contentView: UIView())
        
        commentWindow.finishedAction = { [weak self] in
            self?.setStyleCommented()
        }
        
        commentWindow.model = self.model ?? StudentCourseModel()
        commentWindow.isJustShow = false
        commentWindow.show()
    }
    ///  查看评价
    @objc private func showComment() {
        let commentWindow = CommentViewWindow(contentView: UIView())
        commentWindow.model = self.model ?? StudentCourseModel()
        commentWindow.isJustShow = true
        commentWindow.show()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statusIcon.isHighlighted = false
        statusIcon.isEnabled = true
    }
}
