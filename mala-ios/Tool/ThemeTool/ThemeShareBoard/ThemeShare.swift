//
//  ThemeShare.swift
//  mala-ios
//
//  Created by 王新宇 on 16/8/24.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class ThemeShare: NSObject, UIGestureRecognizerDelegate {
    
    // MARK: - Propert
    static let sharedInstance = ThemeShare()
    /// 老师模型
    var teacherModel: TeacherDetailModel? {
        didSet {
            shareBoard.teacherModel = teacherModel
        }
    }
    var isShowing = false
    
    
    // MARK: - Components
    lazy var shareBoard: ThemeShareBoard = {
        let board = ThemeShareBoard()
        let tap = UITapGestureRecognizer(target: ThemeShare.self, action: #selector(ThemeShare.hideShareBoard(_:)))
        tap.delegate = sharedInstance
        board.addGestureRecognizer(tap)
        return board
    }()
    
    
    // MARK: - Class Method
    class func showShareBoard() {
        showShareBoardWhileBlockingUI(true)
    }
    
    class func showShareBoardWhileBlockingUI(_ blockingUI: Bool) {
                
        if self.sharedInstance.isShowing {
            return
        }
        
        DispatchQueue.main.async {
            if
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let window = appDelegate.window {
                
                self.sharedInstance.isShowing = true
                
                self.sharedInstance.shareBoard.isUserInteractionEnabled = blockingUI
                
                self.sharedInstance.shareBoard.alpha = 0
                window.addSubview(self.sharedInstance.shareBoard)
                
                // 设置遮罩不遮盖导航栏
                let width = window.bounds.size.width
                let height = window.bounds.size.height
                self.sharedInstance.shareBoard.frame = CGRect(x: 0, y: 0, width: width, height: height)
                
                UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    self.sharedInstance.shareBoard.alpha = 1
                    
                    }, completion: { (finished) -> Void in
                })
            }
        }
    }
    
    class func hideShareBoard(_ completion: () -> Void) {
        
        DispatchQueue.main.async {
            
            if self.sharedInstance.isShowing {
                
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    
                    }, completion: { (finished) -> Void in
                        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                            
                            self.sharedInstance.shareBoard.alpha = 0
                            
                            }, completion: { (finished) -> Void in
                                self.sharedInstance.shareBoard.removeFromSuperview()
                        })
                })
            }
            
            self.sharedInstance.isShowing = false
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let tag = touch.view?.tag, tag == 1099 {
            return true
        }
        return false
    }
}
