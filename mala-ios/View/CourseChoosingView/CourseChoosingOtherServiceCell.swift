//
//  CourseChoosingOtherServiceCell.swift
//  mala-ios
//
//  Created by 王新宇 on 1/22/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class CourseChoosingOtherServiceCell: MalaBaseCell {

    // MARK: - Property
    /// 价格
    var price: Int = 0 {
        didSet {
            self.priceView.price = price
        }
    }
    
    
    // MARK: - Components
    private lazy var tableView: CourseChoosingServiceTableView = {
        let tableView = CourseChoosingServiceTableView(frame: CGRect.zero, style: .plain)
        return tableView
    }()
    private lazy var priceView: PriceResultView = {
        let priceView = PriceResultView()
        return priceView
    }()
    
    
    // MARK: - Constructed
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
        
        // SubViews
        contentView.addSubview(tableView)
        contentView.addSubview(priceView)
        
        // Autolayout
        priceView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.tableView.snp.bottom)
            maker.left.equalTo(self.contentView.snp.left)
            maker.right.equalTo(self.contentView.snp.right)
            maker.bottom.equalTo(self.contentView.snp.bottom)
            maker.height.equalTo(MalaLayout_OtherServiceCellHeight)
        }
        
        let otherServiceCount = (MalaIsHasBeenEvaluatedThisSubject == true ? MalaOtherService.count : (MalaOtherService.count-1))
        tableView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.contentView.snp.top)
            maker.bottom.equalTo(priceView.snp.top)
            maker.left.equalTo(self.contentView.snp.left).offset(12)
            maker.right.equalTo(self.contentView.snp.right).offset(-12)
            maker.height.equalTo(otherServiceCount*Int(MalaLayout_OtherServiceCellHeight))
        }
    }
}


// MARK: - PriceResultView
class PriceResultView: UIView {
    
    // MARK: - Property
    /// 价格
    var price: Int = 0 {
        didSet{
            self.priceLabel.text = price.priceCNY
        }
    }
    private var myContext = 0
    
    // MARK: - Components
    /// 价格说明标签
    private lazy var stringLabel: UILabel = {
        let stringLabel = UILabel()
        stringLabel.textColor = MalaColor_333333_0
        stringLabel.font = UIFont.systemFont(ofSize: 14)
        stringLabel.text = "原价:"
        return stringLabel
    }()
    /// 金额标签
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.textColor = MalaColor_E36A5D_0
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.text = "￥0.00"
        return priceLabel
    }()
    
    
    // MARK: - Constructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Override
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 当选课条件改变时，更新总价
        self.price = MalaCurrentCourse.originalPrice
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        self.backgroundColor = UIColor.white
        
        // SubViews
        addSubview(stringLabel)
        addSubview(priceLabel)
        
        // Autolayout
        priceLabel.snp.makeConstraints { (maker) -> Void in
            maker.height.equalTo(14)
            maker.centerY.equalTo(self.snp.centerY)
            maker.right.equalTo(self.snp.right).offset(-12)
        }
        stringLabel.snp.makeConstraints { (maker) -> Void in
            maker.height.equalTo(14)
            maker.bottom.equalTo(self.priceLabel.snp.bottom)
            maker.right.equalTo(priceLabel.snp.left)
        }
    }
    
    private func configure() {
        MalaCurrentCourse.addObserver(self, forKeyPath: "originalPrice", options: .new, context: &myContext)
    }
    
    
    deinit {
        MalaCurrentCourse.removeObserver(self, forKeyPath: "originalPrice", context: &myContext)
    }
}
