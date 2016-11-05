//
//  EvaluationFilingServiceController.swift
//  mala-ios
//
//  Created by 王新宇 on 2/18/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

private let EvaluationFilingServiceCellReuseId = "EvaluationFilingServiceCellReuseId"

class EvaluationFilingServiceController: BaseTableViewController {

    // MARK: - Property
    var introductions: [IntroductionModel]? {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        loadIntroductions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == (introductions?.count ?? 0)-1 ? 0 : 8
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    // MARK: - DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.introductions?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EvaluationFilingServiceCellReuseId, for: indexPath) as! EvaluationFilingServiceCell
        cell.selectionStyle = .none
        if self.introductions?[indexPath.section] != nil {
            cell.model = self.introductions![indexPath.section]
        }
        return cell
    }
    
    
    // MARK: - Private Method
    private func configure() {
        // Style 
        title = MalaCommonString_EvaluationFiling
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 300
        tableView.separatorStyle = .none
        
        self.tableView.register(EvaluationFilingServiceCell.self, forCellReuseIdentifier: EvaluationFilingServiceCellReuseId)
    }
    
    // 读取 [测评建档]服务 简介
    private func loadIntroductions() {
        // 网络请求
        let dataArray = NSArray(contentsOfFile: Bundle.main.path(forResource: "EvaluationFiling.plist", ofType: nil)!) as? [AnyObject]
        var modelDicts: [IntroductionModel]? = []
        for object in dataArray! {
            if let dict = object as? [String: AnyObject] {
                let set = IntroductionModel(dict: dict)
                modelDicts?.append(set)
            }
        }
        self.introductions = modelDicts
    }
}


class EvaluationFilingServiceCell: MalaBaseCell {
    
    // MARK: - Property
    var model: IntroductionModel? {
        didSet {
            title = model?.title
            contentImageView.image = UIImage(named: (model?.image ?? ""))
            contentLabel.text = model?.subTitle
        }
    }
    
    
    // MARK: - Components
    /// 内容展示图片容器
    private lazy var contentImageView: UIImageView = {
        let contentImageView = UIImageView(imageName: "detailPicture_placeholder")
        return contentImageView
    }()
    /// 简介文本框
    private lazy var contentLabel: UILabel = {
        let contentLabel = UILabel(
            fontSize: 13,
            textColor: MalaColor_6C6C6C_0
        )
        contentLabel.numberOfLines = 0
        return contentLabel
    }()
    
    
    // MARK: - Constructed
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
        
        // Subviews
        content.addSubview(contentImageView)
        content.addSubview(contentLabel)
        
        // Autolayout
        contentImageView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(content)
            maker.left.equalTo(content)
            maker.right.equalTo(content)
            maker.height.equalTo(contentImageView.snp.width).multipliedBy(0.47)
        }
        contentLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentImageView.snp.bottom).offset(14)
            maker.left.equalTo(content)
            maker.right.equalTo(content)
            maker.bottom.equalTo(content)
        }
    }
}
