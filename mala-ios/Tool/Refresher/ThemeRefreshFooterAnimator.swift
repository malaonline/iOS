//
//  ThemeRefreshFooterAnimator.swift
//  mala-ios
//
//  Created by 王新宇 on 03/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit
import ESPullToRefresh

public class ThemeRefreshFooterAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol {
    
    open var loadingMoreDescription: String = "加载更多"
    open var noMoreDataDescription: String  = "没有更多内容啦～"
    open var loadingDescription: String     = "加载中..."
    
    // MARK: - Property
    public var view: UIView { return self }
    public var insets: UIEdgeInsets = UIEdgeInsets.zero
    public var trigger: CGFloat = 48.0
    public var executeIncremental: CGFloat = 0.0
    public var state: ESRefreshViewState = .pullToRefresh
    public var duration: TimeInterval = 0.3
    
    
    // MARK: - Components
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(imageName: "nomoreContent")
        imageView.isHidden = true
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.PingFangSC.Regular.font(14)
        label.textColor = UIColor(named: .protocolGary)
        label.textAlignment = .center
        return label
    }()
    private let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.text = loadingMoreDescription
        
        addSubview(titleLabel)
        addSubview(indicatorView)
        addSubview(imageView)
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self)
            maker.height.equalTo(20)
            maker.top.equalTo(self).offset(12)
        }
        indicatorView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(titleLabel)
            maker.right.equalTo(titleLabel.snp.left).offset(-18)
        }
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(6)
            maker.centerX.equalTo(self)
            maker.height.equalTo(120)
            maker.width.equalTo(220)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - ESRefresh Protocol
    public func refreshAnimationBegin(view: ESRefreshComponent) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        imageView.isHidden = true
    }
    
    public func refreshAnimationEnd(view: ESRefreshComponent) {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else { return }
        self.state = state
        
        switch state {
        case .refreshing, .autoRefreshing :
            titleLabel.text = loadingDescription
            break
        case .noMoreData:
            titleLabel.text = noMoreDataDescription
            imageView.isHidden = false
            break
        case .pullToRefresh:
            titleLabel.text = loadingMoreDescription
            break
        default:
            break
        }
    }
}
