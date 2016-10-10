//
//  ThemePhotoCollectionView.swift
//  mala-ios
//
//  Created by 王新宇 on 16/7/6.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let ThemePhotoCollectionViewCellReuseId = "ThemePhotoCollectionViewCellReuseId"

class ThemePhotoCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Property
    /// 图片URL数组
    var urls: [String] = [] {
        didSet {
            reloadData()
        }
    }
    
    
    // MARK: - Instance Method
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func configure() {
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = UIColor.white
        register(ThemePhotoCollectionViewCell.self, forCellWithReuseIdentifier: ThemePhotoCollectionViewCellReuseId)
    }
    
    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThemePhotoCollectionViewCellReuseId, for: indexPath) as! ThemePhotoCollectionViewCell
        cell.url = urls[(indexPath as NSIndexPath).row]
        cell.imageView.tag = (indexPath as NSIndexPath).row
        return cell
    }
    
    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ThemePhotoCollectionViewCell
        NotificationCenter.default.post(name: Notification.Name(rawValue: MalaNotification_PushPhotoBrowser), object: cell.imageView)
    }
}


class ThemePhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    /// 图片URL
    var url: String = "" {
        didSet {
            imageView.ma_setImage(URL(string: url))
        }
    }
    
    
    // MARK: - Components
    /// 图片视图
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView.placeHolder()
        return imageView
    }()
    
    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // SubViews
        contentView.addSubview(imageView)
        
        // Autolayout
        imageView.snp.makeConstraints { (maker) in
            maker.center.equalTo(contentView)
            maker.size.equalTo(contentView)
        }
    }
}
