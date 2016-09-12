//
//  CityTableViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/8/16.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let CityTableViewCellReuseId = "CityTableViewCellReuseId"
private let CityTableViewHeaderViewReuseId = "CityTableViewHeaderViewReuseId"

class CityTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Property
    // 城市数据模型
    var models: [BaseObjectModel] = [] {
        didSet {
            dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                self?.tableView.reloadData()
            })
        }
    }
    // 选择闭包
    var didSelectAction: (()->())?
    
    
    // MARK: - Components
    // 城市列表
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Grouped)
        return tableView
    }()
    // 关闭按钮
    private lazy var closeButton: UIButton = {
        let button = UIButton(
            imageName: "close",
            target: self,
            action: #selector(CityTableViewController.closeButtonDidClick)
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
    
    
    // MARK: - Private
    private func setupUserInterface() {
        // Style
        title = "选择城市"
        view.backgroundColor = UIColor.whiteColor()
        let leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // tableView Style
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = MalaColor_F6F7F9_0
        tableView.separatorStyle = .None
        tableView.registerClass(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCellReuseId)
        tableView.registerClass(CityTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: CityTableViewHeaderViewReuseId)
        
        // SubViews
        self.view.addSubview(tableView)
        
        // AutoLayout
        tableView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top)
            make.bottom.equalTo(self.view.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
        }
    }
    
    
    // MARK: - Delegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(CityTableViewHeaderViewReuseId)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        MalaCurrentRegion = models[indexPath.row]
        pushToSchoolList()
    }
    
    
    // MARK: - DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CityTableViewCellReuseId, forIndexPath: indexPath) as! CityTableViewCell
        cell.model = models[indexPath.row]
        return cell
    }
    
    
    // MARK: - Private Method
    // 获取城市列表
    private func loadCitylist() {
        
        loadRegions({ (reason, errorMessage) in
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            
            // 错误处理
            if let errorMessage = errorMessage {
                println("CityTableViewController - loadCitylist Error \(errorMessage)")
            }
        }, completion:{ [weak self] (cities) in
            self?.models = cities.reverse()
            println("城市列表 - \(cities)")
        })
    }
    
    private func pushToSchoolList() {
        let viewController = SchoolTableViewController()
        viewController.didSelectAction = self.didSelectAction
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - Events Response
    @objc private func closeButtonDidClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Public Method
    func hideCloseButton(hidden: Bool = true) {
        closeButton.hidden = hidden
    }
}


class CityTableViewCell: UITableViewCell {
    
    // MARK: - Property
    // 城市数据模型
    var model: BaseObjectModel = BaseObjectModel() {
        didSet {
            textLabel?.text = model.name
        }
    }
    
    
    // MARK: - Instance Method
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
        backgroundColor = MalaColor_F6F7F9_0
        selectionStyle = .None
        
        textLabel?.font = UIFont.systemFontOfSize(14)
    }
}


class CityTableViewHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel(title: "选择服务城市")
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    private lazy var separatorLine: UIView = {
        let view = UIView.separator(MalaColor_DEDFD0_0)
        return view
    }()
    
    
    // MARK: - Instance Method
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        backgroundColor = MalaColor_F6F7F9_0
        
        // SubViews
        addSubview(titleLabel)
        addSubview(separatorLine)
        
        // AutoLayout
        titleLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.snp_bottom).offset(-8)
            make.left.equalTo(self.snp_left).offset(15)
            make.height.equalTo(20)
        }
        separatorLine.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(15)
            make.right.equalTo(self.snp_right).offset(-15)
            make.height.equalTo(MalaScreenOnePixel)
            make.bottom.equalTo(self.snp_bottom)
        }
    }
}