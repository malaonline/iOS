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

/// Represents all possible states of a stateful view controller
public enum StatefulViewState: String {
    case content = "content"
    case loading = "loading"
    case error = "error"
    case empty = "empty"
    case notLoggedIn = "notLoggedIn"
}

public class StatefulViewController: UIViewController {
    
    var currentState: StatefulViewState = .content {
        didSet {
            print(oldValue, "->", currentState)
        }
    }
    

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        KingfisherManager.shared.cache.clearMemoryCache()
    }
    
    
    // MARK: - Event Response
    @objc func popSelf() {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension StatefulViewController: DZNEmptyDataSetSource {
 
    // title
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var plug = (title: "", fontSize: CGFloat(15.5), textColor: UIColor(named: .ArticleSubTitle))
        
        switch (self, currentState) {
        case (is CourseTableViewController, .empty):        plug.title = L10n.noCourse
        case (is CourseTableViewController, .notLoggedIn):  plug.title = L10n.youNeedToLogin
        case (is LiveCourseViewController, .empty):         plug.title = L10n.noLiveCourse
        case (is FindTeacherViewController, .empty):        plug.title = L10n.noLiveCourse
        case (is CouponViewController, .empty):             plug.title = L10n.noTeacher
        // commen
        case (is CourseTableViewController, .loading):      plug.title = L10n.loading
        case (is CityTableViewController, .loading):        plug.title = L10n.loading
        case (is RegionViewController, .loading):           plug.title = L10n.loading
        case (_, .error):                                   plug.title = L10n.networkError
        default: break
        }
        
        return NSAttributedString(
            string: plug.title,
            attributes: [
                NSFontAttributeName: FontFamily.PingFangSC.Regular.font(plug.fontSize),
                NSForegroundColorAttributeName: plug.textColor
            ]
        )
    }
    
    // description
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var plug = (title: "", fontSize: CGFloat(14.5), textColor: UIColor(named: .HeaderTitle))
        
        switch (self, currentState) {
        case (is CourseTableViewController, .empty):    plug.title = "您报名的课程安排将会显示在这里"
        default: break
        }
        
        return NSAttributedString(
            string: plug.title,
            attributes: [
                NSFontAttributeName: FontFamily.PingFangSC.Regular.font(plug.fontSize),
                NSForegroundColorAttributeName: plug.textColor
            ]
        )
    }
    
    // button text
    public func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        
        var plug = (title: "", fontSize: CGFloat(15.0), textColor: state == .normal ? UIColorFromHex(0x007ee5) : UIColorFromHex(0x48a1ea))
        
        switch (self, currentState) {
        case (is CourseTableViewController, .empty):        plug.title = L10n.pickCourse
        case (is CourseTableViewController, .notLoggedIn):  plug.title = L10n.goToLogin
        // commen
        case (_, .error):   plug.title = L10n.tapToRetry
        default: break
        }
        
        return NSAttributedString(
            string: plug.title,
            attributes: [
                NSFontAttributeName: FontFamily.PingFangSC.Regular.font(plug.fontSize),
                NSForegroundColorAttributeName: plug.textColor
            ]
        )
    }
    
    // image
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        switch (self, currentState) {
        case (is CourseTableViewController, .empty):        return UIImage(asset: .courseNoData)
        case (is CourseTableViewController, .notLoggedIn):  return UIImage(asset: .courseNoData)
        case (is LiveCourseViewController, .empty):         return UIImage(asset: .filterNoResult)
        case (is FindTeacherViewController, .empty):        return UIImage(asset: .filterNoResult)
        case (is CouponViewController, .empty):             return UIImage(asset: .noCoupons)
        // commen
        case (is CourseTableViewController, .loading):     return UIImage(asset: .loading_imgBlue)
        case (is CityTableViewController, .loading):       return UIImage(asset: .loading_imgBlue)
        case (is RegionViewController, .loading):          return UIImage(asset: .loading_imgBlue)
        case (_, .error):   return UIImage(asset: .networkError)
        default:            return UIImage.withColor(UIColor.white)
        }
    }
    
    // animation
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
        return 15
    }
    
    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        switch self {
        case is CourseTableViewController:  return -30
        case is LiveCourseViewController:   return MalaScreenWidth/3 - 64
        default: return 0.0
        }
    }
}

extension StatefulViewController: DZNEmptyDataSetDelegate {
    
    public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {

        switch (self, currentState) {
        case (is CourseTableViewController, _):         return true
            
        case (is LiveCourseViewController, .empty):     return true
        case (is LiveCourseViewController, .error):     return true
        case (is FindTeacherViewController, .empty):    return true
        case (is FindTeacherViewController, .error):    return true
        case (is FilterResultController, .empty):       return true
        case (is FilterResultController, .error):       return true
            
        case (is CityTableViewController, .loading):    return true
        case (is CityTableViewController, .error):      return true
        case (is RegionViewController, .loading):       return true
        case (is RegionViewController, .error):         return true
            
        case (is OrderFormViewController, .empty):      return true
        case (is OrderFormViewController, .error):      return true
        case (is CouponViewController, .empty):         return true
        case (is CouponViewController, .error):         return true
        default: return false
        }
    }
    
    public func emptyDataSetShouldBeForced(toDisplay scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    public func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    public func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        switch (self, currentState) {
        case (is CourseTableViewController, .loading):  return true
        case (is CityTableViewController, .loading):    return true
        case (is RegionViewController, .loading):       return true
        default: return false
        }
    }
}
