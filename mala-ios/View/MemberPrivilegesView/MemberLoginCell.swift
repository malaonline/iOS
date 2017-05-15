//
//  MemberLoginCell.swift
//  mala-ios
//
//  Created by 王新宇 on 11/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

class MemberLoginCell: MalaBaseMemberCardCell {

    // MARK: - Components
    
    
    // MARK: - Instance Method
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Method
    private func setup() {
        setupDefaultStyle(image: .noteNormal,
                          disabledImage: .noteNormal,
                          title: "登录可查看错题本和学习报告哦！",
                          disabledTitle: "学习报告数据获取失败！",
                          buttonTitle: "立即登录")
        actionButton.addTarget(self, action: #selector(MemberLoginCell.buttonDidTap), for: .touchUpInside)
    }
    
    @objc private func buttonDidTap() {
        state = .loading
        MemberPrivilegesViewController.shared.login { 
            self.state = .normal
        }
    }
}
