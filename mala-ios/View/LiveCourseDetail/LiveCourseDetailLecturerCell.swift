//
//  LiveCourseDetailLecturerCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/20.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class LiveCourseDetailLecturerCell: MalaBaseLiveCourseCell {
    
    // MARK: - Property
    /// 课程模型
    var model: LiveClassModel? {
        didSet{
            guard let model = model else {
                return
            }
            
            lecturerNameLabel.text = model.lecturerName
            lecturerBioView.text = model.lecturerBio?.trim().replacingOccurrences(of: ";", with: "\n")
            lecturerAvatar.setImage(withURL: model.lecturerAvatar, placeholderImage: "avatar_placeholder")
        }
    }
    
    
    // MARK: - Components
    /// 主讲图标
    private lazy var lecturerIcon: UIImageView = {
        let imageView = UIImageView(image: "live_lecturer")
        return imageView
    }()
    /// 讲师姓名
    private lazy var lecturerNameLabel: UILabel = {
        let label = UILabel(
            text: "老师姓名",
            font: UIFont(name: "PingFang-SC-Light", size: 15),
            textColor: MalaColor_9BC3E1_0
        )
        return label
    }()
    /// 主讲资历
    private lazy var lecturerBioView: UILabel = {
        let label = UILabel(
            text: "",
            font: UIFont(name: "STHeitiSC-Light", size: 14),
            textColor: MalaColor_939393_0
        )
        label.numberOfLines = 0
        return label
    }()
    /// 老师头像
    private lazy var lecturerAvatar: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(x: 0, y: 0, width: 56, height: 56),
            cornerRadius: 28,
            image: "avatar_placeholder"
        )
        return imageView
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
        content.addSubview(lecturerIcon)
        content.addSubview(lecturerNameLabel)
        content.addSubview(lecturerBioView)
        content.addSubview(lecturerAvatar)
        
        // Autolayout
        lecturerIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(content)
            maker.left.equalTo(content)
            maker.width.equalTo(15)
            maker.height.equalTo(15)
        }
        lecturerNameLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(lecturerIcon)
            maker.left.equalTo(lecturerIcon.snp.right).offset(6)
            maker.height.equalTo(15)
        }
        lecturerBioView.snp.makeConstraints { (maker) in
            maker.top.equalTo(lecturerNameLabel.snp.bottom).offset(12)
            maker.left.equalTo(lecturerNameLabel)
            maker.right.equalTo(lecturerAvatar.snp.left).offset(-18)
            maker.bottom.equalTo(content)
        }
        lecturerAvatar.snp.makeConstraints { (maker) in
            maker.right.equalTo(content)
            maker.centerY.equalTo(content)
            maker.height.equalTo(56)
            maker.width.equalTo(56)
        }
    }
}
