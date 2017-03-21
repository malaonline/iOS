//
//  MalaSingleWebViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 3/29/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit
import WebKit

class MalaSingleWebViewController: BaseViewController, WKNavigationDelegate, WKUIDelegate {

    // MARK: - Property
    /// HTML代码请求路径。注意此属性并非webView地址
    var url: String = "" {
        didSet {
            loadHTML()
        }
    }
    /// 当前加载的HTML代码
    var HTMLString: String = "" {
        didSet {
            
            // 当HTML数据变化时，加载webView
            if HTMLString != oldValue {
                showHTML()
            }
        }
    }
    
    
    // MARK: - Components
    /// 网页视图
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.preferences = WKPreferences()
        configuration.preferences.minimumFontSize = 13
        
        let webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        return webView
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupUserInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Private Method
    private func configure() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        // webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        // webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    private func setupUserInterface() {
        // SubViews
        view.addSubview(webView)
        
        // Autolayout
        webView.snp.makeConstraints { (maker) -> Void in
            maker.center.equalTo(view)
            maker.size.equalTo(view)
        }
    }
    
    private func loadHTML() {
        ///  获取用户协议HTML
        MAProvider.userProtocolHTML { string in
            DispatchQueue.main.async {
                if let htmlString = string {
                    self.HTMLString = htmlString
                }else {
                    self.ShowToast(L10n.networkNotReachable)
                }
            }
        }
    }
    
    private func showHTML() {
        webView.loadHTMLString(HTMLString, baseURL: MABaseURL)
    }
    
    
    // MARK: - API
    open func loadURL(url: String) {
        delay(0.5) { [weak self] () -> Void in
            _ = self?.webView.load(URLRequest(url: URL(string: url)!))
        }
    }
    
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard keyPath != nil else { return }
        
        switch keyPath! {
        case "title":
            
            self.title = webView.title
            
            break
        case "loading":
            
            println("loading")
            
            break
        case "estimatedProgress":
            
            println("estimatedProgress - \(webView.estimatedProgress)")
            
            break
        default:
            break
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "title", context: nil)
    }
}
