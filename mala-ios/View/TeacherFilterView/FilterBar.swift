//
//  FilterBar.swift
//  mala-ios
//
//  Created by 王新宇 on 16/6/29.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class FilterBar: UIView {
    
    // MARK: - Property
    /// 父控制器
    weak var controller: FilterResultController?
    /// 筛选条件
    var filterCondition: ConditionObject = MalaCondition {
        didSet {
            self.gradeButton.setTitle(filterCondition.grade.name, for: UIControlState())
            self.subjectButton.setTitle(filterCondition.subject.name, for: UIControlState())
            let tags = filterCondition.tags.map({ (object: BaseObjectModel) -> String in
                return object.name ?? ""
            })
            let tagsButtonTitle = tags.joined(separator: " • ")
            self.styleButton.setTitle(tagsButtonTitle == "" ? "不限" : tagsButtonTitle, for: UIControlState())
        }
    }
    
    
    // MARK: - Components
    private lazy var gradeButton: UIButton = {
        let gradeButton = UIButton(
            title: "小学一年级",
            borderColor: MalaColor_8FBCDD_0,
            target: self,
            action: #selector(FilterBar.buttonDidTap(_:))
        )
        gradeButton.tag = 1
        return gradeButton
    }()
    private lazy var subjectButton: UIButton = {
        let subjectButton = UIButton(
            title: "科  目",
            borderColor: MalaColor_8FBCDD_0,
            target: self,
            action: #selector(FilterBar.buttonDidTap(_:))
        )
        subjectButton.tag = 2
        return subjectButton
    }()
    private lazy var styleButton: UIButton = {
        let styleButton = UIButton(
            title: "不  限",
            borderColor: MalaColor_8FBCDD_0,
            target: self,
            action: #selector(FilterBar.buttonDidTap(_:))
        )
        styleButton.titleLabel?.lineBreakMode = .byTruncatingTail
        styleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
        styleButton.tag = 3
        return styleButton
    }()
    
    
    // MARK: - Constructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
        setupNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        filterCondition = MalaCondition
        
        // SubViews
        addSubview(gradeButton)
        addSubview(subjectButton)
        addSubview(styleButton)
        
        // Autolayout
        gradeButton.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self).offset(9)
            maker.left.equalTo(self).offset(12)
            maker.width.equalTo(88)
            maker.bottom.equalTo(self).offset(-5)
        }
        subjectButton.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(gradeButton)
            maker.left.equalTo(gradeButton.snp.right).offset(7)
            maker.width.equalTo(54)
            maker.height.equalTo(gradeButton)
        }
        styleButton.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(subjectButton)
            maker.left.equalTo(subjectButton.snp.right).offset(7)
            maker.right.equalTo(self).offset(-12)
            maker.height.equalTo(subjectButton)
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            forName: MalaNotification_CommitCondition,
            object: nil,
            queue: nil) { [weak self] (notification) -> Void in
                self?.filterCondition = MalaCondition
                self?.controller?.loadTeachersWithCommonCondition()
        }
    }
    
    
    // MARK: - Event Response
    @objc private func buttonDidTap(_ sender: UIButton) {
        
        let filterView = FilterView(frame: CGRect.zero)
        filterView.isSecondaryFilter = true
        filterView.subjects = MalaCondition.grade.subjects.map({ (i: NSNumber) -> GradeModel in
            let subject = GradeModel()
            subject.id = i.intValue
            subject.name = MalaConfig.malaSubject()[i.intValue]
            return subject
        })
        
        let alertView = TeacherFilterPopupWindow(contentView: filterView)
        alertView.closeWhenTap = true
        
        switch sender.tag {
        case 1:
            filterView.scrollToPanel(1, animated: false)
            filterView.container?.setButtonStatus(showClose: false, showCancel: false, showConfirm: false)
        case 2:
            filterView.scrollToPanel(2, animated: false)
            filterView.container?.setButtonStatus(showClose: false, showCancel: false, showConfirm: false)
        case 3:
            filterView.scrollToPanel(3, animated: false)
            filterView.container?.setButtonStatus(showClose: false, showCancel: false, showConfirm: true)
        default:
            break
        }
        
        alertView.show()
    }
    
    deinit {
        println("FilterBar - Deinit")
        NotificationCenter.default.removeObserver(self, name: MalaNotification_CommitCondition, object: nil)
    }
}
