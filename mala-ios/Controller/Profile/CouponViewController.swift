//
//  CouponViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 2/19/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

private let CouponViewCellReuseId = "CouponViewCellReuseId"

class CouponViewController: StatefulViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Property
    /// 优惠券模型数组
    var models: [CouponModel] = MalaUserCoupons {
        didSet {
            tableView.reloadData()
        }
    }
    /// 当前选择项IndexPath标记
    /// 缺省值为不存在的indexPath，有效的初始值将会在CellForRow方法中设置
    private var currentSelectedIndexPath: IndexPath = IndexPath(item: 0, section: 1)
    /// 是否仅用于展示（例如[个人中心]）
    var justShow: Bool = true
    /// 是否只获取可用的奖学金（[选课页面]）
    var onlyValid: Bool = false
    override var currentState: StatefulViewState {
        didSet {
            if currentState != oldValue {
                self.tableView.reloadEmptyDataSet()
            }
        }
    }
    
    // MARK: - Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: .RegularBackground)
        tableView.register(CouponViewCell.self, forCellReuseIdentifier: CouponViewCellReuseId)
        return tableView
    }()
    private lazy var rulesButton: UIButton = {
        let button = UIButton(
            title: L10n.rule,
            titleColor: UIColor(named: .ThemeBlue),
            target: self,
            action: #selector(CouponViewController.showCouponRules)
        )
        button.setTitleColor(UIColor(named: .Disabled), for: .disabled)
        return button
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        loadCoupons()
        
        // 开启下拉刷新
        tableView.startPullRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Private Method
    private func configure() {
        // style
        title = L10n.coupon
        view.addSubview(tableView)
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        // 下拉刷新
        tableView.addPullRefresh{ [weak self] in
            self?.loadCoupons()
            self?.tableView.stopPullRefreshEver()
        }
        
        // rightBarButtonItem
        let spacerRight = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacerRight.width = -5
        let rightBarButtonItem = UIBarButtonItem(customView: rulesButton)
        navigationItem.rightBarButtonItems = [rightBarButtonItem, spacerRight]
        
        // autoLayout
        tableView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(view)
            maker.left.equalTo(view)
            maker.bottom.equalTo(view)
            maker.right.equalTo(view)
        }
    }
    
    
    ///  获取优惠券信息
    @objc fileprivate func loadCoupons() {
        
        // 屏蔽[正在刷新]时的操作
        guard currentState != .loading else { return }
        models = []
        currentState = .loading

        MAProvider.userCoupons(onlyValid: onlyValid, failureHandler: { error in
            // 显示缺省值
            self.currentState = .error
            self.models = MalaUserCoupons
        }) { coupons in
            print(coupons.count)
            MalaUserCoupons = self.justShow ? coupons : parseCouponlist(coupons)
            self.currentState = .content
            self.models = MalaUserCoupons
        }
    }
    
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MalaLayout_CardCellWidth*0.273
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///  若只用于显示，直接return
        if justShow { return }
        
        let cell = tableView.cellForRow(at: indexPath) as? CouponViewCell

        // 不可选择被冻结的奖学金
        guard cell?.disabled == false else { return }
        
        // 只有未使用的才可选中
        guard cell?.model?.status == .unused else { return }
        
        // 选中当前选择Cell，并取消其他Cell选择
        if indexPath == currentSelectedIndexPath {
            // 取消选中项
            cell?.showSelectedIndicator = false
            currentSelectedIndexPath = IndexPath(item: 0, section: 1)
            MalaCurrentCourse.coupon = CouponModel(id: 0, name: L10n.donTUseCoupon, amount: 0, expired_at: 0, used: false)
        }else {
            (tableView.cellForRow(at: currentSelectedIndexPath) as? CouponViewCell)?.showSelectedIndicator = false
            cell?.showSelectedIndicator = true
            currentSelectedIndexPath = indexPath
            MalaCurrentCourse.coupon = cell?.model
        }
        _ = navigationController?.popViewController(animated: true)
    }

    
    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CouponViewCellReuseId, for: indexPath) as! CouponViewCell
        cell.selectionStyle = .none
        cell.model = self.models[indexPath.row]
        // 如果是默认选中的优惠券，则设置选中样式
        if models[indexPath.row].id == MalaCurrentCourse.coupon?.id && !justShow {
            cell.showSelectedIndicator = true
            currentSelectedIndexPath = indexPath
        }
        return cell
    }
    
    
    // MARK: - Events Response
    @objc private func showCouponRules() {
        CouponRulesPopupWindow(title: L10n.couponRule, desc: MalaConfig.couponRulesDescriptionString()).show()
    }
}


extension CouponViewController {
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.loadCoupons()
    }
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.loadCoupons()
    }
}
