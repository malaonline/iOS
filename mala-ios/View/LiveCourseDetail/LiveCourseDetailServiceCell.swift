//
//  LiveCourseDetailServiceCell.swift
//  mala-ios
//
//  Created by 王新宇 on 2017/6/27.
//  Copyright © 2017年 Mala Online. All rights reserved.
//

import UIKit

private let LiveCourseDetailServiceCollectionViewCellReuseId = "LiveCourseDetailServiceCollectionViewCellReuseId"

class LiveCourseDetailServiceCell: MalaBaseLiveCourseCell, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Property
    /// 课程模型
    var models: [String] = MalaConfig.liveCourseSerivce() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    // MARK: - Comoponents
    /// 课程介绍
    private lazy var collectionView: LiveCourseDetailServiceCollectionView = {
        let collectionView = LiveCourseDetailServiceCollectionView(frame: CGRect.zero, collectionViewLayout: CommonFlowLayout(type: .liveCourseService))
        collectionView.register(LiveCourseDetailServiceCollectionViewCell.self, forCellWithReuseIdentifier: LiveCourseDetailServiceCollectionViewCellReuseId)
        collectionView.backgroundColor = UIColor.white
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
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
        content.addSubview(collectionView)
        
        // Autolayout
        collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(content).offset(10)
            maker.left.equalTo(content)
            maker.height.equalTo(34*3)
            maker.right.equalTo(content)
            maker.bottom.equalTo(content).offset(-10)
        }
    }
    
    // MARK: - Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveCourseDetailServiceCollectionViewCellReuseId, for: indexPath) as! LiveCourseDetailServiceCollectionViewCell
        cell.title = models[indexPath.row]
        return cell
    }
}

class LiveCourseDetailServiceCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class LiveCourseDetailServiceCollectionViewCell: UICollectionViewCell {
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private lazy var dotIcon: UIImageView = {
        let imageView = UIImageView(image: "check_right")
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "课程服务",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .protocolGary)
        )
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(dotIcon)
        contentView.addSubview(titleLabel)
        
        dotIcon.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView)
            maker.left.equalTo(contentView).offset(6)
            maker.height.equalTo(12)
            maker.width.equalTo(12)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(14)
            maker.top.equalTo(contentView).offset(10)
            maker.left.equalTo(dotIcon.snp.right).offset(7)
            maker.bottom.equalTo(contentView).offset(-10)
        }
    }
}
