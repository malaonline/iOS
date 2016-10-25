//
//  ThemeHorizontalBarChartView.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/26.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

open class ThemeHorizontalBarChartView: UIView {

    // MARK: - Property
    /// 数据
    var vals: [ThemeHorizontalBarData] = [] {
        didSet{
            DispatchQueue.main.async(execute: { [weak self] () -> Void in
                self?.setupData()
            })
        }
    }
    
    
    // MARK: - Components
    /// 条形视图数组
    var bars: [ThemeHorizontalBar] = []
    
    
    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupData() {
        
        for (index, data) in vals.enumerated() {
           
            let bar = ThemeHorizontalBar()
            self.addSubview(bar)
            
            bar.snp.makeConstraints({ (maker) in
                maker.height.equalTo(16)
                maker.top.equalTo(self).offset(((index*2)+1)*16)
                maker.left.equalTo(self)
                maker.right.equalTo(self)
            })
            
            bar.data = data
            bars.append(bar)
        }
    }
    
    ///  移除所有图表
    func removeAllCharts() {
        for chart in bars {
            chart.removeFromSuperview()
        }
    }
}


open class ThemeHorizontalBar: UIView {
    
    // MARK: - Property
    /// 数据
    var data: ThemeHorizontalBarData = ThemeHorizontalBarData() {
        didSet {
            titleLabel.text = data.title
            progressBar.progressTintColors = [data.color]
            
            var percent: CGFloat = 0
            if data.totalNum != 0 {
                percent = CGFloat(data.rightNum)/CGFloat(data.totalNum)
                percentLabel.text = String(format: "%d%%", Int(percent*100))
                progressBar.setProgress(percent, animated: false)
            }
            progressBar.rightNum = data.rightNum
            progressBar.totalNum = data.totalNum
        }
    }
    
    
    // MARK: - Components
    /// 数据标题标签
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "",
            fontSize: 11,
            textColor: MalaColor_939393_0
        )
        return label
    }()
    /// 条形图
    private lazy var progressBar: YLProgressBar = {
        let bar = YLProgressBar()
        bar.indicatorTextDisplayMode = .progress
        bar.behavior = .indeterminate
        bar.stripesOrientation = .left
        bar.progressTintColor = MalaColor_E5E5E5_0
        bar.trackTintColor = MalaColor_E5E5E5_0
        bar.stripesColor = MalaColor_E5E5E5_0
        bar.progressTintColors = [MalaColor_75CC97_0]
        bar.indicatorTextLabel.font = UIFont(name: "HelveticaNeue-Light", size: 9)
        bar.hideGloss = true
        return bar
    }()
    /// 百分比标签
    private lazy var percentLabel: UILabel = {
        let label = UILabel(
            text: "",
            fontSize: 10,
            textColor: MalaColor_97A8BB_0
        )
        label.textAlignment = .right
        return label
    }()
    
    
    // MARK: - Instance Method
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
        self.addSubview(titleLabel)
        self.addSubview(progressBar)
        self.addSubview(percentLabel)
        
        // AutoLayout
        titleLabel.snp.makeConstraints { (maker) in
            maker.width.equalTo(56)
            maker.left.equalTo(self)
            maker.right.equalTo(progressBar.snp.left).offset(-8)
            maker.height.equalTo(self)
            maker.centerY.equalTo(self)
        }
        progressBar.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self)
            maker.left.equalTo(titleLabel.snp.right).offset(8)
            maker.right.equalTo(percentLabel.snp.left).offset(-8)
            maker.height.equalTo(self)
        }
        percentLabel.snp.makeConstraints { (maker) in
            maker.width.equalTo(34)
            maker.right.equalTo(self)
            maker.left.equalTo(progressBar.snp.right).offset(8)
            maker.height.equalTo(self)
            maker.centerY.equalTo(self)
        }
    }
}


open class ThemeHorizontalBarData: NSObject {
    
    // MARK: - Property
    var title: String = ""
    var color: UIColor = UIColor.white
    var rightNum: Int = 0
    var totalNum: Int = 0
    
    
    // MARK: - Instance Method
    override init() {
        super.init()
    }
    
    convenience init(title: String, color: UIColor, rightNum: Int, totalNum: Int) {
        self.init()
        self.title = title
        self.color = color
        self.rightNum = rightNum
        self.totalNum = totalNum
    }
}
