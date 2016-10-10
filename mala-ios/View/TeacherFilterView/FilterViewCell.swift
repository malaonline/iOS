//
//  FilterViewCell.swift
//  mala-ios
//
//  Created by Elors on 12/23/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

open class FilterViewCell: UICollectionViewCell {
    
    // MARK: - Property
    /// Cell所属indexPath
    var indexPath = IndexPath(item: 0, section: 0)
    /// 筛选条件数据模型
    var model: GradeModel = GradeModel() {
        didSet{
            self.button.setTitle(model.name, for: UIControlState())
            self.tag = model.id
        }
    }
    /// 选中状态
    override open var isSelected: Bool {
        didSet {
            button.isSelected = isSelected
        }
    }
    
    
    // MARK: - Components
    private lazy var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(MalaColor_939393_0, for: UIControlState())
        button.setTitle("小学一年级", for: UIControlState())
        button.setImage(UIImage(named: "radioButton_normal"), for: UIControlState())
        button.setImage(UIImage(named: "radioButton_selected"), for: .selected)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: -12)
        button.sizeToFit()
        // 冻结按钮交互功能，其只作为视觉显示效果使用
        button.isUserInteractionEnabled = false
        return button
    }()

    
    // MARK: - Constructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserInterface()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // SubViews
        contentView.addSubview(button)
        
        // AutoLayout
        button.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.left.equalTo(self.contentView.snp_left).offset(4)
        }
    }
}
