//
//  CourseTableViewSectionHeader.swift
//  mala-ios
//
//  Created by 王新宇 on 16/6/14.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit
import DateToolsSwift

class CourseTableViewSectionHeader: UITableViewHeaderFooterView {

    // MARK: - Property
    /// 日期数据
    var timeInterval: TimeInterval? = 0 {
        didSet {
            /// 同年日期仅显示月份，否则显示年月
            let formatter = Date(timeIntervalSince1970: timeInterval ?? 0).year == Date().year ? "M月" : "yyyy年M月"
            dateLabel.text = getDateString(timeInterval, format: formatter)
        }
    }
    /// 所属TableView
    var parentTableView: UITableView? {
        didSet {
            offset = parentTableView?.contentOffset.y ?? 0
        }
    }
    /// 高度比率, 应属于[1, 2], 默认为1.5
    var parallaxRatio: CGFloat = 2 {
        didSet {
            parallaxRatio = max(parallaxRatio, 1.0)
            parallaxRatio = min(parallaxRatio, 2.0)
            
            var rect = self.bounds
            rect.size.height = rect.size.height*parallaxRatio
            parallaxImage.frame = rect
            updateParallaxOffset()
        }
    }
    var defaultOffset: CGFloat = 700
    var offset: CGFloat = 0
    
    
    // MARK: - Components
    /// 视差图片
    lazy var parallaxImage: UIImageView = {
        let imageView = UIImageView(imageName: "course_header")
        imageView.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    /// 时间文本标签
    private lazy var dateLabel: UILabel = {
        let label = UILabel(
            text: "",
            fontSize: 20,
            textColor: UIColor.black
        )
        return label
    }()
    
    // MARK: - Constructed
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private
    private func setupUserInterface() {
        // Style
        contentView.clipsToBounds = true
        
        // SubViews
        contentView.addSubview(parallaxImage)
        contentView.sendSubview(toBack: parallaxImage)
        contentView.addSubview(dateLabel)
        
        // AutoLayout
        dateLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(20)
            maker.left.equalTo(contentView).offset(70)
            maker.bottom.equalTo(contentView).offset(-20)
        }
        
        // 确保图片宽度与屏幕保持一致（仅需在初始化后）
        updateParallaxOffset()
        parallaxImage.frame.size.width = MalaScreenWidth
    }
    
    ///  添加观察者
    private func safeAddObserver() {
        if let tableView = parentTableView {
            tableView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        }
    }
    
    ///  移除观察者
    private func safeRemoveObserver() {
        if let tableView = parentTableView {
            tableView.removeObserver(self, forKeyPath: "contentOffset", context: nil)
        }
    }
    
    ///  将从父视图中移除
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        safeRemoveObserver()
        
        var view = newSuperview
        
        while (view != nil) {
            if view is UITableView {
                parentTableView = view as? UITableView
                break
            }
            view = view?.superview
        }
        safeAddObserver()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = keyPath, key == "contentOffset" {
            self.updateParallaxOffset()
        }
    }
    
    ///  移除父视图
    override func removeFromSuperview() {
        super.removeFromSuperview()
        safeRemoveObserver()
    }
    
    ///  更新图片视差偏移量
    private func updateParallaxOffset() {

        let contentOffset = defaultOffset + (parentTableView?.contentOffset.y ?? 0) - offset
        let cellOffset = contentView.frame.origin.y - (contentOffset)
        let contentViewHeight: CGFloat = 140

        let percent = (cellOffset + contentViewHeight)/((parentTableView?.frame.size.height ?? (MalaScreenHeight-64)) + contentViewHeight)
        let extraHeight = contentViewHeight*(parallaxRatio-1)
        
        var rect = contentView.frame
        rect.size.width = MalaScreenWidth
        rect.size.height = 420
        // println("0000 - \(-extraHeight*percent-210)")
        rect.origin.y = -extraHeight*percent-210
        // println("Frame - \(rect) - \(extraHeight) - \(percent) - \(parentTableView?.contentOffset.y)")
        parallaxImage.frame = rect
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        offset = parentTableView?.contentOffset.y ?? 0
        
        let contentOffset = defaultOffset + (parentTableView?.contentOffset.y ?? 0) - offset
        let cellOffset = contentView.frame.origin.y - (contentOffset)
        let percent = (cellOffset + contentView.frame.size.height)/((parentTableView?.frame.size.height ?? 1) + contentView.frame.size.height)
        let extraHeight = contentView.frame.size.height*(parallaxRatio-1)
        parallaxImage.frame.origin.y = -extraHeight*percent-210
    }
    
    
    deinit {
        safeRemoveObserver()
    }
}
