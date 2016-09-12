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
            imageName: "leftArrow_black",
            target: self,
            action: #selector(CityTableViewController.pop)
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
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if let _ = MalaUserDefaults.currentCity.value {
            let leftBarButtonItem = UIBarButtonItem(customView: closeButton)
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }
        
        // tableView Style
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = MalaColor_F6F7F9_0
        tableView.separatorStyle = .None
        tableView.registerClass(RegionUnitCell.self, forCellReuseIdentifier: CityTableViewCellReuseId)
        
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
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        MalaCurrentCity = models[indexPath.row]
        MalaUserDefaults.currentCity.value = models[indexPath.row]
        
        if let _ = MalaUserDefaults.currentCity.value {
            pop()
        }else {
            pushToSchoolList()
        }
    }
    
    
    // MARK: - DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CityTableViewCellReuseId, forIndexPath: indexPath) as! RegionUnitCell
        cell.city = models[indexPath.row]
        
        // Section的最后一个Cell隐藏分割线
        if (indexPath.row+1) == models.count {
            cell.hideSeparator()
        }
        
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
    func pop() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: - Public Method
    func hideCloseButton(hidden: Bool = true) {
        closeButton.hidden = hidden
    }
}
