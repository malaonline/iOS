//
//  ExerciseMistakeCell.swift
//  mala-ios
//
//  Created by 王新宇 on 2017/5/23.
//  Copyright © 2017年 Mala Online. All rights reserved.
//

import UIKit

class ExerciseMistakeCell: UITableViewCell {

    // MARK: - Model
    var model: ExerciseMistakeRecord? {
        didSet {
            guard let model = model,
                  let group = model.exerciseGroup,
                  let exercise = model.exercise else { return }
            
            groupTitle.isHidden = (group.name == nil)
            groupTitle.text = group.name
            remakeGroupTitleWidth()
            dateLabel.text = getDateString(model.updatedAt, format: "yy/MM/dd HH:mm")
            exerciseLabel.text = String(format: "%d.%@", index+1, exercise.name ?? "")
        }
    }
    var index: Int = 0 {
        didSet {
            content.backgroundColor = ( index%2 == 0 ? UIColor.white : UIColor(named: .HighlightGray) )
        }
    }
    
    
    // MARK: - Components
    lazy var content: UIView = {
        let view = UIView(UIColor.white)
        return view
    }()
    /// exercise-group title
    private lazy var groupTitle: UILabel = {
        let label = UILabel(
            text: "关系代词",
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
    /// date
    private lazy var dateLabel: UILabel = {
        let label = UILabel(
            text: "17/4/28 10:28",
            font: FontFamily.PingFangSC.Regular.font(12),
            textColor: UIColor(named: .protocolGary),
            textAlignment: .right
        )
        return label
    }()
    private lazy var exerciseLabel: UILabel = {
        let label = UILabel(
            text: "1.The__________Brazil’s Olympic games will be held on August 5.\n_________exciting news for the long summer vacation!",
            font: FontFamily.PingFangSC.Semibold.font(16),
            textColor: UIColor(named: .labelBlack),
            textAlignment: .left
        )
        label.numberOfLines = 2
        return label
    }()
    
    
    // MARK: - Instance Method
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Private Method
    private func  setup() {
        contentView.backgroundColor = UIColor(named: .themeLightBlue)
        
        contentView.addSubview(content)
        content.addSubview(groupTitle)
        content.addSubview(dateLabel)
        content.addSubview(exerciseLabel)
        
        content.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView)
            maker.left.equalTo(contentView).offset(10)
            maker.right.equalTo(contentView).offset(-10)
            maker.bottom.equalTo(contentView)
        }
        let width = (groupTitle.text! as NSString).size(attributes: [NSFontAttributeName : FontFamily.PingFangSC.Regular.font(12)]).width + (12*2)
        groupTitle.snp.makeConstraints { (maker) in
            maker.width.equalTo(width)
            maker.height.equalTo(24)
            maker.top.equalTo(content).offset(15)
            maker.left.equalTo(content).offset(15)
        }
        dateLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(17)
            maker.centerY.equalTo(groupTitle)
            maker.right.equalTo(content).offset(-15)
        }
        exerciseLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(groupTitle.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(15)
            maker.right.equalTo(content).offset(-15)
            maker.height.equalTo(44)
            maker.bottom.equalTo(content).offset(-15)
        }
    }
    
    private func remakeGroupTitleWidth() {
        let width = (groupTitle.text! as NSString).size(attributes: [NSFontAttributeName : FontFamily.PingFangSC.Regular.font(12)]).width + (12*2)
        groupTitle.snp.remakeConstraints { (maker) in
            maker.width.equalTo(width)
            maker.height.equalTo(24)
            maker.top.equalTo(content).offset(15)
            maker.left.equalTo(content).offset(15)
        }
    }
}
