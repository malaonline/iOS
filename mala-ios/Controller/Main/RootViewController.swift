//
//  RootViewController.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/17.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

private struct PagingMenuOptions: PagingMenuControllerCustomizable {
    
    var backgroundColor: UIColor {
        return MalaColor_EDEDED_0
    }
    
    // var lazyLoadingPage: LazyLoadingPage {
    //     return .one
    // }
    
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        let viewController1 = FindTeacherViewController()
        let viewController2 = LiveCourseViewController()
        return [viewController1, viewController2]
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        var backgroundColor: UIColor {
            return MalaColor_FDFDFD_0
        }
        var selectedBackgroundColor: UIColor {
            return MalaColor_FDFDFD_0
        }
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2()]
        }
        var focusMode: MenuFocusMode {
            return .underline(height: 2, color: MalaColor_8DBEDE_0, horizontalPadding: 30, verticalPadding: 0)
        }
    }
    
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "一对一", color: MalaColor_7E7E7E_0, selectedColor: MalaColor_8DBEDE_0))
        }
    }
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "双师直播", color: MalaColor_7E7E7E_0, selectedColor: MalaColor_8DBEDE_0))
        }
    }
}

class RootViewController: UIViewController {
    
    // MARK: - Components
    /// 上课地点选择按钮
    private lazy var regionPickButton: RegionPicker = {
        let picker = RegionPicker()
        picker.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RootViewController.regionsPickButtonDidTap)))
        return picker
    }()
    fileprivate lazy var rightBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(customView:
            UIButton(
                imageName: "filter_normal",
                highlightImageName: "filter_press",
                target: self,
                action: #selector(RootViewController.filterButtonDidTap)
            )
        )
        return button
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regionsPickButtonDidTap(true)
        
        setupUserInterface()
        setupPageController()
        getCurrentLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        navigationController?.navigationBar.shadowImage = UIImage.withColor(MalaColor_F4F4F4_0)
        
        // TitleView
        navigationItem.titleView = regionPickButton
        
        // LeftBarButtonItem
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = -12
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = [spacer, rightBarButtonItem]
    }
    
    private func setupPageController() {
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.delegate = self
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
    }
    
    private func getCurrentLocation() {
        proposeToAccess(.location(.whenInUse), agreed: {
            
            MalaLocationService.turnOn()
            }, rejected: {
                self.alertCanNotAccessLocation()
        })
    }
    
    private func loadTeachers() {
        NotificationCenter.default.post(name: MalaNotification_LoadTeachers, object: nil)
    }
    
    
    // MARK: - Event Response
    @objc private func regionsPickButtonDidTap(_ isStartup: Bool) {
        
        if let _ = MalaUserDefaults.currentSchool.value {
            
            // 启动时如果已选择过地点，则不显示地点选择面板
            if isStartup {
                return
            }
            
            // 地点选择器
            let viewController = RegionViewController()
            viewController.didSelectAction = { [weak self] in
                self?.loadTeachers()
                self?.regionPickButton.schoolName = MalaCurrentSchool?.name
            }
            
            navigationController?.present(
                UINavigationController(rootViewController: viewController),
                animated: true,
                completion: nil
            )
        }else {
            // 初次启动时
            let viewController = CityTableViewController()
            viewController.didSelectAction = { [weak self] in
                self?.loadTeachers()
                self?.regionPickButton.schoolName = MalaCurrentSchool?.name
            }
            
            navigationController?.present(
                UINavigationController(rootViewController: viewController),
                animated: true,
                completion: nil
            )
        }
    }
    
    @objc private func filterButtonDidTap() {
        TeacherFilterPopupWindow(contentView: FilterView(frame: CGRect.zero)).show()
    }
}

// MARK: - PagingMenuControllerDelegate
extension RootViewController: PagingMenuControllerDelegate {
    func willMove(toMenu menuController: UIViewController, fromMenu previousMenuController: UIViewController) {
        if menuController is FindTeacherViewController {
            rightBarButtonItem.customView?.alpha = 1
        }else if menuController is LiveCourseViewController {
            rightBarButtonItem.customView?.alpha = 0
        }
    }
    
    func didMove(toMenu menuController: UIViewController, fromMenu previousMenuController: UIViewController) {
        // print(#function)
    }
    
    func willMove(toMenuItem menuItemView: MenuItemView, fromMenuItem previousMenuItemView: MenuItemView) {
        // print(#function)
    }
    
    func didMove(toMenuItem menuItemView: MenuItemView, fromMenuItem previousMenuItemView: MenuItemView) {
        // print(#function)
    }
}
