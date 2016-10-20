//
//  LiveCourseDetailDescCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/20.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class LiveCourseDetailDescCell: MalaBaseLiveCourseCell {
    
    // MARK: - Comoponents
    /// 课程介绍
    private lazy var courseDescView: UILabel = {
        let label = UILabel(
            text: MalaConfig.aboutDescriptionHTMLString(),
            font: UIFont(name: "STHeitiSC-Light", size: 13),
            textColor: MalaColor_939393_0
        )
        label.numberOfLines = 0
        return label
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
        
        // SubViews
        content.addSubview(courseDescView)
        
        // Autolayout
        courseDescView.snp.makeConstraints { (maker) in
            maker.top.equalTo(content).offset(2)
            maker.left.equalTo(content)
            maker.right.equalTo(content)
            maker.bottom.equalTo(content)
        }
    }
}
