//
//  CourseChoosingTimeScheduleCell.swift
//  mala-ios
//
//  Created by 王新宇 on 1/22/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class CourseChoosingTimeScheduleCell: MalaBaseCell {

    // MARK: - Property
    /// 上课时间列表
    var timeSchedules: [[TimeInterval]]? {
        didSet {
            if timeSchedules != nil && isOpen {
                parseTimeSchedules()
            }
        }
    }
    /// 展开标记
    var isOpen: Bool = true {
        didSet {
            
            guard let timeLineView = timeLineView else {
                return
            }
            
            if isOpen {
                timeLineView.isHidden = false
                timeLineView.snp.updateConstraints { (maker) -> Void in
                    maker.height.equalTo(currentHeight)
                }
            }else {
                timeLineView.isHidden = true
                timeLineView.snp.updateConstraints { (maker) -> Void in
                    maker.height.equalTo(0)
                }
            }
            detailButton.isSelected = isOpen
        }
    }
    /// 当前高度
    var currentHeight: CGFloat = 0
    
    
    // MARK: - Components
    /// 上课时间表控件
    private var timeLineView: ThemeTimeLine?
    /// 展开按钮
    private lazy var detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dropArrow"), for: UIControlState())
        button.setImage(UIImage(named: "upArrow"), for: .selected)
        button.addTarget(self, action: #selector(CourseChoosingTimeScheduleCell.detailButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    
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
        adjustForCourseChoosing()
        
        // SubView
        headerView.addSubview(detailButton)
        
        // Autolayout
        content.snp.updateConstraints { (maker) -> Void in
            maker.top.equalTo(headerView.snp.bottom).offset(14)
        }
        detailButton.snp.makeConstraints { (maker) -> Void in
            maker.height.equalTo(13)
            maker.right.equalTo(headerView).offset(-12)
            maker.centerY.equalTo(headerView)
        }
    }
    
    private func parseTimeSchedules() {
        
        // 解析时间表数据
        let result = parseTimeSlots((self.timeSchedules ?? []))
        
        // 设置UI
        self.timeLineView?.removeFromSuperview()
        self.timeLineView = ThemeTimeLine(times: result.dates, descs: result.times)
        content.addSubview(timeLineView!)
        currentHeight = result.height
        timeLineView!.snp.makeConstraints { (maker) in
            maker.top.equalTo(content)
            maker.left.equalTo(content)
            maker.right.equalTo(content)
            maker.bottom.equalTo(content)
            maker.height.equalTo(currentHeight)
        }
    }
    
    
    // MARK: - Override
    @objc func detailButtonDidTap() {
        NotificationCenter.default.post(name: MalaNotification_OpenTimeScheduleCell, object: !isOpen)
    }
}
