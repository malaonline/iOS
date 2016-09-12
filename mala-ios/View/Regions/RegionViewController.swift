//
//  RegionViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/9/12.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let SchoolTableViewCellReuseId = "SchoolTableViewCellReuseId"

class RegionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    // MARK: - Property
    // 城市数据模型
    var city: BaseObjectModel = BaseObjectModel() {
        didSet {
            
        }
    }
    // 校区数据模型
    var school: SchoolModel = SchoolModel() {
        didSet {
            
        }
    }
    // 学校数据模型
    var models: [SchoolModel] = [] {
        didSet {
            dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                self?.tableView.reloadData()
            })
        }
    }
    // 选择闭包
    var didSelectAction: (()->())?
    
    
    // MARK: - Components
    // 城市选择按钮
    private lazy var cityView: UIView = {
        let view = UIView()
        view.userInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegionViewController.pushToCityPickView)))
        return view
    }()
    private lazy var cityLabel: UILabel = {
        let label = UILabel(text: "北京", fontSize: 14, textColor: MalaColor_333333_0)
        return label
    }()
    private lazy var cityArrow: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "rightArrow"))
        return imageView
    }()
    /// 校区列表
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Grouped)
        return tableView
    }()
    private lazy var popButton: UIButton = {
        let button = UIButton(
            imageName: "close",
            target: self,
            action: #selector(RegionViewController.closeButtonDidTap)
        )
        return button
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadCitylist()
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        title = "选择校区"
        view.backgroundColor = MalaColor_F6F7F9_0
        cityView.backgroundColor = UIColor.whiteColor()
        let leftBarButtonItem = UIBarButtonItem(customView: popButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // tableView Style
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = MalaColor_F6F7F9_0
        tableView.separatorStyle = .None
        tableView.separatorColor = MalaColor_E5E5E5_0
        tableView.registerClass(RegionUnitCell.self, forCellReuseIdentifier: SchoolTableViewCellReuseId)
        
        
        // SubViews
        view.addSubview(cityView)
        cityView.addSubview(cityLabel)
        cityView.addSubview(cityArrow)
        view.addSubview(tableView)
        
        // AutoLayout
        cityView.snp_makeConstraints { (make) in
            make.top.equalTo(view).offset(10)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(40)
        }
        cityLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(cityView)
            make.height.equalTo(14)
            make.left.equalTo(cityView).offset(12)
        }
        cityArrow.snp_makeConstraints { (make) in
            make.height.equalTo(13)
            make.width.equalTo(7)
            make.right.equalTo(cityView).offset(-12)
            make.centerY.equalTo(cityView)
        }
        tableView.snp_makeConstraints { (make) in
            make.top.equalTo(cityView.snp_bottom)
            make.bottom.equalTo(view.snp_bottom)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
        }
    }
    
    // 获取学校列表
    private func loadCitylist() {
        
//        guard let region = MalaCurrentRegion else {
//            ShowTost("地区选择有误，请重试")
//            return
//        }
        
        getSchools(3405, failureHandler: { (reason, errorMessage) in
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            
            // 错误处理
            if let errorMessage = errorMessage {
                println("CityTableViewController - getSchools Error \(errorMessage)")
            }
            }, completion:{ [weak self] (schools) in
                self?.models = schools.reverse()
                println("校区列表 - \(schools)")
            })
    }
    
    
    // MARK: - Delegate
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        MalaCurrentSchool = models[indexPath.row]
        didSelectAction?()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SchoolTableViewCellReuseId, forIndexPath: indexPath) as! RegionUnitCell
        cell.school = models[indexPath.row]
        
        // Section的最后一个Cell隐藏分割线
        if (indexPath.row+1) == models.count {
            cell.hideSeparator()
        }
        
        return cell
    }
    
    
    // MARK: - Events Response
    @objc private func pushToCityPickView() {
        let viewController = CityTableViewController()
        viewController.hideCloseButton(false)
        viewController.didSelectAction = didSelectAction
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func closeButtonDidTap() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
