//
//  ProfileItemCollectionView.swift
//  mala-ios
//
//  Created by 王新宇 on 16/6/13.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let ProfileItemCollectionViewCellReuseId = "ProfileItemCollectionViewCellReuseId"

class ProfileItemCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Property
    var model: [ProfileElementModel]? {
        didSet {
            self.reloadData()
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
        backgroundColor = UIColor.white
        bounces = false
        isScrollEnabled = false
        register(ProfileItemCollectionViewCell.self, forCellWithReuseIdentifier: ProfileItemCollectionViewCellReuseId)
    }
    
    
    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 所有操作结束弹栈时，取消选中项
        defer {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        
        if let model = model?[indexPath.row] {
            NotificationCenter.default.post(name: MalaNotification_PushProfileItemController, object: model)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // MARK: - DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.count ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileItemCollectionViewCellReuseId, for: indexPath) as! ProfileItemCollectionViewCell
        cell.model = model?[indexPath.row]
        return cell
    }
}
