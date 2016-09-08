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
        tableView.registerClass(SchoolTableViewCell.self, forCellReuseIdentifier: SchoolTableViewCellReuseId)
        
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
        
        guard let region = MalaCurrentRegion else {
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
        let cell = tableView.dequeueReusableCellWithIdentifier(SchoolTableViewCellReuseId, forIndexPath: indexPath) as! SchoolTableViewCell
        cell.model = models[indexPath.row]
        
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


class SchoolTableViewCell: UITableViewCell {
    
    // MARK: - Property
    // 城市数据模型
    var model: SchoolModel = SchoolModel() {
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