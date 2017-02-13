//
//  TeacherDetailsTagsCell.swift
//  mala-ios
//
//  Created by Elors on 1/5/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class TeacherDetailsTagsCell: MalaBaseCell {

    // MARK: - Property
    /// 标签字符串数组
    var labels: [String] = [] {
        didSet {
            tagsView.labels = labels
        }
    }
    
    
    // MARK: - Components
    /// 标签容器
    lazy var tagsView: ThemeTagListView = {
        let tagsView = ThemeTagListView()
        tagsView.imageName = "tags_icon"
        tagsView.labelBackgroundColor = UIColor(named: .SubjectTagBlue)
        tagsView.textColor = UIColor(named: .StyleTag)
        return tagsView
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
        content.addSubview(tagsView)
        
        // AutoLayout
        tagsView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(content)
            maker.left.equalTo(content)
            maker.bottom.equalTo(content)
            maker.height.equalTo(25)
            maker.right.equalTo(content)
        }
    }
}
