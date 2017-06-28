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
            guard let model = model else { return }
            lecturerNameLabel.text = model.lecturerName
            lecturerAvatar.setImage(withURL: model.lecturerAvatar)
            lecturerBioView.text = model.lecturerBio?.trim().replacingOccurrences(of: ";", with: "\n")
            
            if (UIDevice.current.isPlus && model.lecturerBio?.characters.count > 123)
            || (!UIDevice.current.isPlus && model.lecturerBio?.characters.count > 91) {
                lecturerAvatar.snp.remakeConstraints { (maker) in
                    maker.top.equalTo(content).offset(10)
                    maker.left.equalTo(content)
                    maker.width.equalTo(97)
                    maker.height.equalTo(126)
                }
            }else {
                lecturerBioView.snp.remakeConstraints { (maker) in
                    maker.top.equalTo(content)
                    maker.left.equalTo(content)
                    maker.right.equalTo(content)
                }
            }
        }
    }
    
    
    // MARK: - Components
    /// 讲师姓名
    private lazy var lecturerNameLabel: UILabel = {
        let label = UILabel(
            text: "老师姓名",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor.white,
            textAlignment: .center,
            backgroundColor: UIColor(named: .themeBlue)
        )
        return label
    }()
    /// 主讲资历
    private lazy var lecturerBioView: UITextView = {
        let textView = UITextView()
        textView.font = FontFamily.PingFangSC.Regular.font(14)
        textView.textColor = UIColor(named: .ArticleTitle)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        let bezierPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 96+12, height: 126+2))
        textView.textContainer.exclusionPaths = [bezierPath]
        return textView
    }()
    /// 老师头像
    private lazy var lecturerAvatar: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(x: 0, y: 0, width: 97, height: 126),
            cornerRadius: 6,
            image: "avatar_placeholder"
        )
        imageView.enableOneTapToLaunchPhotoBrowser()
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
        // SubViews
        content.addSubview(lecturerBioView)
        content.addSubview(lecturerAvatar)
        lecturerAvatar.addSubview(lecturerNameLabel)
        
        // Autolayout
        lecturerBioView.snp.makeConstraints { (maker) in
            maker.top.equalTo(content)
            maker.left.equalTo(content)
            maker.right.equalTo(content)
            maker.bottom.equalTo(content)
        }
        lecturerAvatar.snp.makeConstraints { (maker) in
            maker.top.equalTo(content).offset(10)
            maker.left.equalTo(content)
            maker.width.equalTo(97)
            maker.height.equalTo(126)
            maker.bottom.equalTo(content).offset(-10)
        }
        lecturerNameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(lecturerAvatar)
            maker.right.equalTo(lecturerAvatar)
            maker.bottom.equalTo(lecturerAvatar)
            maker.height.equalTo(27)
        }

    }
}
