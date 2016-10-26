//
//  OrderFormTimeScheduleCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/13.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class OrderFormTimeScheduleCell: UITableViewCell {

    // MARK: - Property
    /// 课时
    var classPeriod: Int = 0 {
        didSet {
            periodLabel.text = String(format: "%d", classPeriod)
        }
    }
    /// 上课时间列表
    var timeSchedules: [[TimeInterval]]? {
        didSet {
            if timeSchedules != nil {
                parseTimeSchedules()
            }
        }
    }
    /// 是否隐藏时间表（默认隐藏）
    var shouldHiddenTimeSlots: Bool = true {
        didSet {
            self.timeLineView?.isHidden = shouldHiddenTimeSlots
        }
    }
    
    
    // MARK: - Components
    /// 布局容器
    private lazy var content: UIView = {
        let view = UIView(UIColor.white)
        return view
    }()
    /// 分割线
    private lazy var separatorLine: UIView = {
        let view = UIView(MalaColor_F2F2F2_0)
        return view
    }()
    /// cell标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "上课时间",
            fontSize: 15,
            textColor: MalaColor_333333_0
        )
        return label
    }()
    /// 课时
    private lazy var periodLabel: UILabel = {
        let label = UILabel(
            text: "0",
            fontSize: 13,
            textColor: MalaColor_333333_0
        )
        return label
    }()
    private lazy var periodLeftLabel: UILabel = {
        let label = UILabel(
            text: "共计",
            fontSize: 13,
            textColor: MalaColor_6C6C6C_0
        )
        return label
    }()
    private lazy var periodRightLabel: UILabel = {
        let label = UILabel(
            text: "课时",
            fontSize: 13,
            textColor: MalaColor_6C6C6C_0
        )
        return label
    }()
    /// 上课时间表控件
    private  var timeLineView: ThemeTimeLine?
    
    
    // MARK: - Contructed
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
        content.addSubview(separatorLine)
        content.addSubview(titleLabel)
        content.addSubview(periodRightLabel)
        content.addSubview(periodLabel)
        content.addSubview(periodLeftLabel)
        
        // Autolayout
        content.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView)
            maker.left.equalTo(contentView).offset(12)
            maker.right.equalTo(contentView).offset(-12)
            maker.bottom.equalTo(contentView)
        }
        separatorLine.snp.makeConstraints { (maker) in
            maker.top.equalTo(content).offset(36)
            maker.left.equalTo(content).offset(7)
            maker.right.equalTo(content).offset(-7)
            maker.height.equalTo(MalaScreenOnePixel)
        }
        titleLabel.snp.updateConstraints { (maker) -> Void in
            maker.top.equalTo(content).offset(9.5)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(17)
        }
        periodRightLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(titleLabel)
            maker.right.equalTo(content).offset(-12)
            maker.height.equalTo(13)
        }
        periodLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(titleLabel)
            maker.right.equalTo(periodRightLabel.snp.left).offset(-5)
            maker.height.equalTo(13)
        }
        periodLeftLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(titleLabel)
            maker.right.equalTo(periodLabel.snp.left).offset(-5)
            maker.height.equalTo(13)
        }
    }
    
    private func parseTimeSchedules() {
        
        // 解析时间表数据
        let result = parseTimeSlots((self.timeSchedules ?? []))
        
        // 设置UI
        self.timeLineView = ThemeTimeLine(times: result.dates, descs: result.times)
        timeLineView?.isHidden = true
        
        self.contentView.addSubview(timeLineView!)
        separatorLine.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(timeLineView!.snp.top).offset(-10.5)
        }
        timeLineView!.snp.makeConstraints { (maker) in
            maker.top.equalTo(separatorLine.snp.bottom).offset(10.5)
            maker.left.equalTo(content).offset(12)
            maker.right.equalTo(content).offset(-12)
            maker.bottom.equalTo(content).offset(-9)
            maker.height.equalTo(result.height)
        }
    }
}
