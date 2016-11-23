//
//  KWStepper.swift
//  Created by Kyle Weiner on 10/17/14.
//  https://github.com/kyleweiner/KWStepper
//

import UIKit

@objc public protocol KWStepperDelegate {
    @objc optional func KWStepperDidDecrement()
    @objc optional func KWStepperDidIncrement()
    @objc optional func KWStepperMaxValueClamped()
    @objc optional func KWStepperMinValueClamped()
}

open class KWStepper: UIControl {

    // MARK: - Required Variables

    /// The decrement button used initialize the control.
    let decrementButton: UIButton

    /// The increment button used initialize the control.
    let incrementButton: UIButton

    // MARK: - Optional Variables

    /// If true, press & hold repeatedly alters value. Default = true.
    open var autoRepeat: Bool = true {
        didSet {
            if autoRepeatInterval <= 0 {
                autoRepeat = false
            }
        }
    }

    /// The interval that autoRepeat changes the stepper value, specified in seconds. Default = 0.10.
    open var autoRepeatInterval: TimeInterval = 0.10 {
        didSet {
            if autoRepeatInterval <= 0 {
                autoRepeatInterval = 0.10
                autoRepeat = false
            }
        }
    }

    /// If true, value wraps from min <-> max. Default = false.
    open var wraps: Bool = false

    /// Sends UIControlEventValueChanged, clamped to min/max. Default = 0.
    open var value: Double = 0 {
        didSet {
            // 数值相同时不在重复触发后续事件
            guard value != oldValue else { return }
            
            if value > oldValue {
                delegate?.KWStepperDidIncrement?()
                incrementCallback?()
            } else {
                delegate?.KWStepperDidDecrement?()
                decrementCallback?()
            }

            if value < minimumValue {
                value = minimumValue
            } else if value > maximumValue {
                value = maximumValue
            }

            sendActions(for: .valueChanged)
            valueChangedCallback?()
        }
    }

    /// Must be less than maximumValue. Default = 0.
    open var minimumValue: Double = 0 {
        willSet {
            assert(newValue < maximumValue, "\(type(of: self)): minimumValue must be less than maximumValue.")
        }
    }

    /// Must be less than minimumValue. Default = 100.
    open var maximumValue: Double = 100 {
        willSet {
            assert(newValue > minimumValue, "\(type(of: self)): maximumValue must be greater than minimumValue.")
        }
    }

    /// The value to step when incrementing. Must be greater than 0. Default = 1.
    open var incrementStepValue: Double = 1 {
        willSet {
            assert(newValue > 0, "\(type(of: self)): incrementStepValue must be greater than zero.")
        }
    }

    /// The value to step when decrementing. Must be greater than 0. Default = 1.
    open var decrementStepValue: Double = 1 {
        willSet {
            assert(newValue > 0, "\(type(of: self)): decrementStepValue must be greater than zero.")
        }
    }

    /// Executed when the value is changed.
    open var valueChangedCallback: (() -> ())?

    /// Executed when the value is decremented.
    open var decrementCallback: (() -> ())?

    /// Executed when the value is incremented.
    open var incrementCallback: (() -> ())?

    /// Executed when the max value is clamped.
    open var maxValueClampedCallback: (() -> ())?

    /// Executed when the min value is clamped.
    open var minValueClampedCallback: (() -> ())?

    open var delegate: KWStepperDelegate? = nil

    // MARK: - Private Variables

    fileprivate var longPressTimer: Timer?

    // MARK: - Initialization

    public init(decrementButton: UIButton, incrementButton: UIButton) {
        self.decrementButton = decrementButton
        self.incrementButton = incrementButton
        super.init(frame: CGRect.zero)

        self.decrementButton.addTarget(self, action: #selector(KWStepper.decrementValue), for: .touchUpInside)
        self.incrementButton.addTarget(self, action: #selector(KWStepper.incrementValue), for: .touchUpInside)

        self.decrementButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(KWStepper.didLongPress(_:))))
        self.incrementButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(KWStepper.didLongPress(_:))))
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("KWStepper: NSCoding is not supported!")
    }

    // MARK: - KWStepper

    open func decrementValue() {
        switch value - decrementStepValue {
            case let x where wraps && x < minimumValue:
                value = maximumValue
            case let x where x >= minimumValue:
                value = x
            default:
                endLongPress()
                delegate?.KWStepperMinValueClamped?()
                maxValueClampedCallback?()
        }
    }

    open func incrementValue() {
        switch value + incrementStepValue {
            case let x where wraps && x > maximumValue:
                value = minimumValue
            case let x where x <= maximumValue:
                value = x
            default:
                endLongPress()
                delegate?.KWStepperMaxValueClamped?()
                maxValueClampedCallback?()
        }
    }

    // MARK: - User Interaction

    open func didLongPress(_ sender: UIGestureRecognizer) {
        if !autoRepeat {
            return
        }

        if longPressTimer == nil && sender.state == .began {
            longPressTimer = Timer.scheduledTimer(
                timeInterval: autoRepeatInterval,
                target: self,
                selector: sender.view == incrementButton ? #selector(KWStepper.incrementValue) : #selector(KWStepper.decrementValue),
                userInfo: nil,
                repeats: true
            )
        }

        if sender.state == .ended || sender.state == .cancelled || sender.state == .failed {
            endLongPress()
        }
    }

    fileprivate func endLongPress() {
        if longPressTimer != nil {
            longPressTimer?.invalidate()
            longPressTimer = nil
        }
    }
    
}
