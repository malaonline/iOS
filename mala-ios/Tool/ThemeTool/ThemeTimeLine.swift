//
//  ThemeTimeLine.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/13.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit
private func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

private func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ThemeTimeLine: UIView, CAAnimationDelegate {

    private let BettweenLabelOffset: CGFloat = 20
    private let LineWidth: CGFloat = 2.0
    private let CircleRadius: CGFloat = 3.0
    private let InitProgressContainerWidth: CGFloat = 20
    private let ProgressViewContainerLeft: CGFloat = 60
    private let ViewWidth: CGFloat = 225
    
    // MARK: - Property
    private var viewHeight: CGFloat = 0
    private var didStopAnimation: Bool = false
    private var layers: [CAShapeLayer] = []
    private var circleLayers: [CAShapeLayer] = []
    private var layerCounter: Int = 0
    private var circleCounter: Int = 0
    private var timeOffset: CGFloat = 0
    private var leftWidth: CGFloat = 0
    private var rightWidth: CGFloat = 0
    private var viewWidth: CGFloat = 0
    private var dataCount: Int = 0
    
    private lazy var progressViewContainer: UIView = UIView()
    private lazy var timeViewContainer: UIView = UIView()
    private lazy var progressDescriptionViewContainer: UIView = UIView()
    
    private lazy var labelDscriptionsArray: [UILabel] = []
    private lazy var sizes: [CGRect] = []
    
    
    // MARK: - API
    convenience init(times: [String], descs: [String], currentStatus: Int = 999999, frame: CGRect = CGRect(x: 0, y: 0, width: MalaLayout_CardCellWidth, height: 0)) {
        self.init(frame: frame)
        
        viewHeight = 75
        leftWidth = frame.size.width - (ProgressViewContainerLeft + InitProgressContainerWidth + CircleRadius*2)
        self.addSubview(progressViewContainer)
        self.addSubview(timeViewContainer)
        self.addSubview(progressDescriptionViewContainer)
        
        self.dataCount = times.count
        self.addTimeDescriptionLabels(descs, times: times, currentStatus: currentStatus)
        self.setNeedsUpdateConstraints()
        self.addProgressBasedOnLabels(self.labelDscriptionsArray, currentStatus: currentStatus)
        self.addTimeLabels(times, currentStatus: currentStatus)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func addTimeDescriptionLabels(_ descs: [String], times: [String], currentStatus: Int) {
        var betweenLabelOffset: CGFloat = 0
        var totalHeight: CGFloat = 6
        let fittingSize: CGSize = CGSize.zero
        
        var lastLabel = UILabel(frame: self.progressDescriptionViewContainer.frame)
        self.progressDescriptionViewContainer.addSubview(lastLabel)
        
        var i = 0
        
        for string in descs {
            let label = UILabel()
            label.text = string
            label.numberOfLines = 0
            label.textColor = MalaColor_6C6C6C_0
//            label.textColor = i < currentStatus ? MalaColor_6C6C6C_0 : MalaColor_E5E5E5_0
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 14)
            self.progressDescriptionViewContainer.addSubview(label)
            
            // 日期label与上一组数据高度最大的内容底部保持20的距离
            let bottomMargin = i >= 1 ? (descs[i-1].characters.count > 26 ? betweenLabelOffset : betweenLabelOffset+12) : (betweenLabelOffset)
 
            label.snp_makeConstraints({ (make) in
                make.left.equalTo(self.progressDescriptionViewContainer).offset(7)
                make.width.equalTo(leftWidth)
                make.top.equalTo(lastLabel.snp_bottom).offset(bottomMargin)
                make.height.greaterThanOrEqualTo(16)
            })
            
            label.preferredMaxLayoutWidth = leftWidth
            label.sizeToFit()
            let fittingSize = label.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            betweenLabelOffset = BettweenLabelOffset
            totalHeight += (fittingSize.height + betweenLabelOffset)
            lastLabel = label
            
            self.labelDscriptionsArray.append(label)
            i += 1
        }
        viewHeight = fittingSize.height
        
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
    }
    
    private func addProgressBasedOnLabels(_ labels: [UILabel], currentStatus: Int) {
        var i = 0
        
        for label in labels {
            
            let line = UIImageView(image: UIImage(named: "time_top"))
            self.progressViewContainer.addSubview(line)
            
            /// 最后一个时间点
            if i == (self.dataCount-1) {
                line.image = UIImage(named: "time_point")
                line.snp_makeConstraints({ (make) in
                    make.centerX.equalTo(progressViewContainer)
                    make.width.equalTo(9)
                    make.top.equalTo(label.snp_top).offset(4)
                    make.height.equalTo(9)
                })
            /// 描述字数多于一行的，下一个时间点以描述label为基准
            }else if label.text?.characters.count > 26 {
                line.snp_makeConstraints({ (make) in
                    make.centerX.equalTo(progressViewContainer)
                    make.width.equalTo(9)
                    make.top.equalTo(label.snp_top).offset(2)
                    make.bottom.equalTo(label.snp_bottom).offset(24)
                })
            /// 描述字数少于一行的，下一个时间点以时间label为基准
            }else {
                line.snp_makeConstraints({ (make) in
                    make.centerX.equalTo(progressViewContainer)
                    make.width.equalTo(9)
                    make.top.equalTo(label.snp_top).offset(2)
                    make.bottom.equalTo(label.snp_bottom).offset(36)
                })
            }
            i += 1
        }
        self.startAnimatingLayer(circleLayers, currentStatus: currentStatus)
    }
    
    private func addTimeLabels(_ times: [String], currentStatus: Int) {
        var betweenLabelOffset: CGFloat = 0
        var totalHeight: CGFloat = 6
        var i = 0
        
        for string in times {
            let label = UILabel()
            label.text = string
            label.numberOfLines = 0
            label.textColor = MalaColor_333333_0
//            label.textColor = i < currentStatus ? MalaColor_82B4D9_0 : MalaColor_E5E5E5_0
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 12)
            self.timeViewContainer.addSubview(label)
            
            let descLabel = self.labelDscriptionsArray[i]
            
            label.snp_makeConstraints({ (make) in
                make.height.equalTo(32)
                make.left.equalTo(timeViewContainer)
                make.width.equalTo(timeViewContainer)
                make.top.equalTo(descLabel.snp_top)
            })
            let fittingSize = label.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            betweenLabelOffset = BettweenLabelOffset
            totalHeight += (fittingSize.height + betweenLabelOffset)
            self.labelDscriptionsArray.append(label)
            i += 1
        }
        
        viewHeight = totalHeight
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
    }
    
    
    // MARK: - Support Method
    private func configureBezierCircle(_ circle: UIBezierPath, centerY: CGFloat) {
        circle.addArc(withCenter: CGPoint(x: self.progressViewContainer.center.x + CircleRadius + InitProgressContainerWidth/2, y: centerY),
                                radius: CircleRadius,
                                startAngle: CGFloat(M_PI_2),
                                endAngle: CGFloat(-M_PI_2),
                                clockwise: true)
        circle.addArc(withCenter: CGPoint(x: self.progressViewContainer.center.x + CircleRadius + InitProgressContainerWidth/2, y: centerY),
                                radius: CircleRadius,
                                startAngle: CGFloat(-M_PI_2),
                                endAngle: CGFloat(M_PI_2),
                                clockwise: true)
    }
    
    private func getLayerWithCircle(_ circle: UIBezierPath, strokeColor: UIColor) -> CAShapeLayer {
        let circleLayer = CAShapeLayer()
        circleLayer.frame = self.progressViewContainer.bounds
        circleLayer.path = circle.cgPath
        
        circleLayer.strokeColor = strokeColor.cgColor
        circleLayer.fillColor = nil
        circleLayer.lineWidth = LineWidth
        circleLayer.lineJoin = kCALineJoinBevel
        return circleLayer
    }
    
    private func getLayerWithLine(_ line: UIBezierPath, strokeColor: UIColor) -> CAShapeLayer {
        let lineLayer = CAShapeLayer()
        lineLayer.path = line.cgPath
        lineLayer.strokeColor = strokeColor.cgColor
        lineLayer.fillColor = nil
        lineLayer.lineWidth = LineWidth
        return lineLayer
    }
    
    private func getLineWithStartPoint(_ start: CGPoint, end: CGPoint) -> UIBezierPath {
        let line = UIBezierPath()
        line.move(to: start)
        line.addLine(to: end)
        return line
    }
    
    private func startAnimatingLayer(_ layersToAnimate: [CAShapeLayer], currentStatus: Int) {
        var circleTimeOffset: Double = 1
        var i = 0
        
        if currentStatus == layersToAnimate.count {
            for circleLayer in layersToAnimate {
                self.progressViewContainer.layer.addSublayer(circleLayer)
            }
            for lineLayer in layers {
                self.progressViewContainer.layer.addSublayer(lineLayer)
            }
        }else {
            for circleLayer in layersToAnimate {
                self.progressViewContainer.layer.addSublayer(circleLayer)
                
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.duration = 0.2
                animation.beginTime = circleLayer.convertTime(CACurrentMediaTime(), to: nil) + circleTimeOffset
                animation.fromValue = 0
                animation.toValue = 1
                animation.fillMode = kCAFillModeForwards
                animation.delegate = self
                circleTimeOffset += 0.4
                circleLayer.isHidden = true
                circleLayer.add(animation, forKey: "strokeCircleAnimation")
                
                if i == currentStatus && i != layersToAnimate.count {
                   let strokeAnim = CABasicAnimation(keyPath: "strokeColor")
                    strokeAnim.fromValue = UIColor.orange.cgColor
                    strokeAnim.toValue = UIColor.clear.cgColor
                    strokeAnim.duration = 1
                    strokeAnim.repeatCount = MAXFLOAT
                    strokeAnim.autoreverses = false
                    circleLayer.add(strokeAnim, forKey: "animateStrokeColor")
                }
                i += 1
            }
        }
    }
    
    override func updateConstraints() {
        self.progressViewContainer.snp_updateConstraints { (make) in
            make.width.equalTo(CircleRadius+InitProgressContainerWidth)
            make.height.equalTo(viewHeight)
            make.top.equalTo(self)
            make.left.equalTo(ProgressViewContainerLeft)
        }
        self.timeViewContainer.snp_updateConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(progressViewContainer.snp_left)
            make.top.equalTo(self)
            make.height.equalTo(viewHeight)
        }
        self.progressDescriptionViewContainer.snp_updateConstraints { (make) in
            make.right.equalTo(self)
            make.left.equalTo(progressViewContainer.snp_right).offset(0)
            make.top.equalTo(self)
            make.height.equalTo(viewHeight)
        }
        super.updateConstraints()
    }
}
