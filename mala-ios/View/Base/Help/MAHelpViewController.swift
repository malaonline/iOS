//
//  MAHelpViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 2017/5/22.
//  Copyright © 2017年 Mala Online. All rights reserved.
//

import UIKit

private let MAHelpViewCellReuseId = "MAHelpViewCellReuseId"

class MAHelpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var models = MalaConfig.helpDataForExerciseRecord()
    

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 160
        tableView.register(MAHelpViewCell.self, forCellReuseIdentifier: MAHelpViewCellReuseId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setup() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view)
            maker.left.equalTo(view)
            maker.bottom.equalTo(view)
            maker.right.equalTo(view)
            maker.width.equalTo(330)
            maker.height.equalTo(420)
        }
    }
    
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MAHelpViewCellReuseId) as! MAHelpViewCell
        cell.model = models[indexPath.row]
        return cell
    }
}
