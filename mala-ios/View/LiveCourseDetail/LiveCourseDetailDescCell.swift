//
//  LiveCourseDetailDescCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/20.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let LiveCourseDetailIntroTableViewCellReuseId = "LiveCourseDetailIntroTableViewCellReuseId"

class LiveCourseDetailDescCell: MalaBaseLiveCourseCell, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Property
    /// 课程模型
    var model: LiveClassModel? {
        didSet{
            guard let model = model else { return }
            labels = model.courseDesc?.components(separatedBy: "\n") ?? []
        }
    }
    var labels: [String] = [] {
        didSet {
            let tableViewHeight = labels.count*24
            tableView.snp.updateConstraints({ (maker) -> Void in
                maker.height.equalTo(tableViewHeight)
            })
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Comoponents
    /// 课程介绍
    private lazy var tableView: LiveCourseDetailIntroTableView = {
        let tableView = LiveCourseDetailIntroTableView(frame: CGRect.zero, style: .plain)
        tableView.register(LiveCourseDetailIntroTableViewCell.self, forCellReuseIdentifier: LiveCourseDetailIntroTableViewCellReuseId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.isScrollEnabled = false
        tableView.rowHeight = 24
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
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
        // SubViews
        content.addSubview(tableView)
        
        // Autolayout
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(content).offset(5)
            maker.left.equalTo(content)
            maker.height.equalTo(10)
            maker.right.equalTo(content)
            maker.bottom.equalTo(content).offset(-5)
        }
    }
    
    // MARK: - Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.labels.count
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveCourseDetailIntroTableViewCellReuseId, for: indexPath) as! LiveCourseDetailIntroTableViewCell
        cell.title = labels[indexPath.row]
        return cell
    }
}


class LiveCourseDetailIntroTableView: UITableView {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class LiveCourseDetailIntroTableViewCell: UITableViewCell {
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private lazy var dotIcon: UIImageView = {
        let imageView = UIImageView(image: "live_dot")
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "介绍点",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .ArticleTitle)
        )
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(dotIcon)
        contentView.addSubview(titleLabel)
        
        dotIcon.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView)
            maker.left.equalTo(contentView).offset(6)
            maker.height.equalTo(8)
            maker.width.equalTo(8)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(14)
            maker.top.equalTo(contentView).offset(5)
            maker.left.equalTo(dotIcon.snp.right).offset(12)
            maker.bottom.equalTo(contentView).offset(-5)
        }
    }
}
