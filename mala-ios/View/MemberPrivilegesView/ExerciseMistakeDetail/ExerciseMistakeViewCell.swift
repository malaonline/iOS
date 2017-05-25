//
//  ExerciseMistakeViewCell.swift
//  mala-ios
//
//  Created by 王新宇 on 15/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

class ExerciseMistakeViewCell: UICollectionViewCell {
    
    var index: Int = 0
    var amount: Int = 0
    var model: ExerciseMistakeRecord? {
        didSet {
            guard let model = model,
                  let group = model.exerciseGroup,
                  let exerc = model.exercise else { return }
            
            indexLabel.text = String(format: "%d/%d", index, amount)
            groupTitle.text = group.name
            remakeGroupTitleWidth()
            
            groupDesc.text = String(format: "【描述】%@", group.desc ?? "")
            exerciseLabel.text = String(format: "%d.%@", index, exerc.name ?? "")
            
            let options = exerc.options.sorted { $0.id < $1.id }
            var solutionString = "*"
            
            for (index, value) in options.enumerated() {
                switch index {
                case 0:
                    optionA.text = String(format: "A. %@", value.name ?? "")
                    
                    if value.id == exerc.solution {
                        optionA.textColor = UIColor(named: .solutionBlue)
                        solutionString = "A"
                    }else {
                        optionA.textColor = UIColor(named: .labelBlack)
                    }
                case 1:
                    optionB.text = String(format: "B. %@", value.name ?? "")
                    
                    if value.id == exerc.solution {
                        optionB.textColor = UIColor(named: .solutionBlue)
                        solutionString = "B"
                    }else {
                        optionB.textColor = UIColor(named: .labelBlack)
                    }
                case 2:
                    optionC.text = String(format: "C. %@", value.name ?? "")
                    
                    if value.id == exerc.solution {
                        optionC.textColor = UIColor(named: .solutionBlue)
                        solutionString = "C"
                    }else {
                        optionC.textColor = UIColor(named: .labelBlack)
                    }
                case 3:
                    optionD.text = String(format: "D. %@", value.name ?? "")
                    
                    if value.id == exerc.solution {
                        optionD.textColor = UIColor(named: .solutionBlue)
                        solutionString = "D"
                    }else {
                        optionD.textColor = UIColor(named: .labelBlack)
                    }
                default:
                    break
                }
            }
            
            solutionLabel.text = String(format: "【试题解析】答案%@", solutionString)
            explanationLabel.text = exerc.explanatioin
        }
    }
    
    
    // MARK: - Components
    /// container card
    lazy var content: UIView = {
        let view = UIView(UIColor.white)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    lazy var contentShadow: UIView = {
        let view = UIView(UIColor.clear)
        view.layer.shadowColor = UIColor(named: .themeShadowBlue).cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowOpacity = 1.0
        return view
    }()
    /// index
    private lazy var indexLabel: UILabel = {
        let label = UILabel(
            text: "1/5",
            font: FontFamily.PingFangSC.Regular.font(16),
            textColor: UIColor(named: .indexBlue),
            textAlignment: .right
        )
        return label
    }()
    /// exercise-group title
    private lazy var groupTitle: UILabel = {
        let label = UILabel(
            text: "2016中考 - 关系代词",
            font: FontFamily.PingFangSC.Regular.font(12),
            textColor: UIColor(named: .groupTitleGray),
            textAlignment: .center,
            opacity: 0.9,
            borderColor: UIColor(named: .protocolGary),
            borderWidth: 1.0,
            cornerRadius: 12
        )
        return label
    }()
    /// exercise-group description
    private lazy var groupDesc: UILabel = {
        let label = UILabel(
            text: "Sweet wormwood 青蒿是我国常见的植物．屠呦呦是用植物的特殊力量拯救数百万生命的女人．",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .protocolGary),
            textAlignment: .justified
        )
        label.numberOfLines = 0
        return label
    }()
    private lazy var separator1: UIView = {
        let line = UIView(UIColor(named: .themeLightBlue))
        return line
    }()
    private lazy var exerciseLabel: UILabel = {
        let label = UILabel(
            text: "2.The__________Brazil’s Olympic games will be held on August 5.\n_________exciting news for the long summer vacation!",
            font: FontFamily.PingFangSC.Semibold.font(16),
            textColor: UIColor(named: .labelBlack),
            textAlignment: .justified
        )
        label.numberOfLines = 0
        return label
    }()
    private lazy var optionA: UILabel = {
        let label = UILabel(
            text: "A． thirty-one; How a",
            font: FontFamily.PingFangSC.Semibold.font(16),
            textColor: UIColor(named: .labelBlack)
        )
        label.numberOfLines = 0
        return label
    }()
    private lazy var optionB: UILabel = {
        let label = UILabel(
            text: "B． thirty-first; What",
            font: FontFamily.PingFangSC.Semibold.font(16),
            textColor: UIColor(named: .labelBlack)
        )
        label.numberOfLines = 0
        return label
    }()
    private lazy var optionC: UILabel = {
        let label = UILabel(
            text: "C． thirty-first; What an",
            font: FontFamily.PingFangSC.Semibold.font(16),
            textColor: UIColor(named: .labelBlack)
        )
        label.numberOfLines = 0
        return label
    }()
    private lazy var optionD: UILabel = {
        let label = UILabel(
            text: "D． thirty-one; How",
            font: FontFamily.PingFangSC.Semibold.font(16),
            textColor: UIColor(named: .labelBlack)
        )
        label.numberOfLines = 0
        return label
    }()
    private lazy var separator2: UIView = {
        let line = UIView(UIColor(named: .themeLightBlue))
        return line
    }()
    private lazy var solutionLabel: UILabel = {
        let label = UILabel(
            text: "【试题解析】答案B",
            font: FontFamily.PingFangSC.Regular.font(16),
            textColor: UIColor(named: .solutionBlue)
        )
        return label
    }()
    private lazy var explanationLabel: UILabel = {
        let label = UILabel(
            text: "根据语境，used the plant's special power to save millions of lives．可知其缺少主语的定语从句，故可排除答案C，D．又从句的先行词为woman（女人）是指人，故可排除答案A，所以答案为B．",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .groupTitleGray),
            textAlignment: .justified
        )
        label.numberOfLines = 0
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
        contentView.backgroundColor = UIColor(named: .themeLightBlue)
        
        // SubViews
        contentView.addSubview(contentShadow)
        contentShadow.addSubview(content)
        content.addSubview(indexLabel)
        content.addSubview(groupTitle)
        content.addSubview(groupDesc)
        
        content.addSubview(separator1)
        
        content.addSubview(exerciseLabel)
        content.addSubview(optionA)
        content.addSubview(optionB)
        content.addSubview(optionC)
        content.addSubview(optionD)
        
        content.addSubview(separator2)
        
        content.addSubview(solutionLabel)
        content.addSubview(explanationLabel)
        
        // Autolayout
        contentShadow.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(10)
            maker.left.equalTo(contentView).offset(10)
            maker.right.equalTo(contentView).offset(-10)
            maker.bottom.equalTo(contentView).offset(-10)
            
        }
        content.snp.makeConstraints { (maker) in
            maker.center.equalTo(contentShadow)
            maker.size.equalTo(contentShadow)
        }
        indexLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(groupTitle.snp.right)
            maker.height.equalTo(22)
            maker.top.equalTo(content).offset(18)
            maker.right.equalTo(content).offset(-13)
        }
        let width = (groupTitle.text! as NSString).size(attributes: [NSFontAttributeName : FontFamily.PingFangSC.Regular.font(12)]).width + (12*2)
        groupTitle.snp.makeConstraints { (maker) in
            maker.width.equalTo(width)
            maker.height.equalTo(24)
            maker.top.equalTo(content).offset(20)
            maker.left.equalTo(content).offset(15)
        }
        groupDesc.snp.makeConstraints { (maker) in
            maker.top.equalTo(groupTitle.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(15)
            maker.right.equalTo(content).offset(-15)
        }
        separator1.snp.makeConstraints { (maker) in
            maker.height.equalTo(1)
            maker.left.equalTo(content).offset(10)
            maker.right.equalTo(content).offset(-10)
            maker.top.equalTo(groupDesc.snp.bottom).offset(18)
        }
        exerciseLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(separator1.snp.bottom).offset(22)
            maker.left.equalTo(content).offset(14)
            maker.right.equalTo(content).offset(-14)
        }
        optionA.snp.makeConstraints { (maker) in
            maker.top.equalTo(exerciseLabel.snp.bottom).offset(20)
            maker.left.equalTo(exerciseLabel)
        }
        optionB.snp.makeConstraints { (maker) in
            maker.top.equalTo(optionA.snp.bottom).offset(8)
            maker.left.equalTo(exerciseLabel)
        }
        optionC.snp.makeConstraints { (maker) in
            maker.top.equalTo(optionB.snp.bottom).offset(8)
            maker.left.equalTo(exerciseLabel)
        }
        optionD.snp.makeConstraints { (maker) in
            maker.top.equalTo(optionC.snp.bottom).offset(8)
            maker.left.equalTo(exerciseLabel)
        }
        separator2.snp.makeConstraints { (maker) in
            maker.height.equalTo(1)
            maker.left.equalTo(content).offset(10)
            maker.right.equalTo(content).offset(-10)
            maker.top.equalTo(optionD.snp.bottom).offset(22)
        }
        solutionLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(separator2.snp.bottom).offset(10)
            maker.height.equalTo(28)
            maker.left.equalTo(content).offset(10)
        }
        explanationLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(solutionLabel.snp.bottom).offset(8)
            maker.left.equalTo(content).offset(16)
            maker.right.equalTo(content).offset(-16)
        }
    }
    
    private func remakeGroupTitleWidth() {
        let width = (groupTitle.text! as NSString).size(attributes: [NSFontAttributeName : FontFamily.PingFangSC.Regular.font(12)]).width + (12*2)
        groupTitle.snp.remakeConstraints { (maker) in
            maker.width.equalTo(width)
            maker.height.equalTo(24)
            maker.top.equalTo(content).offset(20)
            maker.left.equalTo(content).offset(15)
        }
    }
}
