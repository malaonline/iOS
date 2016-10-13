//
//  ClassScheduleViewCell.swift
//  mala-ios
//
//  Created by 王新宇 on 3/7/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

// MARK: ClassScheduleViewCellDelegate
@objc public protocol ClassScheduleViewCellDelegate: NSObjectProtocol {
    ///  是否使用自定义颜色
    @objc optional func classScheduleViewCell(_ cell: ClassScheduleViewCell, shouldUseCustomColorsForDate date: Date) -> Bool
    ///  根据Date对象返回圆形颜色
    @objc optional func classScheduleViewCell(_ cell: ClassScheduleViewCell, circleColorForDate date: Date) -> UIColor?
    ///  根据Date对象返回文字颜色
    @objc optional func classScheduleViewCell(_ cell: ClassScheduleViewCell, textColorForDate date: Date) -> UIColor?
}


// MARK: - ClassScheduleViewCell
open class ClassScheduleViewCell: UICollectionViewCell {

    /// 圆心直径
    private let ClassScheduleViewCellCircleSize: CGFloat = 30.0
    
    // MARK: Property
    /// 当天课程数据模型列表
    open var models: [StudentCourseModel] = [] {
        didSet {
            
            // 过滤掉无数据情况
            guard models.count != 0 else {
                return
            }
            
            // 设置背景颜色
            switch models[0].status {
            case .Past:
                self.isPast = true
                
                break
            case .Today:
                 self.isToday = true
                
                break
            case .Future:
                self.isFuture = true
                
                break
            }
            
            // 设置科目名称
            let subjectString = models[0].subject
            self.subjectLabel.text = subjectString
            
            // 设置多节课指示器
            if models.count > 1 {
                
                // 若当天课程大于一节，隐藏科目文字信息，显示多课程指示器
                self.subjectLabel.isHidden = true
                self.courseIndicator.isHidden = false
                
                if self.isPast {
                    self.courseIndicator.image = UIImage(named: "course indicators_normal")
                }
                
                if self.isFuture || self.isToday {
                    self.courseIndicator.image = UIImage(named: "course indicators_selected")
                }
            }else {
                // 若当天课程为一节，显示科目文字信息
                self.courseIndicator.isHidden = true
                self.subjectLabel.isHidden = false
            }
        }
    }
    
    /// 代理
    open weak var delegate: ClassScheduleViewCellDelegate?
    /// 是否为今天标记
    open var isToday: Bool = false {
        didSet {
            if isToday {
                self.dayLabel.layer.borderColor = textTodayColor.cgColor
                self.dayLabel.layer.borderWidth = MalaScreenOnePixel
                self.dayLabel.textColor = textTodayColor
                self.dayLabel.backgroundColor = circleDefaultColor
                self.subjectLabel.text = "今天"
                self.subjectLabel.textColor = MalaColor_82B4D9_0
            }else {
            
            }
        }
    }
    /// 是否为过去标记
    open var isPast: Bool = false {
        didSet {
            if isPast {
                self.dayLabel.backgroundColor = MalaColor_DEE0E0_0
                self.dayLabel.textColor = MalaColor_FFFFFF_9
                self.subjectLabel.textColor = MalaColor_6C6C6C_0
            }else {
                
            }
        }
    }
    /// 是否为未来标记
    open var isFuture: Bool = false {
        didSet {
            if isFuture {
                self.dayLabel.backgroundColor = MalaColor_82B4D9_0
                self.dayLabel.textColor = MalaColor_FFFFFF_9
                self.subjectLabel.textColor = MalaColor_82B4D9_0
            }else {
                
            }
        }
    }
    /// cell选择标记
    override open var isSelected: Bool {
        didSet {
            setCircleColor(isToday: self.isToday, selected: isSelected)
        }
    }
    /// Date对象
    open var date: Date?
    
    /// 图形默认日期颜色
    open var circleDefaultColor: UIColor = MalaColor_FFFFFF_9
    /// 图形日期为今天时的颜色
    open var circleTodayColor: UIColor = UIColor.orange // useless
    /// cell被选中时的图形颜色
    open var circleSelectedColor: UIColor = MalaColor_82B4D9_0
    /// 文字默认颜色
    open var textDefaultColor: UIColor = MalaColor_333333_0
    /// 日期为今天时的文字颜色
    open var textTodayColor: UIColor = MalaColor_82B4D9_0
    /// cell被选中时的文字颜色
    open var textSelectedColor: UIColor = MalaColor_FFFFFF_9
    /// cell被冻结时的文字颜色
    open var textDisabledColor: UIColor = MalaColor_333333_0
    /// 文字默认字体
    open var textDefaultFont: UIFont = UIFont.systemFont(ofSize: 15)
    /// 分隔线颜色
    var separatorLineColor: UIColor = MalaColor_E5E5E5_0 {
        didSet {
            separatorLine.backgroundColor = separatorLineColor
        }
    }
    /// 日期格式化组件
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    /// 辅助性日期格式化组件
    static let accessibilityDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    // MARK: - Components
    /// 日期文字Label
    lazy var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.font = self.textDefaultFont
        dayLabel.textAlignment = .center
        return dayLabel
    }()
    /// 视图容器
    lazy var contentButton: UIButton = {
        let contentButton = UIButton()
        contentButton.titleLabel?.font = self.textDefaultFont
        contentButton.titleLabel?.textAlignment = .center
        return contentButton
    }()
    /// 多课程指示器
    lazy var courseIndicator: UIImageView = {
        let courseIndicator = UIImageView(image: UIImage(named: "course indicators_normal"))
        courseIndicator.isHidden = true
        return courseIndicator
    }()
    /// 科目label
    lazy var subjectLabel: UILabel = {
        let subjectLabel = UILabel()
        subjectLabel.text = ""
        subjectLabel.font = UIFont.systemFont(ofSize: 15)
        subjectLabel.textAlignment = .center
        return subjectLabel
    }()
    
    /// 分隔线
    private lazy var separatorLine: UIView = {
        let separatorLine = UIView()
        separatorLine.backgroundColor = MalaColor_E5E5E5_0
        return separatorLine
    }()

    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setupUserInterface()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Private Method
    ///  配置Cel
    private func configure() {
        
    }
    
    ///  设置UI
    private func setupUserInterface() {
        // Style 
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.backgroundColor = UIColor.clear
        dayLabel.layer.cornerRadius = ClassScheduleViewCellCircleSize/2
        dayLabel.layer.masksToBounds = true
        
        // SubViews
        contentView.addSubview(dayLabel)
        contentView.addSubview(separatorLine)
        contentView.addSubview(courseIndicator)
        contentView.addSubview(subjectLabel)
        
        // Autolayout
        dayLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView.snp.top).offset(15)
            maker.centerX.equalTo(contentView.snp.centerX)
            maker.height.equalTo(ClassScheduleViewCellCircleSize)
            maker.width.equalTo(ClassScheduleViewCellCircleSize)
        }
        separatorLine.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView.snp.top)
            maker.centerX.equalTo(contentView.snp.centerX)
            maker.width.equalTo(contentView.snp.width).offset(2)
            maker.height.equalTo(MalaScreenOnePixel)
        }
        subjectLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(dayLabel.snp.bottom).offset(10)
            maker.height.equalTo(15)
            maker.centerX.equalTo(contentView.snp.centerX)
        }
        courseIndicator.snp.makeConstraints { (maker) -> Void in
            maker.center.equalTo(subjectLabel.snp.center)
        }
        
        setCircleColor(isToday: false, selected: false)
    }
    
    ///  设置圆形颜色
    ///
    ///  - parameter today:    是否为今天
    ///  - parameter selected: 是否选中
    private func setCircleColor(isToday today: Bool, selected: Bool) {
        
        // 时间为今天的不可设置选中样式
        if today && selected {
            return
        }
        
        var circleColor = today ? circleTodayColor : circleDefaultColor
        var labelColor = today ? textTodayColor : textDefaultColor
        
        if (self.date != nil) && (delegate?.classScheduleViewCell?(self, shouldUseCustomColorsForDate: self.date!) == true) {
            if let textColor = delegate?.classScheduleViewCell?(self, textColorForDate: self.date!) {
                labelColor = textColor
            }
            if let shapeColor = delegate?.classScheduleViewCell?(self, circleColorForDate: self.date!) {
                circleColor = shapeColor
            }
        }
        
        ///  若此Cell对应课程为[已上]，重新渲染样式
        if isPast && !today {
            self.isPast = true
            return
        }
        
        ///  若此Cell对应课程为[未上]，重新渲染样式
        if isFuture && !today {
            self.isFuture = true
            return
        }
        
        if selected {
            circleColor = circleSelectedColor
            labelColor = textSelectedColor
        }
        
        if today {
            self.isToday = today
            circleColor = circleDefaultColor
            labelColor = textTodayColor
        }
        
        self.dayLabel.backgroundColor = circleColor
        self.dayLabel.textColor = labelColor
    }
    
    
    // MARK: - Class Method
    class func formatDate(_ date: Date, withCalendar calendar: Calendar) -> String {
        let dateFormatter = self.dateFormatter
        return ClassScheduleViewCell.stringFromDate(date, withDateFormatter: dateFormatter, withCalendar: calendar)
    }
    
    class func formatAccessibilityDate(_ date: Date, withCalendar calendar: Calendar) -> String {
        let dateFormatter = self.accessibilityDateFormatter
        return ClassScheduleViewCell.stringFromDate(date, withDateFormatter: dateFormatter, withCalendar: calendar)
    }
    
    
    class func stringFromDate(_ date: Date, withDateFormatter dateFormatter: DateFormatter, withCalendar calendar: Calendar) -> String {
        
        if !(dateFormatter.calendar == calendar) {
            dateFormatter.calendar = calendar
        }
        return dateFormatter.string(from: date)
    }
    
    
    // MARK: - Public Method
    ///  设置日期
    ///
    ///  - parameter date:      日期对象
    ///  - parameter calendar:  日历对象
    open func setDate(_ date: Date?, calendar: Calendar?) {
        var day = ""
        var accessibilityDay = ""
        
        if date != nil && calendar != nil {
            self.date = date
            day = ClassScheduleViewCell.formatDate(date!, withCalendar: calendar!)
            accessibilityDay = ClassScheduleViewCell.formatAccessibilityDate(date!, withCalendar: calendar!)
        }
        
        dayLabel.text = day
        dayLabel.accessibilityLabel = accessibilityDay
        
        ///  若未显示日期文字，则隐藏分割线
        separatorLine.isHidden = (dayLabel.text == "")
    }
    
    ///  刷新颜色
    open func refreshCellColors() {
        setCircleColor(isToday: self.isToday, selected: self.isSelected)
    }
        
    ///  Cell重用准备
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        date = nil
        models = []
        
        isToday = false
        isFuture = false
        isPast = false
        
        subjectLabel.text = ""
        
        dayLabel.text = ""
        dayLabel.backgroundColor = circleDefaultColor
        dayLabel.textColor = textDefaultColor
        dayLabel.layer.borderColor = UIColor.clear.cgColor
        dayLabel.layer.borderWidth = 0
        
        courseIndicator.isHidden = true
    }
}
