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
            guard !models.isEmpty && models.count != oldValue.count else { return }
            
            DispatchQueue.main.async {
                let data = handleRegion(self.models)
                self._groupedModels = data.models
                self._indexTitles = data.titles
                self.tableView.reloadData()
            }
        }
    }
    // 选择闭包
    var didSelectAction: (()->())?
    // 是否未选择地点－标记
    var unSelectRegion: Bool = (MalaUserDefaults.currentSchool.value == nil)
    
    // MARK: - Private variables
    private var _groupedModels: [[BaseObjectModel]] = []
    private var _indexTitles: [String] = []
    private var _allLetter: [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    // MARK: - Components
    // 城市列表
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
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
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        }
        
        // tableView Style
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(named: .SeparatorLine)
        tableView.backgroundColor = UIColor(named: .BaseBoard)
        tableView.tableFooterView = UIView()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        let model: BaseObjectModel = _groupedModels[indexPath.section][indexPath.row]
        MalaCurrentCity = model
        MalaUserDefaults.currentCity.value = model
        
        if unSelectRegion {
            pushToSchoolList()
        }else {
            pop()
        }
    }
    
    
    // MARK: - Index
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return _allLetter
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _indexTitles[section]
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return _indexTitles.index(of: title) ?? index
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.headerView(forSection: section)
        view?.textLabel?.font = FontFamily.PingFangSC.Regular.font(14)
        return view
    }
    
    
    // MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return _groupedModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _groupedModels[section].count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCellReuseId, for: indexPath) as! RegionUnitCell
        cell.city = _groupedModels[indexPath.section][indexPath.row]
        cell.hideSeparator()
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
        }, completion: { (cities) in
            self.models = cities
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
