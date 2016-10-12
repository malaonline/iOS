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
    /// 顶部布局容器
    private lazy var topLayoutView: UIView = {
        let view = UIView()
        return view
    }()
    /// 分割线
    private lazy var separatorLine: UIView = {
        let view = UIView.separator(MalaColor_E5E5E5_0)
        return view
    }()
    /// 图标
    private lazy var iconView: UIView = {
        let view = UIView.separator(MalaColor_82B4D9_0)
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
        
        // SubViews
        contentView.addSubview(topLayoutView)
        topLayoutView.addSubview(separatorLine)
        topLayoutView.addSubview(iconView)
        topLayoutView.addSubview(titleLabel)
        
        topLayoutView.addSubview(periodRightLabel)
        topLayoutView.addSubview(periodLabel)
        topLayoutView.addSubview(periodLeftLabel)
        
        // Autolayout
        topLayoutView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentView.snp.top)
            maker.left.equalTo(self.contentView.snp.left)
            maker.right.equalTo(self.contentView.snp.right)
            maker.height.equalTo(35)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-12)
        }
        separatorLine.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(topLayoutView.snp.bottom)
            maker.left.equalTo(topLayoutView.snp.left)
            maker.right.equalTo(topLayoutView.snp.right)
            maker.height.equalTo(MalaScreenOnePixel)
        }
        iconView.snp.makeConstraints { (maker) in
            maker.left.equalTo(topLayoutView.snp.left)
            maker.centerY.equalTo(topLayoutView.snp.centerY)
            maker.height.equalTo(19)
            maker.width.equalTo(3)
        }
        titleLabel.snp.updateConstraints { (maker) -> Void in
            maker.centerY.equalTo(topLayoutView.snp.centerY)
            maker.left.equalTo(topLayoutView.snp.left).offset(12)
            maker.height.equalTo(15)
        }
        periodRightLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(topLayoutView.snp.centerY)
            maker.right.equalTo(topLayoutView.snp.right).offset(-12)
            maker.height.equalTo(13)
        }
        periodLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(topLayoutView.snp.centerY)
            maker.right.equalTo(periodRightLabel.snp.left).offset(-5)
            maker.height.equalTo(13)
        }
        periodLeftLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(topLayoutView.snp.centerY)
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
        topLayoutView.snp.updateConstraints { (maker) in
            maker.bottom.equalTo(timeLineView!.snp.top).offset(-10)
        }
        timeLineView!.snp.updateConstraints { (maker) in
            maker.top.equalTo(topLayoutView.snp.bottom).offset(10)
            maker.left.equalTo(self.contentView.snp.left).offset(12)
            maker.right.equalTo(self.contentView.snp.right).offset(-12)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-16)
            maker.height.equalTo(result.height)
        }
    }
}
