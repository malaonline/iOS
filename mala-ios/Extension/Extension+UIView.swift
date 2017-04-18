//
//  Extension+UIView.swift
//  mala-ios
//
//  Created by Elors on 1/4/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit
import Toast_Swift

// MARK: - Class Method
extension UIView {
    
    /// Convenience to create a UIView
    ///
    /// - Returns: UIView
    class func loginInputView() -> UIView {
        let view = UIView(UIColor.white)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }
    
    /// Convenience to create shadow of input view
    ///
    /// - Returns: UIView
    class func loginInputShadow() -> UIView {
        let view = UIView(UIColor(named: .loginLightBlue))
        view.layer.cornerRadius = 4
        view.layer.shadowColor = UIColor(named: .loginShadow).cgColor
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        return view
    }
}

// MARK: - Convenience
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
}

// MARK: - Instance Method
extension UIView {
    
    /// Setup shadow.
    ///
    /// - Parameters:
    ///   - offset:     Offset of the shadow.
    ///   - color:      Color of the shadow.
    ///   - opacity:    Opacity of the shadow.
    func addShadow(offset: CGFloat = MalaScreenOnePixel, color: UIColor = UIColor.black, opacity: Float = 1) {
        self.layer.shadowOffset = CGSize(width: 0, height: offset)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
    }
    
    /// Add Tap Event.
    ///
    /// - Parameters:
    ///   - target: Handler of Action.
    ///   - action: Action when view did tap.
    func addTapEvent(target: Any?, action: Selector?) {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
    /// Show Toast at bottom.
    ///
    /// - Parameters:
    ///   - message: String of the message.
    ///   - completion: completion.
    func showToastAtBottom(_ message: String, completion: ((Bool) -> Void)? = nil) {
        let toast: UIView = try! self.toastViewForMessage(message, title: nil, image: nil, style: ToastManager.shared.style)
        let padding: CGFloat = ToastManager.shared.style.verticalPadding
        let point: CGPoint = CGPoint(x: self.bounds.size.width / 2.0, y: (self.bounds.size.height - (toast.frame.size.height / 2.0)) - padding - 44 - 10)
        self.showToast(toast, duration: ToastManager.shared.duration, position: point, completion: completion)
    }
    
    /// Show Toast at center.
    ///
    /// - Parameters:
    ///   - message: String of the message.
    ///   - completion: completion.
    func showToastAtCenter(_ message: String, completion: ((Bool) -> Void)? = nil) {
        let toast: UIView = try! self.toastViewForMessage(message, title: nil, image: nil, style: ToastManager.shared.style)
        self.showToast(toast, duration: ToastManager.shared.duration, position: .center, completion: completion)
    }
}
