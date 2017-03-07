//
//  Extension+UIView.swift
//  mala-ios
//
//  Created by Elors on 1/4/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit
import Toast_Swift

extension UIView {

    ///  convenience to create a view with background color
    ///
    ///  - returns: UIView
    convenience init(_ backgroundColor: UIColor, cornerRadius: CGFloat? = nil) {
        self.init()
        self.backgroundColor = backgroundColor
        
        if let cornerRadius = cornerRadius {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    func addShadow(offset: CGFloat = MalaScreenOnePixel, color: UIColor = UIColor.black, opacity: Float = 1) {
        self.layer.shadowOffset = CGSize(width: 0, height: offset)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
    }
    
    func addTapEvent(target: Any?, action: Selector?) {
        self.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
}

// MARK: - Toast
extension UIView {
    func showToastAtBottom(_ message: String, completion: ((Bool) -> Void)? = nil) {
        let toast: UIView = try! self.toastViewForMessage(message, title: nil, image: nil, style: ToastManager.shared.style)
        let padding: CGFloat = ToastManager.shared.style.verticalPadding
        let point: CGPoint = CGPoint(x: self.bounds.size.width / 2.0, y: (self.bounds.size.height - (toast.frame.size.height / 2.0)) - padding - 44 - 10)
        self.showToast(toast, duration: ToastManager.shared.duration, position: point, completion: completion)
    }
}
