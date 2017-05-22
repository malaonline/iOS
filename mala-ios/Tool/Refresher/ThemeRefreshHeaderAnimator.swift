//
//  ThemeRefreshHeaderAnimator.swift
//  mala-ios
//
//  Created by 王新宇 on 03/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit
import ESPullToRefresh

public class ThemeRefreshHeaderAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol {

    // MARK: - Property
    public var view: UIView { return self }
    public var insets: UIEdgeInsets = UIEdgeInsets.zero
    public var trigger: CGFloat = 110.0
    public var executeIncremental: CGFloat = 110.0
    public var state: ESRefreshViewState = .pullToRefresh
    public var duration: TimeInterval = 0.3
    private var imageSize: CGFloat = 79
    
    
    // MARK: - Components
    private lazy var imageView: UIImageView = UIImageView(imageName: "refreshImage")
    
    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.center.equalTo(self)
            maker.height.equalTo(imageSize)
            maker.width.equalTo(imageSize)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - ESRefresh Protocol
    public func refreshAnimationBegin(view: ESRefreshComponent) {
        resetImageViewSize()
        imageView.image = (UIScreen.main.scale == 3 ? UIImage(asset: .refreshGif3x) : UIImage(asset: .refreshGif2x))
    }
    
    public func refreshAnimationEnd(view: ESRefreshComponent) {
        imageView.image = UIImage(asset: .refreshImage)
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        var percent: CGFloat = 0
        
        if progress <= 0.3 {
            percent = 0.3
        }else if progress > 0.3 && progress < 1 {
            percent = progress
        }else {
            percent = 1
        }
        
        imageView.snp.remakeConstraints { (maker) in
            maker.center.equalTo(self)
            maker.height.equalTo(imageSize * percent)
            maker.width.equalTo(imageSize * percent)
        }
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        return
    }
    
    private func resetImageViewSize() {
        imageView.snp.remakeConstraints { (maker) in
            maker.center.equalTo(self)
            maker.height.equalTo(imageSize)
            maker.width.equalTo(imageSize)
        }
    }
}
