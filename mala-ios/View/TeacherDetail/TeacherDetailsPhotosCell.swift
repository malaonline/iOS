//
//  TeacherDetailsPhotosCell.swift
//  mala-ios
//
//  Created by Elors on 1/5/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit
import Kingfisher

class TeacherDetailsPhotosCell: MalaBaseCell {

    // MARK: - Property
    /// 图片URL数组
    var photos: [String] = [] {
        didSet {
            // 加载图片URL数据
            photoCollection.urls = photos
        }
    }
    
    
    // MARK: - Components
    private lazy var detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rightArrow"), for: UIControlState())
        button.setTitle("更多", for: UIControlState())
        button.setTitleColor(MalaColor_939393_0, for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: -24)
        button.addTarget(self, action: #selector(TeacherDetailsPhotosCell.detailButtonDidTap), for: .touchUpInside)
        return button
    }()
    /// 图片滚动浏览视图
    private lazy var photoCollection: ThemePhotoCollectionView = {
        let collection = ThemePhotoCollectionView(frame: CGRect.zero, collectionViewLayout: CommonFlowLayout(type: .detailPhotoView))
        return collection
    }()
    
    
    // MARK: - Constructed
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
        headerView.addSubview(detailButton)
        content.addSubview(photoCollection)

        // Autolayout
        detailButton.snp.makeConstraints { (maker) -> Void in
            maker.height.equalTo(13)
            maker.right.equalTo(headerView).offset(-12)
            maker.centerY.equalTo(headerView)
        }
        content.snp.updateConstraints { (maker) -> Void in
            maker.top.equalTo(headerView.snp.bottom).offset(10)
            maker.left.equalTo(contentView)
            maker.right.equalTo(contentView)
            maker.bottom.equalTo(contentView).offset(-10)
        }
        photoCollection.snp.makeConstraints { (maker) in
            maker.left.equalTo(content)
            maker.right.equalTo(content)
            maker.top.equalTo(content)
            maker.height.equalTo(MalaLayout_DetailPhotoWidth)
            maker.bottom.equalTo(content)
        }
    }
 
    
    // MARK: - Events Response
    ///  查看相册按钮点击事件
    @objc private func detailButtonDidTap() {
        // 相册
        NotificationCenter.default.post(name: MalaNotification_PushPhotoBrowser, object: "browser")
    }
}
