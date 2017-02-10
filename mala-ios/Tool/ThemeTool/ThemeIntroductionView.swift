//
//  ThemeIntroductionView.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/18.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private let ThemeIntroductionViewCellReuseId = "ThemeIntroductionViewCellReuseId"

class ThemeIntroductionView: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Property
    /// 会员专享服务数据模型
    var model: [IntroductionModel] = MalaConfig.memberServiceData() {
        didSet {
            collectionView.reloadData()
        }
    }
    /// 当前下标
    var index: Int?

    
    // MARK: - Components
    /// 页数指示器
    private lazy var pageControl: PageControl = {
        let pageControl = PageControl()
        return pageControl
    }()
    /// 轮播视图
    private lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: MalaScreenWidth, height: MalaScreenHeight-MalaScreenNaviHeight)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: ThemeIntroductionFlowLayout(frame: frame))
        return collectionView
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
        configure()
        delay(0.05) {
            if let i = self.index {
                self.collectionView.scrollToItem(at: IndexPath(item: i, section: 0), at: [], animated: false)
                self.pageControl.setCurrentPage(CGFloat(i), animated: false)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Private method
    private func configure() {
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ThemeIntroductionViewCell.self, forCellWithReuseIdentifier: ThemeIntroductionViewCellReuseId)
        
        pageControl.numberOfPages = model.count
        pageControl.addTarget(self, action: #selector(ThemeIntroductionView.pageControlDidChangeCurrentPage(_:)), for: .valueChanged)
    }
    
    private func setupUserInterface() {
        // Style
        collectionView.backgroundColor = UIColor.white
        pageControl.tintColor = UIColor(named: .PageControl)
        
        // SubViews
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        
        // Autolayout
        collectionView.snp.makeConstraints { (maker) in
            maker.center.equalTo(view)
            maker.size.equalTo(view)
        }
        pageControl.snp.makeConstraints { (maker) in
            maker.width.equalTo(200)
            maker.centerX.equalTo(view)
            maker.bottom.equalTo(view).offset(-20)
            maker.height.equalTo(10)
        }
    }
    
    
    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThemeIntroductionViewCellReuseId, for: indexPath) as! ThemeIntroductionViewCell
        cell.model = self.model[indexPath.row]
        return cell
    }
    
    
    // MARK: - Delegate
    
    
    // MARK: - Event Response
    func pageControlDidChangeCurrentPage(_ pageControl: PageControl) {
        collectionView.setContentOffset(CGPoint(x: collectionView.bounds.width * CGFloat(pageControl.currentPage), y: 0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging || scrollView.isDecelerating {
            let page = scrollView.contentOffset.x / scrollView.bounds.width
            pageControl.setCurrentPage(page)
        }
    }
}


class ThemeIntroductionViewCell: UICollectionViewCell {
    // MARK: - Property
    /// 会员专享模型
    var model: IntroductionModel? {
        didSet {
            imageView.image = UIImage(named: (model?.image?.rawValue ?? "") + "_detail")
            titleLabel.text = model?.title
            detailLabel.text = model?.subTitle
        }
    }
    
    
    // MARK: - Compontents
    /// 布局容器
    private lazy var layoutView: UIView = {
        let view = UIView()
        return view
    }()
    /// 图片
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    /// 标题标签
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "简介标题",
            fontSize: 16,
            textColor: UIColor(named: .PageControl)
        )
        label.textAlignment = .center
        return label
    }()
    /// 简介内容标签
    private lazy var detailLabel: UILabel = {
        let label = UILabel(
            text: "简介内容",
            fontSize: 14,
            textColor: UIColor(named: .PageControl)
        )
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
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
        // Style
        
        // SubViews
        contentView.addSubview(layoutView)
        layoutView.addSubview(imageView)
        layoutView.addSubview(titleLabel)
        layoutView.addSubview(detailLabel)
        
        // Autolayout
        layoutView.snp.makeConstraints { (maker) in
            maker.center.equalTo(contentView)
            maker.width.equalTo(contentView)
            maker.height.equalTo(contentView).multipliedBy(0.75)
        }
        imageView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(layoutView).offset(40)
            maker.centerX.equalTo(contentView)
            maker.width.equalTo(217)
            maker.height.equalTo(183)
        }
        titleLabel.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(imageView)
            maker.height.equalTo(16)
            maker.top.equalTo(imageView.snp.bottom).offset(30)
        }
        detailLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(25)
            maker.centerX.equalTo(imageView)
            maker.width.equalTo(200)
        }
    }
}

class ThemeIntroductionFlowLayout: UICollectionViewFlowLayout {
    
    private var frame = CGRect.zero
    
    
    // MARK: - Instance Method
    init(frame: CGRect) {
        super.init()
        self.frame = frame
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func configure() {
        scrollDirection = .horizontal
        itemSize = frame.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
}
