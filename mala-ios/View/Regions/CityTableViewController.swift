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
            DispatchQueue.main.async(execute: { [weak self] () -> Void in
                self?.tableView.reloadData()
            })
        }
    }
    // 选择闭包
    var didSelectAction: (()->())?
    // 是否未选择地点－标记
    var unSelectRegion: Bool = (MalaUserDefaults.currentSchool.value == nil)
    
    
    // MARK: - Components
    // 城市列表
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCitylist()
    }
    
    
    // MARK: - Private
    private func setupUserInterface() {
        // Style
        title = "选择城市"
        view.backgroundColor = UIColor.white
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if !unSelectRegion {
            let leftBarButtonItem = UIBarButtonItem(customView: closeButton)
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }
        
        // tableView Style
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = MalaColor_F6F7F9_0
        tableView.separatorStyle = .none
        tableView.register(RegionUnitCell.self, forCellReuseIdentifier: CityTableViewCellReuseId)
        
        // SubViews
        view.addSubview(tableView)
        
        // AutoLayout
        tableView.snp.makeConstraints { (maker) in
            maker.center.equalTo(view)
            maker.size.equalTo(view)
        }
    }
    
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MalaCurrentCity = models[(indexPath as NSIndexPath).row]
        MalaUserDefaults.currentCity.value = models[(indexPath as NSIndexPath).row]
        
        if unSelectRegion {
            pushToSchoolList()
        }else {
            pop()
        }
    }
    
    
    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCellReuseId, for: indexPath) as! RegionUnitCell
        cell.city = models[(indexPath as NSIndexPath).row]
        
        // Section的最后一个Cell隐藏分割线
        if ((indexPath as NSIndexPath).row+1) == models.count {
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
            self?.models = cities.reversed()
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
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Public Method
    func hideCloseButton(_ hidden: Bool = true) {
        closeButton.isHidden = hidden
    }
}
