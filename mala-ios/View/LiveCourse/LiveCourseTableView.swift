//
//  LiveCourseTableView.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/17.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let LiveCourseTableViewCellReusedId = "LiveCourseTableViewCellReusedId"

class LiveCourseTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Property
    /// 数据模型数组
    var model: [LiveClassModel] = [] {
        didSet {
            self.reloadData()
        }
    }
    weak var controller: UIViewController?
    
    
    // MARK: - Instance Method
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        configration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func configration() {
        delegate = self
        dataSource = self
        backgroundColor = MalaColor_EDEDED_0
        estimatedRowHeight = 200
        separatorStyle = .none
        contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 48 + 6, right: 0)
        register(LiveCourseTableViewCell.self, forCellReuseIdentifier: LiveCourseTableViewCellReusedId)
    }
    
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let classModel = (tableView.cellForRow(at: indexPath) as? LiveCourseTableViewCell)?.model else {
            return
        }
        
        let viewController = LiveCourseDetailViewController()
        viewController.model = classModel
        viewController.hidesBottomBarWhenPushed = true
        controller?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveCourseTableViewCellReusedId, for: indexPath) as! LiveCourseTableViewCell
        cell.model = model[(indexPath as NSIndexPath).row]
        return cell
    }
    
    
    // MARK: - override
    override func reloadData() {
        DispatchQueue.main.async(execute: { () -> Void in
            super.reloadData()
        })
    }
}
