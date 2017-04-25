//
//  MAFeatureView.swift
//  mala-ios
//
//  Created by 王新宇 on 24/04/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

private let MAFeatureViewCellReuseId = "MAFeatureViewCellReuseId"

class MAFeatureView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    enum FeatureViewState {
        case login
        case sign
    }
    
    // MARK: - Model
    var models: [IntroductionModel] = MalaConfig.featureViewData() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Components
    var state: FeatureViewState = .sign {
        didSet {
            switch state {
            case .login:
                button.setBackgroundImage(UIImage(asset: .buttonBlueNormal), for: .normal)
                button.setBackgroundImage(UIImage(asset: .buttonBluePress), for: .highlighted)
                button.setBackgroundImage(UIImage(asset: .buttonBluePress), for: .selected)
                button.setTitle("去登录", for: .normal)
            case .sign:
                button.setBackgroundImage(UIImage(asset: .buttonRedNormal), for: .normal)
                button.setBackgroundImage(UIImage(asset: .buttonRedPress), for: .highlighted)
                button.setBackgroundImage(UIImage(asset: .buttonRedPress), for: .selected)
                button.setTitle("去报名", for: .normal)
            }
        }
    }
    private lazy var container: UIView = {
        let view = UIView(UIColor.clear)
        return view
    }()
    private lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.numberOfPages = self.models.count
        page.pageIndicatorTintColor = UIColor(named: .pageControlGray)
        page.currentPageIndicatorTintColor = UIColor(named: .themeBlue)
        page.addTarget(self, action: #selector(MAFeatureView.pageControlDidChangeCurrentPage(_:)), for: .valueChanged)
        return page
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CommonFlowLayout(type: .featureView))
        collectionView.backgroundColor = UIColor(named: .themeLightBlue)
        collectionView.layer.cornerRadius = 8
        collectionView.layer.masksToBounds = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.register(MAFeatureViewCell.self, forCellWithReuseIdentifier: MAFeatureViewCellReuseId)
        return collectionView
    }()
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("去报名", for: .normal)
        button.titleLabel?.font = FontFamily.PingFangSC.Regular.font(18)
        button.setBackgroundImage(UIImage(asset: .buttonRedNormal), for: .normal)
        button.setBackgroundImage(UIImage(asset: .buttonRedPress), for: .highlighted)
        button.setBackgroundImage(UIImage(asset: .buttonRedPress), for: .selected)
        return button
    }()

    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserInterface()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private
    private func setupUserInterface() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // style
        container.layer.shadowColor = UIColor(named: .themeShadowBlue).cgColor
        container.layer.shadowRadius = 8
        container.layer.shadowOffset = CGSize(width: 4, height: 4)
        container.layer.shadowOpacity = 1.0
        
        // subviews
        addSubview(container)
        container.addSubview(collectionView)
        container.addSubview(pageControl)
        container.addSubview(button)
        
        // layout
        container.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self)
            maker.centerY.equalTo(self)//.offset(20)
            maker.width.equalTo(320)
            maker.height.equalTo(415)
        }
        collectionView.snp.makeConstraints { (maker) in
            maker.center.equalTo(container)
            maker.size.equalTo(container)
        }
        pageControl.snp.makeConstraints { (maker) in
            maker.width.equalTo(container)
            maker.centerX.equalTo(container)
            maker.bottom.equalTo(container).offset(-100)
            maker.height.equalTo(10)
        }
        button.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(container)
            maker.bottom.equalTo(container).offset(-25)
        }
    }
    
    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MAFeatureViewCellReuseId, for: indexPath) as! MAFeatureViewCell
        cell.model = self.models[indexPath.row]
        return cell
    }

    // MARK: - Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging || scrollView.isDecelerating {
            let page = scrollView.contentOffset.x / scrollView.bounds.width
            pageControl.currentPage = Int(page)
        }
    }
    
    
    // MARK: - Event Response
    func pageControlDidChangeCurrentPage(_ pageControl: PageControl) {
        collectionView.setContentOffset(CGPoint(x: collectionView.bounds.width * CGFloat(pageControl.currentPage), y: 0), animated: true)
    }
}
