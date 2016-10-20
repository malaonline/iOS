//
//  LiveCourseDetailViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/20.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class LiveCourseDetailViewController: BaseViewController, LiveCourseConfirmViewDelegate {
    
    // MARK: - Property
    /// 教师id
    var classId: Int? {
        didSet {

        }
    }
    /// 教师详情数据模型
    var model: LiveClassModel = TestFactory.testLiveClass() {
        didSet {
            
        }
    }
    
    
    // MARK: - Compontents
    private lazy var tableView: LiveCourseTableView = {
        let tableView = LiveCourseTableView(frame: CGRect.zero, style: .grouped)
        return tableView
    }()
    private lazy var confirmView: LiveCourseConfirmView = {
        let confirmView = LiveCourseConfirmView()
        return confirmView
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        setupNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sendScreenTrack(SACourseChoosingViewName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Private method
    private func setupUserInterface() {
        // Style
        title = MalaCommonString_CourseChoosing
        
        // SubViews
        view.addSubview(tableView)
        view.addSubview(confirmView)
        
        confirmView.delegate = self
        
        // Autolayout
        tableView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(view.snp.top)
            maker.left.equalTo(view.snp.left)
            maker.right.equalTo(view.snp.right)
            maker.bottom.equalTo(confirmView.snp.top)
        }
        confirmView.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(view.snp.bottom)
            maker.left.equalTo(view.snp.left)
            maker.right.equalTo(view.snp.right)
            maker.height.equalTo(47)
        }
    }
    
    private func setupNotification() {
        
    }
    
    func OrderDidConfirm() {
        println("Order Did Confirm")
    }
    
    deinit {
        println("choosing Controller deinit")
    }
}
