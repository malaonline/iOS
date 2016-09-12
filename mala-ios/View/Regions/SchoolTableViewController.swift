//
//  SchoolTableViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/9/7.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let SchoolTableViewCellReuseId = "SchoolTableViewCellReuseId"

class SchoolTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Property
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
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Grouped)
        return tableView
    }()
    private lazy var popButton: UIButton = {
        let button = UIButton(
            imageName: "leftArrow_black",
            target: self,
            action: #selector(SchoolTableViewController.pop)
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
        // tableView Style
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = MalaColor_F6F7F9_0
        tableView.separatorStyle = .None
        tableView.separatorColor = MalaColor_E5E5E5_0
        tableView.registerClass(RegionUnitCell.self, forCellReuseIdentifier: SchoolTableViewCellReuseId)
        
        // Style
        title = "选择校区"
        let leftBarButtonItem = UIBarButtonItem(customView: popButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        navigationController?.navigationBar.shadowImage = UIImage()
        
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
    
    
    // 获取学校列表
    private func loadCitylist() {
        
        guard let region = MalaCurrentCity else {
            ShowTost("地区选择有误，请重试")
            return
        }
        
        getSchools(region.id, failureHandler: { (reason, errorMessage) in
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
    func pop() {
        navigationController?.popViewControllerAnimated(true)
    }
}
