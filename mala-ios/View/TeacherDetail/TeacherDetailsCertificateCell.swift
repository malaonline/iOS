//
//  TeacherDetailsCertificateCell.swift
//  mala-ios
//
//  Created by Elors on 1/5/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class TeacherDetailsCertificateCell: MalaBaseCell {

    // MARK: - Property
    var models: [AchievementModel?] = [] {
        didSet {
            guard models.count != oldValue.count else { return }
            
            /// 解析数据
            for model in models {
                self.labels.append("  "+(model?.title ?? "默认证书"))
                let photo = SKPhoto.photoWithImageURL(model?.img?.absoluteString ?? "")
                photo.caption = model?.title ?? "默认证书"
                images.append(photo)
            }
            tagsView.labels = self.labels
        }
    }
    var labels: [String] = []
    var images: [SKPhoto] = []
    
    
    // MARK: - Components
    /// 标签容器
    lazy var tagsView: TagListView = {
        let tagsView = TagListView(frame: CGRect(x: 0, y: 0, width: MalaLayout_CardCellWidth, height: 0))
        tagsView.labelBackgroundColor = MalaColor_FCDFB7_0
        tagsView.textColor = MalaColor_EF8F1D_0
        tagsView.iconName = "image_icon"
        tagsView.commonTarget = self
        tagsView.commonAction = #selector(TeacherDetailsCertificateCell.tagDidTap(_:))
        return tagsView
    }()

    
    // MARK: - Constructed
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func configure() {
        
        content.addSubview(tagsView)
        content.snp.updateConstraints { (maker) -> Void in
            maker.bottom.equalTo(contentView).offset(-10)
        }
        tagsView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(content)
            maker.left.equalTo(content)
            maker.width.equalTo(MalaLayout_CardCellWidth)
            maker.bottom.equalTo(content)
        }
    }
    
    
    // MARK: - Delegate
    ///  标签点击事件
    func tagDidTap(_ sender: UITapGestureRecognizer) {
        
        /// 图片浏览器
        if let index = sender.view?.tag {
            SKPhotoBrowserOptions.displayStatusbar = false
            SKPhotoBrowserOptions.enableSingleTapDismiss = true
            SKPhotoBrowserOptions.displayAction = false
            SKPhotoBrowserOptions.bounceAnimation = false
            SKPhotoBrowserOptions.displayDeleteButton = false
            SKPhotoBrowserOptions.displayBackAndForwardButton = false
            
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(index)
            browser.navigationController?.isNavigationBarHidden = true
            NotificationCenter.default.post(name: MalaNotification_PushPhotoBrowser, object: browser)
        }
    }
}
