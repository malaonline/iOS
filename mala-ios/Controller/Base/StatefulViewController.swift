//
//  StatefulViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 30/03/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Kingfisher

public class StatefulViewController: UIViewController {
    
    var isLoading: Bool = true

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        KingfisherManager.shared.cache.clearMemoryCache()
    }
    
}

extension StatefulViewController: DZNEmptyDataSetSource {
 
    // Title
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var plug = (title: "", font: FontFamily.PingFangSC.Regular.font(17), color: UIColor(named: .HeaderTitle))
        
        switch self {
        case is CourseTableViewController:
            plug.title = "您暂时还未报名课程哦"
        default:
            break
        }
        
        return NSAttributedString(
            string: plug.title,
            attributes: [
                NSFontAttributeName: plug.font,
                NSForegroundColorAttributeName: plug.color
            ]
        )
    }
    
    // Description
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var plug = (title: "", font: FontFamily.PingFangSC.Regular.font(14.5), color: UIColor(named: .HeaderTitle))
        
        switch self {
        case is CourseTableViewController:
            plug.title = "您报名的课程安排将会显示在这里"
        default:
            break
        }
        
        return NSAttributedString(
            string: plug.title,
            attributes: [
                NSFontAttributeName: plug.font,
                NSForegroundColorAttributeName: plug.color
            ]
        )
    }
    
    // Button
    public func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        
        var plug = (title: "", font: FontFamily.PingFangSC.Regular.font(15.0), color: state == .normal ? UIColorFromHex(0x007ee5) : UIColorFromHex(0x48a1ea))
        
        switch self {
        case is CourseTableViewController:
            plug.title = "去报名"
        default:
            break
        }
        
        return NSAttributedString(
            string: plug.title,
            attributes: [
                NSFontAttributeName: plug.font,
                NSForegroundColorAttributeName: plug.color
            ]
        )
    }
    
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if isLoading {
            return UIImage(asset: .loading_imgBlue)
        }else {
            return UIImage(asset: .networkError)
        }
    }
    
    public func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(.pi / 2, 0.0, 0.0, 1.0))
        animation.duration = 0.25
        animation.isCumulative = true
        animation.repeatCount = MAXFLOAT
        return animation
    }
    
    public func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 20
    }
}

extension StatefulViewController: DZNEmptyDataSetDelegate {
    public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    public func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    public func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return isLoading
    }
}
