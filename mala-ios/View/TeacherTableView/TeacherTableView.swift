//
//  TeacherTableView.swift
//  mala-ios
//
//  Created by 王新宇 on 1/20/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class TeacherTableView: UITableView {
    
    // MARK: - Property
    /// 上拉刷新视图
    private lazy var reloadView: ThemeReloadView = {
        let reloadView = ThemeReloadView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        return reloadView
    }()
    
    
    // MARK: - Contructed
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        configration()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func configration() {
        backgroundColor = UIColor(named: .RegularBackground)
        estimatedRowHeight = 200
        separatorStyle = .none
        contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 48 + 6, right: 0)
    }
    

    // MARK: - override
    override func reloadData() {
        DispatchQueue.main.async(execute: { () -> Void in
            super.reloadData()
        })
        self.stopPullRefreshEver()
    }
}
