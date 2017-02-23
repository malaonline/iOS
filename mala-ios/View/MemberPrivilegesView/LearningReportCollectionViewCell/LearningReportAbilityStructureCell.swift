//
//  LearningReportAbilityStructureCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/19.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit
import Charts

class LearningReportAbilityStructureCell: MalaBaseReportCardCell {
    
    // MARK: - Property
    /// 能力结构数据
    private var model: [SingleAbilityData] = MalaConfig.abilitySampleData() {
        didSet {
            resetData()
        }
    }
    override var asSample: Bool {
        didSet {
            if asSample {
                model = MalaConfig.abilitySampleData()
            }else {
                hideDescription()
                model = MalaSubjectReport.abilities
            }
        }
    }
    
    
    // MARK: - Components
    /// 雷达图
    private lazy var radarChartView: RadarChartView = {
        let radarChartView = RadarChartView()
        
        radarChartView.animate(xAxisDuration: 0.65)
        radarChartView.chartDescription?.text = ""
        radarChartView.webLineWidth = 1
        radarChartView.innerWebLineWidth = 1
        radarChartView.webAlpha = 1
        radarChartView.rotationEnabled = false
        radarChartView.legend.enabled = false
        radarChartView.innerWebColor = UIColor(named: .ChartRadarInner)
        radarChartView.webColor = UIColor(named: .ChartRadarInner)
        
        let xAxis = radarChartView.xAxis
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        xAxis.labelTextColor = UIColor(named: .ChartLabel)
        xAxis.labelWidth = 20
        xAxis.valueFormatter = IndexAxisValueFormatter(values: self.getXVals())
        
        let yAxis = radarChartView.yAxis
        yAxis.enabled = false
        yAxis.axisMinimum = 0

        return radarChartView
    }()
    
    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupUserInterface()
        resetData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func configure() {
        titleLabel.text = "能力结构分析"
        descDetailLabel.text = "学生运算求解能力很强，空间想象和数据分析能力较弱，应加强针对性练习，实际应用能力也需注意引导。"
    }
    
    private func setupUserInterface() {
        // SubViews
        layoutView.addSubview(radarChartView)
        
        // Autolayout
        radarChartView.snp.makeConstraints { (maker) in
            maker.top.equalTo(layoutView.snp.bottom).multipliedBy(0.18)
            maker.left.equalTo(descView)
            maker.right.equalTo(descView)
            maker.bottom.equalTo(layoutView).multipliedBy(0.68)
        }
    }
    
    // 设置样本数据
    private func setupSampleData() {
        
    }
    
    // 重置数据
    private func resetData() {
        
        var index = -1
        // 数据
        let entries = model.map { (data) -> RadarChartDataEntry in
            index += 1
            return RadarChartDataEntry(value: Double(data.val))
        }
        
        // 设置UI
        let dataSet = RadarChartDataSet(values: entries, label: "")
        dataSet.lineWidth = 0
        dataSet.fillAlpha = 0.9
        dataSet.setColor(UIColor(named: .ChartRed))
        dataSet.fillColor = UIColor(named: .ChartRed)
        dataSet.drawValuesEnabled = false
        dataSet.drawFilledEnabled = true
        dataSet.highlightEnabled = false
        
        let data = RadarChartData(dataSets: [dataSet])
        data.setValueFont(UIFont.systemFont(ofSize: 10))
        data.setDrawValues(false)
        radarChartView.data = data
    }
    
    // 获取X轴文字信息
    private func getXVals() -> [String] {
        var xVals = [String]()
        for (index, data) in model.enumerated() {
            var abilityString = data.abilityString
            if index == 1 || index == 2 {
                abilityString = "   "+abilityString
            }else if index == 4 || index == 5 {
                abilityString = abilityString+"   "
            }
            xVals.append(abilityString)
        }
        return xVals
    }
    
    override func hideDescription() {
        descDetailLabel.text = "红色区域越接近最外边对应的能力越强， 通过直观的方式，了解学生思考问题的方式，对弱势项进行引导。"
    }
}
