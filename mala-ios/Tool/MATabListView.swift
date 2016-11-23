//
//  MATabListView.swift
//  mala-ios
//
//  Created by Elors on 1/6/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

@objc protocol MATabListViewDelegate: NSObjectProtocol {
    @objc optional func tagDidTap(_ sender: UILabel, tabListView: MATabListView)
    @objc optional func tagShourldDisplayBorder(_ sender: UILabel, tabListView: MATabListView) -> Bool
}


private let RightPadding: CGFloat = 12.0
private let BottomMargin: CGFloat = 5.0

class MATabListView: UIView {

    // MARK: - Property
    weak var delegate: MATabListViewDelegate?
    var layoutHeight: CGFloat = 0
    private var previousFrame = CGRect.zero
    private var totalHeight: CGFloat = 0
    private var tagCount = 0
    
    
    // MARK: - Constructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        totalHeight = 0
        self.frame = frame
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - API
    func setTags(_ tags: [String]?) {
        
        previousFrame = CGRect.zero
        for string in tags ?? [] {
            
            guard string != "" else {
                continue
            }
            
            let label = UILabel(frame: CGRect.zero)
            label.textAlignment = .left
            label.textColor = MalaColor_636363_0
            label.font = UIFont.systemFont(ofSize: 14)
            
            label.text = string
            var size = (string as NSString).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
            size.width += RightPadding
            
            var newRect = CGRect.zero
            
            var x = previousFrame.maxX
            
            if let isDisplayBorder = delegate?.tagShourldDisplayBorder?(label, tabListView: self), isDisplayBorder {
                
                label.textColor = MalaColor_939393_0
                
                size.height += 10
                x = previousFrame.maxX == 0 ? previousFrame.maxX : previousFrame.maxX+RightPadding
                
                label.layer.borderWidth = 1
                label.layer.borderColor = MalaColor_C4C4C4_0.cgColor
                label.layer.cornerRadius = 3
                label.layer.masksToBounds = true
                label.textAlignment = .center
                label.isUserInteractionEnabled = true
                label.addTapEvent(target: self, action: #selector(MATabListView.labelDidTap(_:)))
                label.tag = tagCount
                tagCount += 1
            }
            
            // 如果当前行宽度不足够加入新的label
            if previousFrame.maxX + size.width > self.bounds.size.width {
                newRect.origin = CGPoint(x: 0, y: previousFrame.origin.y + size.height + BottomMargin)
                totalHeight += size.height + BottomMargin
            }else {
                newRect.origin = CGPoint(x: x, y: previousFrame.origin.y)
            }
            
            newRect.size = size
            label.frame = newRect
            previousFrame = label.frame
            self.addSubview(label)
            self.setHeight(totalHeight + size.height)
        }
    }
    
    
    // MARK: - Private Method
    private func setHeight(_ height: CGFloat) {
        self.layoutHeight = height
        self.snp.updateConstraints { (maker) -> Void in
            maker.height.equalTo(self.layoutHeight)
        }
    }
    
    
    // MARK: - Event Response
    @objc private func labelDidTap(_ gesture: UITapGestureRecognizer) {
        
        guard let label = gesture.view as? UILabel else {
            return
        }
        delegate?.tagDidTap?(label, tabListView: self)
    }
}
