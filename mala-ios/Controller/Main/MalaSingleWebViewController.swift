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
        webView.navigationDelegate = self
        webView.uiDelegate = self
        return webView
    }()
    private lazy var progressView: WebViewProgressView = {
        let progressBarHeight: CGFloat = 2.0
        let navigationBarBounds = self.navigationController!.navigationBar.bounds
        let barFrame = CGRect(x: 0, y: navigationBarBounds.size.height - progressBarHeight, width: navigationBarBounds.width, height: progressBarHeight)
        let progressView = WebViewProgressView(frame: barFrame)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        return progressView
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.addSubview(progressView)
    }
    
    // MARK: - Private Method
    private func configure() {
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        // webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
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
                    self.showToast(L10n.networkNotReachable)
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
            let request = URLRequest(url: URL(string: url)!)
            self?.webView.load(request)
            // self?.webView.loadRequest(request)
        }
    }
    
    // MARK: - WebViewProgressDelegate
    func webViewProgress(_ webViewProgress: WebViewProgress, updateProgress progress: Float) {
        progressView.setProgress(progress, animated: true)
    }
    
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard keyPath != nil else { return }
        
        switch keyPath! {
        case "title":
            
            self.title = self.navigationController?.title
            
            break
        case "loading":
            
            println("loading")
            
            break
        case "estimatedProgress":
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            // println("estimatedProgress - \(webView.estimatedProgress)")
            
            break
        default:
            break
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "title", context: nil)
        webView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
    }
}
