//
//  ProfileViewController.swift
//  mala-ios
//
//  Created by Elors on 12/18/15.
//  Copyright © 2015 Mala Online. All rights reserved.
//

import UIKit
import Proposer

private let ProfileViewTableViewCellReuseID = "ProfileViewTableViewCellReuseID"
private let ProfileViewTableViewItemCellReuseID = "ProfileViewTableViewItemCellReuseID"

class ProfileViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileViewHeaderViewDelegate {
    
    // MARK: - Property
    /// [个人中心结构数据]
    private var model: [[ProfileElementModel]] = MalaConfig.profileData()
    var isFetching: Bool = false
    
    // MARK: - Components
    /// [个人中心]头部视图
    private lazy var profileHeaderView: ProfileViewHeaderView = {
        let view = ProfileViewHeaderView(frame: CGRect(x: 0, y: 0, width: MalaScreenWidth, height: MalaLayout_ProfileHeaderViewHeight))
        view.name = MalaUserDefaults.studentName.value ?? L10n.studentName
        view.delegate = self
        return view
    }()
    /// [个人中心]底部视图
    private lazy var profileFooterView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 55))
        return view
    }()
    /// 顶部背景图
    private lazy var headerBackground: UIImageView = {
        let image = UIImageView(imageName: "profile_headerBackground")
        image.contentMode = .scaleAspectFill
        return image
    }()
    /// [退出登录] 按钮
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.setTitle("退  出", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .ThemeBlue)), for: UIControlState())
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .ThemeBlue)), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(ProfileViewController.logoutButtonDidTap), for: .touchUpInside)
        return button
    }()
    /// 照片选择器
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
    

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        println("token is \(MalaUserDefaults.userAccessToken.value as Optional)")
        configure()
        setupUserInterface()
        setupNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 每次显示[个人]页面时，刷新个人信息
        loadUnpaindOrder()
        model = MalaConfig.profileData()
        tableView.reloadData()
        profileHeaderView.refreshDataWithUserDefaults()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendScreenTrack(SAProfileViewName)
    }
    
    
    // MARK: - Private Method
    private func configure() {
        
        // register
        tableView.register(ProfileViewCell.self, forCellReuseIdentifier: ProfileViewTableViewCellReuseID)
        tableView.register(ProfileItemViewCell.self, forCellReuseIdentifier: ProfileViewTableViewItemCellReuseID)
    }
    
    private func setupUserInterface() {
        // Style
        tableView.tableHeaderView = profileHeaderView
        tableView.tableFooterView = profileFooterView
        tableView.backgroundColor = UIColor(named: .CardBackground)
        tableView.separatorStyle = .none
        
        // SubViews
        tableView.insertSubview(headerBackground, at: 0)
        profileFooterView.addSubview(logoutButton)
        
        
        // Autolayout
        headerBackground.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(0)
            maker.centerX.equalTo(tableView)
            maker.width.equalTo(MalaScreenWidth)
            maker.height.equalTo(MalaLayout_ProfileHeaderViewHeight)
        }
        logoutButton.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(profileFooterView)
            maker.centerX.equalTo(profileFooterView)
            maker.width.equalTo(profileFooterView).multipliedBy(0.85)
            maker.height.equalTo(37)
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            forName: MalaNotification_PushProfileItemController,
            object: nil,
            queue: nil
        ) { [weak self] (notification) -> Void in
            if let model = notification.object as? ProfileElementModel, let type = model.controller as? UIViewController.Type {
                
                // 若对应项被冻结，则点击无效
                if model.disabled, let message = model.disabledMessage {
                    self?.ShowToast(message)
                    return
                }
                
                let viewController = type.init()
                viewController.title = model.controllerTitle
                viewController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    /// 查询用户是否有未处理订单／评价
    func loadUnpaindOrder() {
        
        if !MalaUserDefaults.isLogined { return }
        if isFetching { return }
        isFetching = true
        
        MAProvider.userNewMessageCount(failureHandler: { error in
            self.isFetching = false
        }) { (order, comment) in
            println("未支付订单数量：\(order) - 待评价数量：\(comment)")
            self.isFetching = false
            MalaUnpaidOrderCount = order
            MalaToCommentCount = comment
            self.navigationController?.showTabBadgePoint = (MalaUnpaidOrderCount > 0 || MalaToCommentCount > 0)
        }
    }
    
    ///  更新本地AvatarView的图片
    ///
    ///  - parameter completion: 完成闭包
    private func updateAvatar(_ completion:() -> Void) {
        if let avatarURLString = MalaUserDefaults.avatar.value {
            profileHeaderView.avatarURL = avatarURLString
            completion()
        }
    }
    
    
    // MARK: - DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : model[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileViewTableViewItemCellReuseID, for: indexPath) as! ProfileItemViewCell
            cell.model = model[0]
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileViewTableViewCellReuseID, for: indexPath) as! ProfileViewCell
            
            cell.model =  model[indexPath.section][indexPath.row]
            // Section的最后一个Cell隐藏分割线
            if (indexPath.row+1) == model[indexPath.section].count {
                cell.hideSeparator()
            }
            return cell
        }
    }
    
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 8))
        view.backgroundColor = UIColor(named: .CardBackground)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 12
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 114 : 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ProfileViewCell
        let model = cell.model
        
        // 若对应项被冻结，则点击无效
        if model.disabled { return }
        
        // 跳转到对应的ViewController
        if let type = model.controller as? UIViewController.Type {
            let viewController = type.init()
            viewController.title = model.controllerTitle
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let displacement = scrollView.contentOffset.y
        
        // 向下滑动页面时，使顶部图片跟随放大
        if displacement < 0 && headerBackground.superview != nil{
            headerBackground.snp.updateConstraints({ (maker) -> Void in
                maker.top.equalTo(0).offset(displacement)
                // 1.1为放大速率
                maker.height.equalTo(MalaLayout_ProfileHeaderViewHeight + abs(displacement)*1.1)
            })
        }
    }
    
    ///  HeaderView修改姓名
    func nameEditButtonDidTap(_ sender: UIButton) {
        let window = InfoModifyViewWindow(contentView: UIView())
        window.show()
    }
    
    ///  HeaderView头像点击事件
    ///
    ///  - parameter sender: UIImageView对象
    func avatarViewDidTap(_ sender: UIImageView) {
        
        // 准备ActionSheet选择[拍照]或[选择照片]
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 设置Action - 选择照片
        let choosePhotoAction: UIAlertAction = UIAlertAction(title: L10n.pickPhoto, style: .default) { (action) -> Void in
        
            let openCameraRoll: ProposerAction = { [weak self] in
                
                guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                    self?.alertCanNotAccessCameraRoll()
                    return
                }
                
                if let strongSelf = self {
                    strongSelf.imagePicker.sourceType = .photoLibrary
                    strongSelf.present(strongSelf.imagePicker, animated: true, completion: nil)
                }
            }
            
            proposeToAccess(.photos, agreed: openCameraRoll, rejected: {
                self.alertCanNotAccessCameraRoll()
            })
            
        }
        alertController.addAction(choosePhotoAction)
        
        // 设置Action - 拍照
        let takePhotoAction: UIAlertAction = UIAlertAction(title: L10n.takePicture, style: .default) { (action) -> Void in
            
            let openCamera: ProposerAction = { [weak self] in
                
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    self?.alertCanNotOpenCamera()
                    return
                }
                
                if let strongSelf = self {
                    strongSelf.imagePicker.sourceType = .camera
                    strongSelf.present(strongSelf.imagePicker, animated: true, completion: nil)
                }
            }
            
            proposeToAccess(.camera, agreed: openCamera, rejected: {
                self.alertCanNotOpenCamera()
            })
            
        }
        alertController.addAction(takePhotoAction)
        
        // 设置Action - 取消
        let cancelAction: UIAlertAction = UIAlertAction(title: L10n.cancel, style: .cancel) { action -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        // 弹出ActionSheet
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        // 处理图片尺寸和质量
        let image = image.largestCenteredSquareImage().resizeToTargetSize(MalaConfig.avatarMaxSize())
        guard let imageData = UIImageJPEGRepresentation(image, MalaConfig.avatarCompressionQuality()) else { return }
        
        // 开启头像刷新指示器
        profileHeaderView.refreshAvatar = true
        
        MAProvider.uploadAvatar(imageData: imageData, failureHandler: { [weak self] error in
            DispatchQueue.main.async {
                self?.profileHeaderView.refreshAvatar = false
            }
        }) { [weak self] result in
            println("Upload New Avatar: \(result as Optional)")
            DispatchQueue.main.async {
                MalaUserDefaults.fetchProfileInfo()
                DispatchQueue.main.async {
                    self?.profileHeaderView.avatar = UIImage(data: imageData) ?? UIImage()
                    self?.profileHeaderView.refreshAvatar = false
                }
            }
        }
    }
    
    
    // MARK: - Event Response
    @objc private func logoutButtonDidTap() {
        MalaAlert.confirmOrCancel(
            title: L10n.mala,
            message: L10n.doYouWantToLogout,
            confirmTitle: L10n.logout,
            cancelTitle: L10n.cancel,
            inViewController: self,
            withConfirmAction: { () -> Void in
                
                unregisterThirdPartyPush()
                cleanCaches()
                MalaUserDefaults.cleanAllUserDefaults()
                
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.switchToStart()
                }
                
            }, cancelAction: { () -> Void in
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: MalaNotification_PushProfileItemController, object: nil)
    }
}
