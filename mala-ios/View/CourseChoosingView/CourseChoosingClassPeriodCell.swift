//
//  CourseChoosingClassPeriodCell.swift
//  mala-ios
//
//  Created by 王新宇 on 1/22/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class CourseChoosingClassPeriodCell: MalaBaseCell {
    
    // MARK: - Components
    private lazy var legendView: PeriodStepper = {
        let legendView = PeriodStepper()
        return legendView
    }()
    
    
    // MARK: - Contructed
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public Method
    func updateSetpValue() {
        legendView.updateStepValue()
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        adjustForCourseChoosing()
        
        // SubViews
        content.removeFromSuperview()
        contentView.addSubview(legendView)
        
        // Autolayout
        headerView.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-16)
        }

        legendView.snp.makeConstraints { (maker) -> Void in
            maker.width.equalTo(97)
            maker.height.equalTo(27)
            maker.centerY.equalTo(headerView.snp.centerY)
            maker.right.equalTo(contentView.snp.right).offset(-12)
        }
    }

}


open class PeriodStepper: UIView, UITextFieldDelegate {
  
    // MARK: - Compontents
    /// 计数器
    var stepper: KWStepper!
    /// 输入框
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.text = String(format: "%d", Int(MalaClassPeriod_StepValue))
        textField.textAlignment = .center
        return textField
    }()
    /// 计数器减按钮
    private lazy  var decrementButton: UIButton = {
        let decrementButton = UIButton()
        decrementButton.setImage(UIImage(named: "minus"), for: UIControlState())
        decrementButton.setBackgroundImage(UIImage(named: "grayBackground"), for: UIControlState())
        return decrementButton
    }()
    /// 计数器加按钮
    private lazy var incrementButton: UIButton = {
        let incrementButton = UIButton()
        incrementButton.setImage(UIImage(named: "plus"), for: UIControlState())
        incrementButton.setBackgroundImage(UIImage(named: "grayBackground"), for: UIControlState())
        return incrementButton
    }()
    
    
    // MARK: - Constructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setupUserInterface()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public Method
    open func updateStepValue() {
        stepper.value = Double(MalaCurrentCourse.classPeriod)
        stepper.minimumValue = Double(MalaCurrentCourse.selectedTime.count*2)
    }
    
    
    // MARK: - Private Method
    private func configure() {
        stepper = KWStepper(decrementButton: decrementButton, incrementButton: incrementButton)
        // 设置计数器属性
        stepper.autoRepeat = true
        stepper.wraps = false
        stepper.minimumValue = MalaClassPeriod_StepValue
        stepper.maximumValue = 100
        stepper.value = MalaClassPeriod_StepValue
        stepper.incrementStepValue = MalaClassPeriod_StepValue
        stepper.decrementStepValue = MalaClassPeriod_StepValue
        // 计数器数值changed回调闭包
        stepper.valueChangedCallback = {
            self.textField.text = String(format: "%d", Int(self.stepper.value))
            NotificationCenter.default.post(name: Notification.Name(rawValue: MalaNotification_ClassPeriodDidChange), object: self.stepper.value)
        }
        
        textField.delegate = self
        textField.keyboardType = .numberPad
    }
    
    private func setupUserInterface() {
        // SubViews
        addSubview(decrementButton)
        addSubview(textField)
        addSubview(incrementButton)
        
        // Autolayout
        decrementButton.snp.makeConstraints { (maker) -> Void in
            maker.width.equalTo(31)
            maker.height.equalTo(27)
            maker.top.equalTo(self.snp.top)
            maker.left.equalTo(self.snp.left)
        }
        incrementButton.snp.makeConstraints { (maker) -> Void in
            maker.width.equalTo(31)
            maker.height.equalTo(27)
            maker.top.equalTo(decrementButton.snp.top)
            maker.right.equalTo(self.snp.right)
        }
        textField.snp.makeConstraints { (maker) -> Void in
            maker.height.equalTo(27)
            maker.top.equalTo(decrementButton.snp.top)
            maker.left.equalTo(decrementButton.snp.right)
            maker.right.equalTo(incrementButton.snp.left)
        }
    }
    
    
    // MARK: - Delegate
    open func textFieldDidEndEditing(_ textField: UITextField) {
        // 限制输入值最大为100
        var value = Int(textField.text ?? "") ?? 0
        value = value > 100 ? 100 : value
        // 限制输入值为偶数
        let num = value%Int(MalaClassPeriod_StepValue)
        value = num == 0 ? value : value-num
        // 赋值给计数器
        self.stepper.value = Double(value)
    }
}
