//
//  SubjectSelectionBar.swift
//  mala-ios
//
//  Created by 王新宇 on 2017/5/23.
//  Copyright © 2017年 Mala Online. All rights reserved.
//

import UIKit
import Popover

class SubjectSelectionBar: UIView, UITableViewDataSource, UITableViewDelegate {

    struct subjectSelection {
        var title: String
        var subject: MASubjectId
        
        init(title: String, subject: MASubjectId) {
            self.title = title
            self.subject = subject
        }
    }
    
    let subjects: [subjectSelection] = [
        subjectSelection(title: "英语", subject: .english),
        subjectSelection(title: "数学", subject: .math)
    ]
    
    var refreshAction: (()->())?
    
    // MARK: - Components
    private lazy var subjectTableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 140, height: 89))
        tableView.separatorColor = UIColor(named: .themeLightBlue)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        return tableView
    }()
    private lazy var subjectLabel: UILabel = {
        let label = UILabel(
            text: "科目：英语 3",
            font: FontFamily.PingFangSC.Regular.font(16),
            textColor: UIColor(named: .labelBlack)
        )
        let subjectName = MalaCurrentSubject == .math ? "数学" : "英语"
        label.text = String(format: "科目：%@ %d", subjectName, getSubjectRecord(subject: MalaCurrentSubject) ?? 0)
        return label
    }()
    private lazy var popover: Popover = {
        let popover = Popover(options: [
            .arrowSize(CGSize(width: 9, height: 7.9)),
            .type(.down),
            .cornerRadius(4),
            .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
            ])
        return popover
    }()
    
    
    // MARK: - Constructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private
    private func setupUserInterface() {
        addTapEvent(target: self, action: #selector(SubjectSelectionBar.subjectBarDidTap))
        
        addSubview(subjectLabel)
        subjectLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(22)
            maker.center.equalTo(self)
        }
    }
    
    
    // MARK: - DataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let model = subjects[indexPath.row]
        
        cell.textLabel?.text = String(format: "%@ %d", model.title, getSubjectRecord(subject: model.subject) ?? 0)
        
        if model.subject == MalaCurrentSubject {
            cell.contentView.backgroundColor = UIColor(named: .themeLightBlue)
        }
        return cell
    }
    
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.cellForRow(at: indexPath)?.isSelected = false
            self.popover.dismiss()
            refreshAction?()
        }
        let model = subjects[indexPath.row]
        subjectLabel.text = String(format: "科目：%@ %d", model.title, getSubjectRecord(subject: model.subject) ?? 0)
        MalaCurrentSubject = model.subject
    }
    
    
    @objc private func subjectBarDidTap() {
        subjectTableView.reloadData()
        self.popover.show(subjectTableView, fromView: self.subjectLabel)
    }
}
