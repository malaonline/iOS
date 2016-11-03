//
//  CourseChoosingServiceTableView.swift
//  mala-ios
//
//  Created by 王新宇 on 2/18/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

private let CourseChoosingServiceTableViewCellReuseId = "CourseChoosingServiceTableViewCellReuseId"

class CourseChoosingServiceTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Property
    var services: [OtherServiceModel] = MalaOtherService
    
    // MARK: - Constructed
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func configure() {
        delegate = self
        dataSource = self
        bounces = false
        separatorColor = MalaColor_E5E5E5_0
        register(CourseChoosingServiceTableViewCell.self, forCellReuseIdentifier: CourseChoosingServiceTableViewCellReuseId)
    }
    
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MalaLayout_OtherServiceCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 跳转到对应的ViewController
        if let type = (services[indexPath.row].viewController) as? UIViewController.Type {
            let viewController = type.init()
            (viewController as? CouponViewController)?.justShow = false
            (viewController as? CouponViewController)?.onlyValid = true
            viewController.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 若非首次购课，不显示第二项[建档测评服务]
        return MalaIsHasBeenEvaluatedThisSubject == true ? MalaOtherService.count : (MalaOtherService.count-1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseChoosingServiceTableViewCellReuseId, for: indexPath)
        (cell as! CourseChoosingServiceTableViewCell).service = self.services[indexPath.row]
        return cell
    }
}


// MARK: - CourseChoosingServiceTableViewCell
class CourseChoosingServiceTableViewCell: UITableViewCell {
    
    // MARK: Property
    var service: OtherServiceModel? {
        didSet{
            
            guard let model = service else {
                return
            }
            
            if model.type == .coupon {
                configure()
            }
            
            self.titleLabel.text = service?.title

            if let amount = MalaCurrentCourse.coupon?.amount, amount != 0 {
                updateUserInterface()
                return
            }
            
            switch model.priceHandleType {
            case .discount:
                
                self.priceHandleLabel.text = model.price?.priceCNY == nil ? "" : "-"
                self.priceLabel.text = model.price?.priceCNY
                break
                
            case .reduce:
                
                let oldPrice = String(format: "￥%d", (model.price ?? 0))
                let attr = NSMutableAttributedString(string: oldPrice)
                attr.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: 1), range: NSMakeRange(0, oldPrice.characters.count))
                self.priceHandleLabel.attributedText = attr
                self.priceLabel.text = String(format: "￥%d", 0)
                break
                
            case .none:
                
                self.priceHandleLabel.text = ""
                self.priceLabel.text = "不使用奖学金"
                break
            }
        }
    }
    private var myContext = 0
    private var didAddObserve = false
    
    
    // MARK: - Components
    /// 标题Label
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            fontSize: 14,
            textColor: MalaColor_6C6C6C_0
        )
        return label
    }()
    /// 右箭头标示
    private lazy var detailImageView: UIImageView = {
        let imageView = UIImageView(imageName: "rightArrow")
        return imageView
    }()
    /// 价格Label
    private lazy var priceLabel: UILabel = {
        let label = UILabel(
            text: "",
            fontSize: 14,
            textColor: MalaColor_333333_0
        )
        return label
    }()
    /// 价格处理Label
    private lazy var priceHandleLabel: UILabel = {
        let label = UILabel(
            text: "",
            fontSize: 14,
            textColor: MalaColor_333333_0
        )
        return label
    }()
    
    
    // MARK: - Constructed
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUserInterface()
        updateUserInterface()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        selectionStyle = .none
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
        
        // Subviews
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailImageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceHandleLabel)
        
        // Autolayout
        titleLabel.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(contentView)
            maker.height.equalTo(14)
            maker.centerY.equalTo(contentView)
        }
        detailImageView.snp.makeConstraints { (maker) -> Void in
            maker.right.equalTo(contentView)
            maker.centerY.equalTo(contentView)
        }
        priceLabel.snp.makeConstraints { (maker) -> Void in
            maker.height.equalTo(14)
            maker.right.equalTo(detailImageView.snp.left).offset(-6)
            maker.centerY.equalTo(contentView)
        }
        priceHandleLabel.snp.makeConstraints { (maker) -> Void in
            maker.height.equalTo(14)
            maker.right.equalTo(priceLabel.snp.left).offset(-6)
            maker.centerY.equalTo(contentView)
        }
    }
    
    private func configure() {
        MalaCurrentCourse.addObserver(self, forKeyPath: "coupon", options: .new, context: &myContext)
        didAddObserve = true
    }
    
    
    // MARK: - Override
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 选择优惠券时更新UI
        updateUserInterface()
    }
    
    private func updateUserInterface() {
        
        // 选择优惠券时更新UI
        if let title = MalaCurrentCourse.coupon?.name, title == "不使用奖学金" {
            self.priceHandleLabel.text = ""
            self.priceLabel.text = "不使用奖学金"
        }else if let amount = MalaCurrentCourse.coupon?.amount, amount != 0 {
            self.priceHandleLabel.text = "-"
            self.priceLabel.text = MalaCurrentCourse.coupon?.amount.priceCNY
        }else {
            self.priceHandleLabel.text = ""
            self.priceLabel.text = "不使用奖学金"
        }
        
        if let title = MalaCurrentCourse.coupon?.name, title != "" {
            self.titleLabel.text = title
        }else {
            self.titleLabel.text = "奖学金"
        }
    }
    

    deinit {
        if didAddObserve {
            MalaCurrentCourse.removeObserver(self, forKeyPath: "coupon", context: &myContext)
        }
    }
}
