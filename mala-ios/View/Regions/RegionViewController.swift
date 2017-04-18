//
//  RegionViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/9/12.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let SchoolTableViewCellReuseId = "SchoolTableViewCellReuseId"

class RegionViewController: StatefulViewController, UITableViewDelegate, UITableViewDataSource  {

    // MARK: - Property
    // 城市数据模型
    var city: BaseObjectModel = BaseObjectModel()
    // 校区数据模型
    var school: SchoolModel = SchoolModel()
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
    override var currentState: StatefulViewState {
        didSet {
            if currentState != oldValue {
                self.tableView.reloadEmptyDataSet()
            }
        }
    }
    
    
    // MARK: - Components
    // 城市选择按钮
    private lazy var cityView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.addTapEvent(target: self, action: #selector(RegionViewController.pushToCityPickView))
        return view
    }()
    private lazy var cityLabel: UILabel = {
        let label = UILabel(
            text: "当前城市",
            fontSize: 15,
            textColor: UIColor(named: .ArticleTitle)
        )
        return label
    }()
    private lazy var currentCityLabel: UILabel = {
        let label = UILabel(
            text: "",
            fontSize: 15,
            textColor: UIColor(named: .ThemeDeepBlue)
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
            textColor: UIColor(named: .ArticleSubTitle)
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
        view.backgroundColor = UIColor(named: .BaseBoard)
        cityView.backgroundColor = UIColor.white
        
        let leftBarButtonItem = UIBarButtonItem(customView: popButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // tableView Style
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundColor = UIColor(named: .BaseBoard)
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor(named: .SeparatorLine)
        tableView.estimatedRowHeight = 60
        tableView.register(RegionUnitCell.self, forCellReuseIdentifier: SchoolTableViewCellReuseId)
        
        // stateful
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
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
    fileprivate func loadSchoolList() {
        currentCityLabel.text = MalaCurrentCity?.name ?? "未选择"
        
        guard let city = MalaCurrentCity else {
            showToast("地区选择有误，请重试")
            return
        }
        
        guard currentState != .loading else { return }
        models = []
        currentState = .loading
        
        MAProvider.getSchools(regionId: city.id, failureHandler: { error in
            println(error)
            self.currentState = .error
        }) { schools in
            delay(0.65, work: {
                self.currentState = .content
                self.models = schools.reversed()
                println("校区列表 - \(schools)")
            })
        }
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


extension RegionViewController {
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.loadSchoolList()
    }
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.loadSchoolList()
    }
}
