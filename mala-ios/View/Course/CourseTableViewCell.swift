//
//  CourseTableViewCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/6/14.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    
    // MARK: - Property
    var model: [StudentCourseModel]? {
        didSet {
            if let courseModel = model?[0] {
                dateLabel.text = getDateString(courseModel.end, format: "d")
                weekLabel.text = getWeekString(courseModel.end)
                changeUI()
            }
            setupCourseViews()
        }
    }
    var lastCourseView: SingleCourseView?
    
    
    // MARK: - Components
    /// 日期标签
    private lazy var  dateLabel: UILabel = {
        let label = UILabel(
            text: "1",
            fontSize: 24,
            textColor: UIColor(named: .HeaderTitle)
        )
        return label
    }()
    /// 星期标签
    private lazy var  weekLabel: UILabel = {
        let label = UILabel(
            text: "周一",
            fontSize: 14,
            textColor: UIColor(named: .HeaderTitle)
        )
        return label
    }()
    /// 课程布局视图
    private lazy var courseLayoutView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    
    // MARK: - Instance Method
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
        selectionStyle = .none
        
        // SubViews
        contentView.addSubview(dateLabel)
        contentView.addSubview(weekLabel)
        contentView.addSubview(courseLayoutView)
        
        // AutoLayout
        dateLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(20)
            maker.left.equalTo(contentView).offset(20)
            maker.height.equalTo(27)
        }
        weekLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(dateLabel.snp.bottom).offset(5)
            maker.left.equalTo(dateLabel)
            maker.width.equalTo(30)
            maker.height.equalTo(14)
        }
        courseLayoutView.snp.makeConstraints { (maker) in
            maker.top.equalTo(dateLabel)
            maker.left.equalTo(weekLabel.snp.right).offset(20)
            maker.right.equalTo(contentView).offset(-12)
            maker.bottom.equalTo(contentView)
        }
    }
    
    ///  根据课程状态渲染UI
    private func changeUI() {
        
        guard let course = model?[0] else { return }
        
        switch course.status {
        case .Past:
            dateLabel.textColor = UIColor(named: .HeaderTitle)
            weekLabel.textColor = UIColor(named: .HeaderTitle)
            break
            
        case .Today:
            dateLabel.textColor = UIColor(named: .ThemeDeepBlue)
            weekLabel.textColor = UIColor(named: .ThemeDeepBlue)
            break
            
        case .Future:
            dateLabel.textColor = UIColor(named: .ArticleTitle)
            weekLabel.textColor = UIColor(named: .ArticleTitle)
            break
        }
    }
    
    ///  设置课程视图
    private func setupCourseViews() {
        
        for courseModel in model ?? [] {
            let view = SingleCourseView()
            view.model = courseModel
            courseLayoutView.addSubview(view)
            
            if let lastCourseView = lastCourseView {
                view.snp.makeConstraints { (maker) in
                    maker.top.equalTo(lastCourseView.snp.bottom)
                    maker.left.equalTo(courseLayoutView)
                    maker.right.equalTo(courseLayoutView)
                    maker.height.equalTo(MalaConfig.singleCourseCellHeight())
                }
            }else {
                view.snp.makeConstraints { (maker) in
                    maker.top.equalTo(courseLayoutView)
                    maker.left.equalTo(courseLayoutView)
                    maker.right.equalTo(courseLayoutView)
                    maker.height.equalTo(MalaConfig.singleCourseCellHeight())
                }
            }
            lastCourseView = view
        }
    }
    
    
    // MARK: - Override
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lastCourseView = nil
        
        for view in courseLayoutView.subviews {
            view.removeFromSuperview()
        }
    }
}
