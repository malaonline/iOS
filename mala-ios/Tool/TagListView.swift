//
//  ListView.swift
//
//
//  Created by Oskar Zhang on 7/13/15.
//  Copyright (c) 2015 Oskar Zhang. All rights reserved.
//

import Foundation
import UIKit
class TagListView:UIScrollView
{
    /// 标签字符串数据
    var labels: [String] = [] {
        didSet {
            if labels != oldValue {
                setupLabels()
            }
        }
    }
    
    var numberOfRows = 0
    var currentRow = 0
    var tags = [UILabel]()
    var hashtagsOffset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    /// 行高
    var rowHeight: CGFloat = 30
    /// 水平间隔
    var tagHorizontalPadding: CGFloat = 5.0
    /// 垂直间隔
    var tagVerticalPadding: CGFloat = 5.0
    /// 文字左右边界间隔
    var tagCombinedMargin: CGFloat = 10.0
    /// 默认标签背景色
    var labelBackgroundColor: UIColor = UIColor.lightGray
    /// 默认文字颜色
    var textColor: UIColor = UIColor.white
    /// 图标名称
    var iconName: String?
    /// 公共触发事件
    var commonTarget: AnyObject?
    var commonAction: Selector?
    
    
    // MARK: - Instance Method
    override init(frame:CGRect) {
        super.init(frame: frame)
        numberOfRows = Int(frame.height / rowHeight)
        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// 批量设置标签控件
    func setupLabels() {
        self.reset()
        for string in labels {
            self.addTag(string)
        }
        self.snp.makeConstraints { (maker) -> Void in
            maker.height.equalTo(Int((currentRow+1)*30))
        }
    }
    
    func addTag(_ text: String, target: AnyObject? = nil, tapAction: Selector? = nil, longPressAction: Selector? = nil, backgroundColor: UIColor? = nil, color: UIColor? = nil) {
        
        // 初始化标签控件（自定义属性）
        let label = UILabel()
        label.layer.cornerRadius = 3
        label.clipsToBounds = true
        label.textColor = UIColor.white
        label.backgroundColor = backgroundColor ?? labelBackgroundColor
        label.text = text
        label.textColor = color ?? textColor
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        label.textAlignment = .center
        self.tags.append(label)
        label.layer.shouldRasterize = true
        label.layer.rasterizationScale = UIScreen.main.scale
        
        // 图标
        if iconName != nil {
            label.textAlignment = .left
            let imageView = UIImageView(image: UIImage(named: iconName!))
            label.addSubview(imageView)
            
            imageView.snp.makeConstraints { (maker) -> Void in
                maker.width.equalTo(14)
                maker.height.equalTo(14)
                maker.right.equalTo(label.snp.right).offset(-tagCombinedMargin)
                maker.centerY.equalTo(label.snp.centerY)
            }
        }
        
        // 点击事件
        if tapAction != nil {
            let tap = UITapGestureRecognizer(target: target, action: tapAction!)
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tap)
        }
        
        // 公共点击事件
        if commonTarget != nil && commonAction != nil {
            let tap = UITapGestureRecognizer(target: commonTarget, action: commonAction!)
            // 若由labels数据生成标签，则将标签下标分配为tag
            if labels.count != 0, let index = labels.index(of: text) {
                label.tag = index
            }
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tap)
        }
        
        // 长按事件
        if longPressAction != nil {
            let longPress = UILongPressGestureRecognizer(target: target, action: longPressAction!)
            label.addGestureRecognizer(longPress)
        }
        
        // 计算frame
        let iconPadding: CGFloat = (iconName == nil) ? 0 : (14+3)
        label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: label.frame.width + tagCombinedMargin + iconPadding, height: rowHeight - tagVerticalPadding)
        if self.tags.count == 0 {
            label.frame = CGRect(x: hashtagsOffset.left, y: hashtagsOffset.top, width: label.frame.width, height: label.frame.height)
            self.addSubview(label)
            
        } else {
            label.frame = self.generateFrameAtIndex(tags.count-1, rowNumber: &currentRow)
            self.addSubview(label)
        }
    }
    
    private func isOutofBounds(_ newPoint:CGPoint,labelFrame:CGRect) {
        let bottomYLimit = newPoint.y + labelFrame.height
        if bottomYLimit > self.contentSize.height {
            self.contentSize = CGSize(width: self.contentSize.width, height: self.contentSize.height + rowHeight - tagVerticalPadding)
        }
    }
    
    func getNextPosition() -> CGPoint {
        return getPositionForIndex(tags.count-1, rowNumber: self.currentRow)
    }
    
    func getPositionForIndex(_ index:Int,rowNumber:Int) -> CGPoint {
        if index == 0 {
            return CGPoint(x: hashtagsOffset.left, y: hashtagsOffset.top)
        }
        let y = CGFloat(rowNumber) * self.rowHeight + hashtagsOffset.top
        let lastTagFrame = tags[index-1].frame
        let x = lastTagFrame.origin.x + lastTagFrame.width + tagHorizontalPadding
        return CGPoint(x: x, y: y)
    }
    
    func removeTagWithName(_ name:String) {
        for (index,tag) in tags.enumerated() {
            if tag.text! == name {
                removeTagWithIndex(index)
            }
        }
    }
    
    func removeTagWithIndex(_ index:Int) {
        if index > tags.count - 1 {
            print("ERROR: Tag Index \(index) Out of Bounds")
            return
        }
        tags[index].removeFromSuperview()
        tags.remove(at: index)
        layoutTagsFromIndex(index)
    }
    
    private func getRowNumber(_ index:Int) -> Int {
        return Int((tags[index].frame.origin.y - hashtagsOffset.top)/rowHeight)
    }
    
    private func layoutTagsFromIndex(_ index:Int,animated:Bool = true) {
        if tags.count == 0 {
            return
        }
        let animation:()->() = {
            var rowNumber = self.getRowNumber(index)
            for i in index...self.tags.count - 1 {
                self.tags[i].frame = self.generateFrameAtIndex(i, rowNumber: &rowNumber)
            }
        }
        UIView.animate(withDuration: 0.3, animations: animation)
    }
    
    private func generateFrameAtIndex(_ index:Int, rowNumber: inout Int) -> CGRect {
        var newPoint = self.getPositionForIndex(index, rowNumber: rowNumber)
        if (newPoint.x + self.tags[index].frame.width) >= self.frame.width {
            rowNumber += 1
            newPoint = CGPoint(x: self.hashtagsOffset.left, y: CGFloat(rowNumber) * rowHeight + self.hashtagsOffset.top)
        }
        self.isOutofBounds(newPoint,labelFrame: self.tags[index].frame)
        return CGRect(x: newPoint.x, y: newPoint.y, width: self.tags[index].frame.width, height: self.tags[index].frame.height)
    }
    
    func removeMultipleTagsWithIndices(_ indexSet:Set<Int>) {
        let sortedArray = Array(indexSet).sorted()
        for index in sortedArray {
            if index > tags.count - 1 {
                print("ERROR: Tag Index \(index) Out of Bounds")
                continue
            }
            tags[index].removeFromSuperview()
            tags.remove(at: index)
        }
        layoutTagsFromIndex(sortedArray.first!)
    }
    
    func reset() {
        for tag in tags {
            tag.removeFromSuperview()
        }
        tags = []
        currentRow = 0
        numberOfRows = 0
    }
}
