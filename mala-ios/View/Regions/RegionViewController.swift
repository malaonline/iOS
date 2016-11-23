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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    // 选择闭包
    var didSelectAction: (()->())?
    
    
    // MARK: - Components
    // 城市选择按钮
    private lazy var cityView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegionViewController.pushToCityPickView)))
        return view
    }()
    private lazy var cityLabel: UILabel = {
        let label = UILabel(
            text: "当前城市",
            fontSize: 15,
            textColor: MalaColor_333333_0
        )
        return label
    }()
    private lazy var currentCityLabel: UILabel = {
        let label = UILabel(
            text: "",
            fontSize: 15,
            textColor: MalaColor_71B3E3_0
        )
        return label
    }()
    private lazy var cityArrow: UIImageView = {
        let imageView = UIImageView(imageName: "rightArrow")
        return imageView
    }()
    /// 校区列表
    private lazy var tableHeaderView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var tableHeaderString: UILabel = {
        let label = UILabel(
            text: "点击切换校区",
            fontSize: 13,
            textColor: MalaColor_6C6C6C_0
        )
        return label
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadSchoolList()
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        title = "选择校区"
        view.backgroundColor = MalaColor_F6F7F9_0
        cityView.backgroundColor = UIColor.white
        let leftBarButtonItem = UIBarButtonItem(customView: popButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // tableView Style
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundColor = MalaColor_F6F7F9_0
        tableView.separatorStyle = .none
        tableView.separatorColor = MalaColor_E5E5E5_0
        tableView.estimatedRowHeight = 60
        tableView.register(RegionUnitCell.self, forCellReuseIdentifier: SchoolTableViewCellReuseId)
        
        
        // SubViews
        view.addSubview(cityView)
        cityView.addSubview(cityLabel)
        cityView.addSubview(currentCityLabel)
        cityView.addSubview(cityArrow)
        view.addSubview(tableHeaderView)
        tableHeaderView.addSubview(tableHeaderString)
        view.addSubview(tableView)
        
        // AutoLayout
        cityView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view).offset(10)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.height.equalTo(40)
        }
        cityLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(cityView)
            maker.height.equalTo(15)
            maker.left.equalTo(cityView).offset(12)
        }
        currentCityLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(cityView)
            maker.right.equalTo(cityArrow.snp.left).offset(-10)
            maker.height.equalTo(15)
        }
        cityArrow.snp.makeConstraints { (maker) in
            maker.height.equalTo(13)
            maker.width.equalTo(7)
            maker.right.equalTo(cityView).offset(-12)
            maker.centerY.equalTo(cityView)
        }
        tableHeaderView.snp.makeConstraints { (maker) in
            maker.top.equalTo(cityView.snp.bottom)
            maker.bottom.equalTo(tableView.snp.top)
            maker.height.equalTo(33)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
        }
        tableHeaderString.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(tableHeaderView)
            maker.left.equalTo(tableHeaderView).offset(12)
            maker.height.equalTo(13)
        }
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(tableHeaderString.snp.bottom)
            maker.bottom.equalTo(view)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
        }
    }
    
    // 获取学校列表
    private func loadSchoolList() {
        currentCityLabel.text = MalaCurrentCity?.name ?? "未选择"
        
        guard let city = MalaCurrentCity else {
            ShowToast("地区选择有误，请重试")
            return
        }
        
        getSchools(city.id, failureHandler: { (reason, errorMessage) in
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            // 错误处理
            if let errorMessage = errorMessage {
                println("CityTableViewController - getSchools Error \(errorMessage)")
            }
        }, completion: { (schools) in
            self.models = schools.reversed()
            println("校区列表 - \(schools)")
        })
    }
    
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MalaCurrentSchool = models[indexPath.row]
        MalaUserDefaults.currentSchool.value = models[indexPath.row]
        didSelectAction?()
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SchoolTableViewCellReuseId, for: indexPath) as! RegionUnitCell
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
        dismiss(animated: true, completion: nil)
    }
}
