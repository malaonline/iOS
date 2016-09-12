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
    
    
    // MARK: - Components
    /// 标题label
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.textColor = MalaColor_636363_0
        return titleLabel
    }()
    /// 分割线
    lazy var separatorLine: UIView = {
        let separatorLine = UIView.line()
        separatorLine.backgroundColor = MalaColor_E5E5E5_0
        return separatorLine
    }()
    
    
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
        textLabel?.font = UIFont.systemFontOfSize(14)
        selectionStyle = .None
        separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        // SubViews
        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorLine)
        
        // Autolayout
        titleLabel.snp_makeConstraints { (make) in
            make.height.equalTo(14)
            make.centerY.equalTo(contentView.snp_centerY)
            make.left.equalTo(contentView.snp_left).offset(13)
        }
        separatorLine.snp_makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp_bottom)
            make.left.equalTo(contentView.snp_left).offset(12)
            make.right.equalTo(contentView.snp_right).offset(12)
            make.height.equalTo(MalaScreenOnePixel)
        }
    }
    
    func hideSeparator() {
        self.separatorLine.hidden = true
    }
}
