//
//  MemberNoteCell.swift
//  mala-ios
//
//  Created by 王新宇 on 11/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

class MemberNoteCell: MalaBaseMemberCardCell {

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
                          disabledImage: .noteDisable,
                          title: "你课中答错的题目会出现在这里哦！",
                          disabledTitle: "错题本数据获取失败！",
                          buttonTitle: "查看错题本样本")
        actionButton.addTarget(self, action: #selector(MemberNoteCell.buttonDidTap), for: .touchUpInside)
    }
    
    @objc private func buttonDidTap() {
        MemberPrivilegesViewController.shared.login()
    }
}
