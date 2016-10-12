//
//  ThemeClassSchedule.swift
//  ThemeClassSchedule
//
//  Created by 王新宇 on 1/25/16.
//  Copyright © 2016 Elors. All rights reserved.
//

import UIKit

private let ThemeClassScheduleCellReuseId = "ThemeClassScheduleCellReuseId"
private let ThemeClassScheduleSectionTitles = ["时间", "周一", "周二", "周三", "周四", "周五", "周六", "周日"]


class ThemeClassSchedule: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Property
    var model: [[ClassScheduleDayModel]]? {
        didSet {
            reloadData()
        }
    }
    
    
    // MARK: - Instance Method
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func configure() {
        delegate = self
        dataSource = self
        backgroundColor = MalaColor_88BCDE_0
        self.layer.borderColor = MalaColor_88BCDE_0.cgColor
        self.layer.borderWidth = 1
        
        register(ThemeClassScheduleCell.self, forCellWithReuseIdentifier: ThemeClassScheduleCellReuseId)
    }
    
    
    // MARK: - DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThemeClassScheduleCellReuseId, for: indexPath) as! ThemeClassScheduleCell
        
        // 重置Cell样式
        cell.reset()
        
        // 设置Cell列头标题
        if (indexPath as NSIndexPath).section == 0 {
            cell.title = ThemeClassScheduleSectionTitles[(indexPath as NSIndexPath).row]
            cell.hiddenTitle = false
            cell.button.isHighlighted = true
        }
        
        // 设置Cell行头标题
        if (indexPath as NSIndexPath).row == 0 && (indexPath as NSIndexPath).section > 0 && (model ?? []) != [] {
            // 行头数据源
            let rowTitleModel = model?[0][(indexPath as NSIndexPath).section-1]
            cell.start = rowTitleModel?.start
            cell.end = rowTitleModel?.end
            cell.hiddenTime = false
            cell.setNormal()
        }
        
        // 根据数据源设置显示样式
        if (indexPath as NSIndexPath).section > 0 && (indexPath as NSIndexPath).row > 0 && (model ?? []) != [] {
            let itemModel = model?[(indexPath as NSIndexPath).row-1][(indexPath as NSIndexPath).section-1]
            
            // 若不可选择 - disable
            cell.button.isEnabled = itemModel?.available ?? false
            
            // 若为预留 - reserved
            cell.reserved = (itemModel?.available == true && itemModel?.reserved == true)
            
            // 若已选择的 - selected
            if itemModel?.isSelected != nil {
                cell.button.isSelected = itemModel!.isSelected
            }
        }
        return cell
    }
    
    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 获取Cell对象
        let cell = collectionView.cellForItem(at: indexPath) as! ThemeClassScheduleCell
        cell.button.isSelected = !cell.button.isSelected
        
        
        // 获取数据模型
        if self.model != nil && (indexPath as NSIndexPath).row >= 1 && (indexPath as NSIndexPath).section >= 1 {
            let model = self.model![(indexPath as NSIndexPath).row-1][(indexPath as NSIndexPath).section-1]
            println("点击model: \(model)")
            let weekID = ((indexPath as NSIndexPath).row == 7 ? 0 : (indexPath as NSIndexPath).row)
            model.weekID = weekID
            NotificationCenter.default.post(name: Notification.Name(rawValue: MalaNotification_ClassScheduleDidTap), object: model)
            model.isSelected = cell.button.isSelected
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        // 时间表数据未获取到时，无法点选
        guard let timeSlots = self.model, timeSlots.count != 0 && timeSlots[0].count != 0 else{
            return false
        }
        
        // 不可点击表头、行头
        if (indexPath as NSIndexPath).section > 0 && (indexPath as NSIndexPath).row > 0 {
            if let itemModel = model?[(indexPath as NSIndexPath).row-1][(indexPath as NSIndexPath).section-1] {
                return itemModel.available
            }else {
                return false
            }
        }
        return false
    }
}


class ThemeClassScheduleCell: UICollectionViewCell {
    
    // MARK: - Property
    /// 是否隐藏标题
    var hiddenTitle: Bool = true {
        didSet {
            titleLabel.isHidden = hiddenTitle
        }
    }
    /// 是否隐藏每个时间段的开始时间、结束时间
    var hiddenTime: Bool = true {
        didSet {
            startLabel.isHidden = hiddenTime
            endLabel.isHidden = hiddenTime
        }
    }
    /// 标题文字
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    /// 开始时间文字
    var start: String? {
        didSet {
           startLabel.text = start
        }
    }
    /// 结束时间文字
    var end: String? {
        didSet {
            endLabel.text = end
        }
    }
    /// 课程预留状态标识
    var reserved: Bool = false {
        didSet {
            if reserved {
                button.setBackgroundImage(UIImage(named: "timeSlot_bought"), for: UIControlState())
            }else {
                button.setBackgroundImage(UIImage.withColor(UIColor.white), for: UIControlState())
            }
        }
    }
    
    
    // MARK: - Compontents
    /// 多状态样式按钮，不进行用户交互
    lazy var button: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.withColor(UIColor.white), for: UIControlState())
        button.setBackgroundImage(UIImage.withColor(MalaColor_EDEDED_0), for: .disabled)
        button.setBackgroundImage(UIImage.withColor(MalaColor_ABD0E8_0), for: .selected)
        button.setBackgroundImage(UIImage.withColor(MalaColor_88BCDE_0), for: .highlighted)
        button.isUserInteractionEnabled = false
        return button
    }()
    /// 标题label
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = UIColor.white
        titleLabel.isHidden = true
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    /// 第一个时间段label
    private lazy var startLabel: UILabel = {
        let startLabel = UILabel()
        startLabel.text = "00:00"
        startLabel.font = UIFont.systemFont(ofSize: 12)
        startLabel.textColor = MalaColor_939393_0
        startLabel.backgroundColor = UIColor.clear
        startLabel.isHidden = true
        startLabel.textAlignment = .center
        return startLabel
    }()
    /// 第二个时间段label
    private lazy var endLabel: UILabel = {
        let endLabel = UILabel()
        endLabel.text = "00:00"
        endLabel.font = UIFont.systemFont(ofSize: 12)
        endLabel.textColor = MalaColor_939393_0
        endLabel.backgroundColor = UIColor.clear
        endLabel.isHidden = true
        endLabel.textAlignment = .center
        return endLabel
    }()
    
    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        
        // SubViews
        contentView.addSubview(button)
        contentView.insertSubview(startLabel, aboveSubview: button)
        contentView.insertSubview(endLabel, aboveSubview: startLabel)
        contentView.insertSubview(titleLabel, aboveSubview: endLabel)
        
        // Autolayout
        button.snp.makeConstraints { (maker) -> Void in
            maker.size.equalTo(contentView.snp.size)
            maker.center.equalTo(contentView.snp.center)
        }
        startLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView.snp.top)
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.height.equalTo(contentView.snp.height).multipliedBy(0.5)
        }
        endLabel.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(contentView.snp.bottom)
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.height.equalTo(contentView.snp.height).multipliedBy(0.5)
        }
        titleLabel.snp.makeConstraints { (maker) -> Void in
            maker.width.equalTo(contentView.snp.width)
            maker.height.equalTo(12)
            maker.center.equalTo(contentView.snp.center)
        }
    }
    
    ///  重置Cell外观样式（仅保留button显示normal状态）
    func reset() {
        self.setNormal()
        self.hiddenTitle = true
        self.hiddenTime = true
        self.reserved = false
    }
    
    ///  设置button为normal状态
    func setNormal() {
        self.button.isSelected = false
        self.button.isHighlighted = false
        self.button.isEnabled = true
    }
}


class ThemeClassScheduleFlowLayout: UICollectionViewFlowLayout {
    
    private var frame = CGRect.zero
    
    // MARK: - Instance Method
    init(frame: CGRect) {
        super.init()
        self.frame = frame
        
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Private Method
    private func configure() {
        let deviceName = UIDevice.current.modelName
        
        switch deviceName {
        case "iPhone 5", "iPhone 5s":
            
            scrollDirection = .vertical
            let itemWidth: CGFloat = frame.width / 8 - 1
            let itemHeight: CGFloat = (frame.height-MalaScreenOnePixel) / 6 - 1
            itemSize = CGSize(width: itemWidth, height: itemHeight)
            sectionInset = UIEdgeInsets(top: MalaScreenOnePixel, left: MalaScreenOnePixel, bottom: MalaScreenOnePixel, right: MalaScreenOnePixel)
            minimumInteritemSpacing = 1
            minimumLineSpacing = 1
            
            break
        case "iPhone 6", "iPhone 6s":
            
            scrollDirection = .vertical
            let itemWidth: CGFloat = frame.width / 8 - 1
            let itemHeight: CGFloat = frame.height / 6 - 1
            itemSize = CGSize(width: itemWidth, height: itemHeight)
            sectionInset = UIEdgeInsets(top: MalaScreenOnePixel, left: 0, bottom: MalaScreenOnePixel, right: 0)
            minimumInteritemSpacing = 1
            minimumLineSpacing = 1
            
            break
        case "iPhone 6 Plus", "iPhone 6s Plus":
            
            scrollDirection = .vertical
            let itemWidth: CGFloat = frame.width / 8 - MalaScreenOnePixel*2
            let itemHeight: CGFloat = (frame.height+MalaScreenOnePixel) / 6 - MalaScreenOnePixel*2
            itemSize = CGSize(width: itemWidth, height: itemHeight)
            sectionInset = UIEdgeInsets(top: MalaScreenOnePixel, left: MalaScreenOnePixel, bottom: MalaScreenOnePixel, right: MalaScreenOnePixel)
            minimumInteritemSpacing = MalaScreenOnePixel*2
            minimumLineSpacing = MalaScreenOnePixel*2
            
            break
        default:
            
            scrollDirection = .vertical
            let itemWidth: CGFloat = frame.width / 8 - 1
            let itemHeight: CGFloat = frame.height / 6 - 1
            itemSize = CGSize(width: itemWidth, height: itemHeight)
            sectionInset = UIEdgeInsets(top: MalaScreenOnePixel, left: 0, bottom: MalaScreenOnePixel, right: 0)
            minimumInteritemSpacing = 1
            minimumLineSpacing = 1
            
            break
        }
    }
}
