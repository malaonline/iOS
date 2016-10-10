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
            if (timeSchedules ?? []) !== (oldValue ?? []) && timeSchedules != nil && isOpen {
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
                timeLineView.snp.updateConstraints { (make) -> Void in
                    make.height.equalTo(currentHeight)
                }
            }else {
                timeLineView.isHidden = true
                timeLineView.snp.updateConstraints { (make) -> Void in
                    make.height.equalTo(0)
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
        content.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(headerView.snp.bottom).offset(14)
        }
        detailButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(13)
            make.right.equalTo(headerView.snp.right).offset(-12)
            make.centerY.equalTo(headerView.snp.centerY)
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
        timeLineView!.snp.makeConstraints { (make) in
            make.top.equalTo(content.snp.top)
            make.left.equalTo(content.snp.left)
            make.right.equalTo(content.snp.right)
            make.bottom.equalTo(content.snp.bottom)
            make.height.equalTo(currentHeight)
        }
    }
    
    
    // MARK: - Override
    @objc func detailButtonDidTap() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: MalaNotification_OpenTimeScheduleCell), object: !isOpen)
    }
}
