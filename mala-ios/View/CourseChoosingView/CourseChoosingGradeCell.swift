//
//  CourseChoosingGradeCell.swift
//  mala-ios
//
//  Created by 王新宇 on 1/22/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class CourseChoosingGradeCell: MalaBaseCell {
    
    // MARK: - Property
    var prices: [GradeModel]? = [] {
        didSet {
            self.collectionView.prices = prices
            var collectionRow = CGFloat(Int(prices?.count ?? 0)/2)
            collectionRow = (prices?.count ?? 0)%2 == 0 ? collectionRow : collectionRow + 1
            let collectionHeight = (MalaLayout_GradeSelectionWidth*0.20) * collectionRow + (14*(collectionRow-1))
            collectionView.snp.updateConstraints({ (maker) -> Void in
                maker.height.equalTo(collectionHeight)
            })
        }
    }
    
    
    // MARK: - Compontents
    private lazy var collectionView: GradeSelectCollectionView = {
        let collectionView = GradeSelectCollectionView(
            frame: CGRect.zero,
            collectionViewLayout: CommonFlowLayout(type: .gradeSelection)
        )
        return collectionView
    }()
    
    // MARK: - Contructed
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
        adjustForCourseChoosing()
        
        // SubViews
        content.addSubview(collectionView)
        
        // Autolayout
        content.snp.updateConstraints { (maker) -> Void in
            maker.top.equalTo(headerView.snp.bottom).offset(14)
        }
        collectionView.snp.makeConstraints({ (maker) -> Void in
            maker.top.equalTo(content)
            maker.left.equalTo(content)
            maker.right.equalTo(content)
            maker.bottom.equalTo(content)
            maker.height.equalTo(10)
        })
    }
}


// MARK: - GradeSelectCollectionView
private let GradeSelectionCellReuseId = "GradeSelectionCellReuseId"
class GradeSelectCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Property
    /// 年级价格数据模型
    var prices: [GradeModel]? = [] {
        didSet {
            self.reloadData()
        }
    }
    /// 当前选择项IndexPath标记
    private var currentSelectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    
    // MARK: - Constructed
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func configure() {
        dataSource = self
        delegate = self
        backgroundColor = UIColor.white
        isScrollEnabled = false
        
        register(GradeSelectionCell.self, forCellWithReuseIdentifier: GradeSelectionCellReuseId)
    }
    
    
    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GradeSelectionCell
        
        // 选中当前选择Cell，并取消其他Cell选择
        cell.isSelected = true
        (collectionView.cellForItem(at: currentSelectedIndexPath)?.isSelected = false)
        currentSelectedIndexPath = indexPath
    }
    
    
    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prices?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GradeSelectionCellReuseId, for: indexPath) as! GradeSelectionCell
        cell.grade = prices?[indexPath.row]
        // 选中当前选择项
        if indexPath == currentSelectedIndexPath {
            cell.isSelected = true
            MalaOrderOverView.gradeName = cell.grade?.name
        }
        return cell
    }
}


// MARK: - GradeSelectionCell
class GradeSelectionCell: UICollectionViewCell {
    
    // MARK: - Property
    var grade: GradeModel? {
        didSet {
            let title = String(format: "%@  %@/小时", (grade?.name) ?? "", (grade?.prices?[0].price.money) ?? "")
            self.button.setTitle(title, for: .normal)
        }
    }
    override var isSelected: Bool {
        didSet {
            self.button.isSelected = isSelected
            if isSelected {
                NotificationCenter.default.post(name: MalaNotification_ChoosingGrade, object: self.grade!)
            }
        }
    }
    
    // MARK: - Compontents
    private lazy var button: UIButton = {
        let button = UIButton(
            title: "年级——价格",
            borderColor: UIColor(named: .ThemeBlue),
            target: self,
            action: nil,
            borderWidth: 1
        )
        button.isUserInteractionEnabled = false
        return button
    }()
    
    // MARK: - Constructed
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
        contentView.addSubview(button)
        
        // Autolayout
        button.snp.makeConstraints({ (maker) -> Void in
            maker.top.equalTo(contentView)
            maker.left.equalTo(contentView)
            maker.right.equalTo(contentView)
            maker.bottom.equalTo(contentView)
        })
    }
}
