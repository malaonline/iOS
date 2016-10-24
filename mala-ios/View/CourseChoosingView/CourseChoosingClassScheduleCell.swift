//
//  CourseChoosingClassScheduleCell.swift
//  mala-ios
//
//  Created by 王新宇 on 1/22/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class CourseChoosingClassScheduleCell: MalaBaseCell {

    // MARK: - Property
    /// 课程表数据模型
    var classScheduleModel: [[ClassScheduleDayModel]] = [] {
        didSet {
            self.classSchedule.model = classScheduleModel
        }
    }
    
    
    // MARK: - Components
    private lazy var classSchedule: ThemeClassSchedule = {
        let frame = CGRect(x: 0, y: 0, width: MalaLayout_CardCellWidth, height: MalaLayout_CardCellWidth*0.65)
        let classSchedule = ThemeClassSchedule(frame: frame, collectionViewLayout: ThemeClassScheduleFlowLayout(frame: frame))
        classSchedule.bounces = false
        classSchedule.isScrollEnabled = false
        return classSchedule
    }()
    private lazy var legendView: LegendView = {
        let legendView = LegendView()
        return legendView
    }()
    
    
    // MARK: - Contructed
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
        setupLegends()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        adjustForCourseChoosing()
        
        // SubViews
        content.addSubview(classSchedule)
        content.addSubview(legendView)
        
        // Autolayout
        content.snp.updateConstraints { (maker) -> Void in
            maker.top.equalTo(headerView.snp.bottom).offset(14)
        }
        classSchedule.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(content)
            maker.left.equalTo(content)
            maker.right.equalTo(content)
            maker.height.equalTo(classSchedule.snp.width).multipliedBy(0.65)
        }
        legendView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(classSchedule.snp.bottom).offset(14)
            maker.left.equalTo(content)
            maker.height.equalTo(15)
            maker.right.equalTo(content)
            maker.bottom.equalTo(content)
        }
    }
    
    private func setupLegends() {
        legendView.addLegend(image: "legend_active", title: "可选")
        legendView.addLegend(image: "legend_disabled", title: "已售")
        legendView.addLegend(image: "legend_selected", title: "已选")
        let buttonBought = legendView.addLegend(image: "legend_bought", title: "已买")
        let ButtonDesc = legendView.addLegend(image: "desc_icon", offset: 3)
        buttonBought.addTarget(self, action: #selector(CourseChoosingClassScheduleCell.showBoughtDescription), for: .touchUpInside)
        ButtonDesc.addTarget(self, action: #selector(CourseChoosingClassScheduleCell.showBoughtDescription), for: .touchUpInside)
    }
    
    
    // MARK: - Events Response
    @objc private func showBoughtDescription() {
        CouponRulesPopupWindow(title: "已买课程", desc: MalaConfig.boughtDescriptionString()).show()
    }
}


// MARK: - LegendView
open class LegendView: UIView {
    
    // MARK: - Property
    private var currentX: CGFloat = 3
    
    
    // MARK: - Constructed
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    open func addLegend(image imageName: String, title: String? = nil, offset: CGFloat? = 12) -> UIButton {
        let button = UIButton()
        button.adjustsImageWhenHighlighted = false
        button.setImage(UIImage(named: imageName), for: UIControlState())
        if title != nil {
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 3)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: -3)
        }
        
        button.setTitle(title, for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(MalaColor_939393_0, for: UIControlState())
        
        button.sizeToFit()
        button.frame.origin.x = (currentX == 3 ? currentX : currentX+(offset ?? 12)+3)
        addSubview(button)
        currentX = button.frame.maxX
        
        return button
    }
}
