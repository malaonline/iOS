//
//  NewProjectViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/17.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit
import PagingMenuController

class NewProjectViewController: BaseViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        view.backgroundColor = MalaColor_EDEDED_0
        defaultView.imageName = "filter_no_result"
        defaultView.text = "当前城市没有老师！"
        
        // SubViews
        
        // AutoLayout
    }
}

