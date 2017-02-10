//
//  TeacherDetailsController.swift
//  mala-ios
//
//  Created by Elors on 12/30/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit

private let TeacherDetailsCellReuseId = [
    0: "TeacherDetailsSubjectCellReuseId",
    1: "TeacherDetailsTagsCellReuseId",
    2: "TeacherDetailsHighScoreCellReuseId",
    3: "TeacherDetailsPhotosCellReuseId",
    4: "TeacherDetailsCertificateCellReuseId"
]

private let TeacherDetailsCellTitle = [
    1: "教授年级",
    2: "风格标签",
    3: "提分榜",
    4: "个人相册",
    5: "特殊成就"
]

class TeacherDetailsController: BaseViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, SignupButtonDelegate {

    // MARK: - Property
    var teacherID: Int = 0
    var model: TeacherDetailModel = MalaConfig.defaultTeacherDetail() {
        didSet {
            DispatchQueue.main.async {
                MalaOrderOverView.avatarURL = self.model.avatar
                MalaOrderOverView.teacherName = self.model.name
                MalaOrderOverView.subjectName = self.model.subject
                MalaOrderOverView.teacher = self.model.id
                
                self.tableHeaderView.model = self.model
                self.tableView.reloadData()
                
                self.isPublished = self.model.published
                self.isFavorite = self.model.favorite
            }
        }
    }
    /// 是否已上架标识
    var isPublished: Bool = false {
        didSet {
            signupView.isPublished = isPublished
        }
    }
    /// 是否已收藏标识
    var isFavorite: Bool = false {
        didSet {
            signupView.isFavorite = isFavorite
        }
    }
    var isNavigationBarShow: Bool = false
    /// 必要数据加载完成计数
    private var requiredCount: Int = 0 {
        didSet {
            // [老师详情][上课地点][会员服务]三个必要数据加载完成才激活界面
            if requiredCount == 3 {
                ThemeHUD.hideActivityIndicator()
            }
        }
    }

    
    // MARK: - Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        return tableView
    }()
    /// 头部视图
    private lazy var tableHeaderView: TeacherDetailsHeaderView = {
        let tableHeaderView = TeacherDetailsHeaderView(frame: CGRect(x: 0, y: 0, width: MalaScreenWidth, height: MalaLayout_DetailHeaderContentHeight+50))
        return tableHeaderView
    }()
    /// 顶部背景图
    private lazy var headerBackground: UIImageView = {
        let image = UIImageView(imageName: "teacherDetailHeader_placeholder")
        image.contentMode = .scaleAspectFill
        return image
    }()
    /// 报名按钮
    private lazy var signupView: TeacherDetailsSignupView = {
        let signupView = TeacherDetailsSignupView(frame: CGRect(x: 0, y: 0,
            width: MalaScreenWidth, height: MalaLayout_DetailBottomViewHeight))
        return signupView
    }()
    /// 导航栏返回按钮
    lazy var leftBarButton: UIButton = {
        let backBarButton = UIButton(
            imageName: "leftArrow_white",
            highlightImageName: "leftArrow_black",
            target: self,
            action: #selector(TeacherDetailsController.popSelf)
        )
        return backBarButton
    }()
    /// 分享按钮
    private lazy var shareButton: UIButton = {
        let button = UIButton(
            imageName: "share_normal",
            highlightImageName: "share_press",
            target: self,
            action: #selector(TeacherDetailsController.shareButtonDidTap)
        )
        return button
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeHUD.showActivityIndicator()
        
        setupUserInterface()
        loadTeacherDetail()
        setupNotification()
        
        // 激活Pop手势识别
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 设置 NavigationBar 透明色
        // makeStatusBarWhite()
        sendScreenTrack(SATeacherDetailName)
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isNavigationBarShow {
            showBackground()
        }else {
            hideBackground()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage.withColor(UIColor.white), for: .default)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.shadowImage = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        signupView.delegate = self
        tableView.estimatedRowHeight = 240
        tableView.backgroundColor = UIColor(named: .RegularBackground)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = tableHeaderView
        tableView.register(TeacherDetailsSubjectCell.self, forCellReuseIdentifier: TeacherDetailsCellReuseId[0]!)
        tableView.register(TeacherDetailsTagsCell.self, forCellReuseIdentifier: TeacherDetailsCellReuseId[1]!)
        tableView.register(TeacherDetailsHighScoreCell.self, forCellReuseIdentifier: TeacherDetailsCellReuseId[2]!)
        tableView.register(TeacherDetailsPhotosCell.self, forCellReuseIdentifier: TeacherDetailsCellReuseId[3]!)
        tableView.register(TeacherDetailsCertificateCell.self, forCellReuseIdentifier: TeacherDetailsCellReuseId[4]!)
        
        // leftBarButtonItem
        let spacer1 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer1.width = -2
        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        navigationItem.leftBarButtonItems = [spacer1, leftBarButtonItem]
        
        // rightBarButtonItem
        let spacer2 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer2.width = -10
        let rightBarButtonItem = UIBarButtonItem(customView: shareButton)
        navigationItem.rightBarButtonItems = [spacer2, rightBarButtonItem]
        
        
        // SubViews
        view.addSubview(tableView)
        view.addSubview(signupView)
        tableView.insertSubview(headerBackground, at: 0)
        
        // Autolayout
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.bottom.equalTo(view).offset(-MalaLayout_DetailBottomViewHeight)
        }
        headerBackground.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(0).offset(-MalaScreenNaviHeight)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.height.equalTo(MalaLayout_DetailHeaderContentHeight)
        }
        signupView.snp.makeConstraints({ (maker) -> Void in
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.bottom.equalTo(view)
            maker.height.equalTo(MalaLayout_DetailBottomViewHeight)
        })
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            forName: MalaNotification_PushPhotoBrowser,
            object: nil,
            queue: nil
            ) { [weak self] (notification) -> Void in
                
                // 相册
                if let info = notification.object as? String, info == "browser" {
                    let browser = MalaPhotoBrowser()
                    browser.imageURLs = self?.model.photo_set ?? []
                    self?.navigationController?.pushViewController(browser, animated: true)
                }
                
                // 特殊成就
                if let photoBrowser = notification.object as? SKPhotoBrowser {
                    self?.navigationController?.present(photoBrowser, animated: true, completion: nil)
                }
                
                // 相册图片
                if let imageView = notification.object as? UIImageView, let originImage = imageView.image {
                    
                    var images: [SKPhoto]? = []
                    
                    if imageView.tag == 999 {
                        let image = SKPhoto.photoWithImage(originImage)
                        image.shouldCachePhotoURLImage = true
                        images = [image]
                    }else {
                        images = self?.model.photo_set?.map({ (imageURL) -> SKPhoto in
                            let image = SKPhoto.photoWithImageURL(imageURL)
                            image.shouldCachePhotoURLImage = true
                            return image
                        })
                    }
                    
                    /// 图片浏览器
                    SKPhotoBrowserOptions.displayAction = false
                    SKPhotoBrowserOptions.displayBackAndForwardButton = false
                    SKPhotoBrowserOptions.displayDeleteButton = false
                    SKPhotoBrowserOptions.displayStatusbar = false
                    SKPhotoBrowserOptions.displayStatusbar = false
                    SKPhotoBrowserOptions.bounceAnimation = false
                    
                    let browser = SKPhotoBrowser(originImage: originImage, photos: images ?? [], animatedFromView: imageView)
                    browser.initializePageIndex(imageView.tag)
                    browser.navigationController?.isNavigationBarHidden = true
                    self?.navigationController?.present(browser, animated: true, completion: nil)
                }
        }
    }
    
    private func loadTeacherDetail() {
        
        loadTeacherDetailData(teacherID, failureHandler: { (reason, errorMessage) in
            ThemeHUD.hideActivityIndicator()
            defaultFailureHandler(reason, errorMessage: errorMessage)
            // 错误处理
            if let errorMessage = errorMessage {
                println("TeacherDetailsController - loadTeacherDetail Error \(errorMessage)")
            }
        }, completion: { (model) in
            ThemeHUD.hideActivityIndicator()
            if let model = model {
                self.model = model
            }
            self.requiredCount += 1
        })
    }
    
    private func likeTeacher() {
        addFavoriteTeacher(teacherID, failureHandler: { (reason, errorMessage) in
            // 错误处理
            if let errorMessage = errorMessage {
                println("TeacherDetailsController - likeTeacher Error \(errorMessage)")
            }
        }, completion: { (bool) in
            println("收藏老师 - \(bool)")
        })
    }
    
    private func dislikeTeacher() {
        removeFavoriteTeacher(teacherID, failureHandler: { (reason, errorMessage) in
            // 错误处理
            if let errorMessage = errorMessage {
                println("TeacherDetailsController - dislikeTeacher Error \(errorMessage)")
            }
        }, completion: { (bool) in
            println("取消收藏老师 - \(bool)")
        })
    }
    
    private func showBackground() {
        // makeStatusBarBlack()
        title = model.name
        navigationController?.navigationBar.setBackgroundImage(UIImage.withColor(UIColor.white), for: .default)
        navigationController?.navigationBar.shadowImage = nil
        turnBackButtonBlack()
        isNavigationBarShow = true
    }
    
    private func hideBackground() {
        // makeStatusBarWhite()
        title = ""
        navigationController?.navigationBar.setBackgroundImage(UIImage.withColor(UIColor.clear), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        turnBackButtonWhite()
        isNavigationBarShow = false
    }
    
    // 跳转到课程购买页
    private func pushToCourseChoosingView() {
        let viewController = CourseChoosingViewController()
        viewController.teacherModel = model
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - Deleagte
    ///［立即报名］点击事件
    func signupButtonDidTap(_ sender: UIButton) {
        
        // 未登陆则进行登陆动作
        if !MalaUserDefaults.isLogined {
            
            let loginController = LoginViewController()
            loginController.popAction = { [weak self] in
                if MalaUserDefaults.isLogined {
                    self?.pushToCourseChoosingView()
                }
            }
            
            self.present(
                UINavigationController(rootViewController: loginController),
                animated: true,
                completion: nil)
        
        }else {
            self.pushToCourseChoosingView()
        }
    }
    
    ///［收藏按钮］点击事件
    func likeButtonDidTap(_ sender: DOFavoriteButton) {
        
        // 收藏／取消收藏
        let action = {
            // 更改数据模型，发送请求
            if self.isFavorite == true {
                self.dislikeTeacher()
                self.isFavorite = false
            }else {
                self.likeTeacher()
                self.isFavorite = true
            }
        }
        
        // 未登陆则进行登陆动作
        if !MalaUserDefaults.isLogined {
            
            let loginController = LoginViewController()
            loginController.popAction = {
                if MalaUserDefaults.isLogined {
                    action()
                }
            }
            
            self.present(
                UINavigationController(rootViewController: loginController),
                animated: true,
                completion: nil)
            
        }else {
            action()
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let displacement = scrollView.contentOffset.y
        
        // 向下滑动页面时，使顶部图片跟随放大
        if displacement < -MalaScreenNaviHeight {
            headerBackground.snp.updateConstraints({ (maker) -> Void in
                maker.top.equalTo(0).offset(displacement)
                // 1.1为放大速率
                maker.height.equalTo(MalaLayout_DetailHeaderContentHeight + abs(displacement+MalaScreenNaviHeight)*1.1)
            })
        }
        
        // 上下滑动页面到一定程度且 NavigationBar 尚未显示，渲染NavigationBar样式
        if displacement > -40 && !isNavigationBarShow {
            showBackground()
        }
        if displacement < -40 && isNavigationBarShow {
            hideBackground()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    // MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return TeacherDetailsCellReuseId.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: TeacherDetailsCellReuseId[indexPath.section]!, for: indexPath)
        (reuseCell as! MalaBaseCell).titleLabel.text = TeacherDetailsCellTitle[indexPath.section+1]
        
        switch indexPath.section {
        case 0:
            
            let cell = reuseCell as! TeacherDetailsSubjectCell
            cell.gradeStrings = model.grades
            return cell
            
        case 1:
            let cell = reuseCell as! TeacherDetailsTagsCell
             cell.labels = model.tags
            return cell
            
        case 2:
            let cell = reuseCell as! TeacherDetailsHighScoreCell
            cell.model = model.highscore_set
            return cell
            
        case 3:
            let cell = reuseCell as! TeacherDetailsPhotosCell
            cell.photos = model.photo_set ?? []
            return cell
            
        case 4:
            let cell = reuseCell as! TeacherDetailsCertificateCell
            cell.models = model.achievement_set
            return cell
            
        default:
            break
        }
        return reuseCell
    }

    
    // MARK: - Event Respones
    @objc private func shareButtonDidTap() {
        
        // 初始化分享面板
        ThemeShare.showShareBoard()
        ThemeShare.sharedInstance.teacherModel = self.model
    }

    override func turnBackButtonBlack() {
        leftBarButton.setImage(UIImage(named: "leftArrow_black"), for: UIControlState())
        shareButton.setImage(UIImage(named: "share_press"), for: UIControlState())
    }
    
    override func turnBackButtonWhite() {
        leftBarButton.setImage(UIImage(named: "leftArrow_white"), for: UIControlState())
        shareButton.setImage(UIImage(named: "share_normal"), for: UIControlState())
    }
    
    deinit {
        println("TeacherDetailController Deinit")
        // 移除观察者
        NotificationCenter.default.removeObserver(self, name: MalaNotification_PushPhotoBrowser, object: nil)
    }
}
