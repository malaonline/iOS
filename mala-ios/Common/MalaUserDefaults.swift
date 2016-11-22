//
//  MalaUserDefaults.swift
//  mala-ios
//
//  Created by 王新宇 on 2/24/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

// MARK: Keys
let userAccessTokenKey = "userAccessTokenKey"
let UserIDKey = "UserIDKey"
let ParentIDKey = "ParentIDKey"
let ProfileIDKey = "ProfileIDKey"
let FirstLoginKey = "FirstLoginKey"
let GenderKey = "GenderKey"
let AvatarKey = "AvatarKey"
let StudentNameKey = "StudentNameKey"
let SchoolNameKey = "SchoolNameKey"

let CurrentCityKey = "CurrentCityKey"
let CurrentSchoolKey = "CurrentSchoolKey"

///  监听者
struct Listener<T>: Hashable {
    /// 监听者名称
    let name: String
    /// 触发事件
    typealias Action = (T) -> Void
    let action: Action
    
    var hashValue: Int {
        return name.hashValue
    }
}

/// 可监听变量
class Listenable<T> {
    /// 变量值
    var value: T {
        didSet {
            setterAction(value)
            for listener in listenerSet {
                listener.action(value)
            }
        }
    }
    
    /// 触发事件
    typealias SetterAction = (T) -> Void
    var setterAction: SetterAction
    // 监听者数组
    var listenerSet = Set<Listener<T>>()
    
    ///  构造方法
    ///
    ///  - parameter v:      value
    ///  - parameter action: trigger action
    ///
    ///  - returns: The created listenable.
    init(_ v: T, setterAction action: @escaping SetterAction) {
        value = v
        setterAction = action
    }
    ///  绑定监听
    func bindListener(_ name: String, action: @escaping Listener<T>.Action) {
        let listener = Listener(name: name, action: action)
        //
        listenerSet.insert(listener)
    }
    ///  绑定监听并执行
    func bindAndFireListener(_ name: String, action: @escaping Listener<T>.Action) {
        bindListener(name, action: action)
        
        action(value)
    }
    
    func removeListenerWithName(_ name: String) {
        for listener in listenerSet {
            if listener.name == name {
                listenerSet.remove(listener)
                break
            }
        }
    }
    
    func removeAllListeners() {
        listenerSet.removeAll(keepingCapacity: false)
    }
}


// MARK: - MalaUserDefaults
class MalaUserDefaults {
    
    /// 单例
    static let defaults = UserDefaults(suiteName: MalaConfig.appGroupID)!
    
    /// 登出标记 - 由于Listenable的Value不可为nil。
    /// 所以每次注销后accessToken仍然会保存用户的Token, 导致isLogined返回结果不正确
    static var isLogouted = false
    
    /// 登陆标识
    static var isLogined: Bool {
        // [用户Token为空] 或 [已经注销] 均判断为未登录情况
        if (MalaUserDefaults.userAccessToken.value != nil) && !MalaUserDefaults.isLogouted {
            return true
        } else {
            return false
        }
    }
    
    
    // MARK: - Login Info
    /// 令牌
    static var userAccessToken: Listenable<String?> = {
        let userAccessToken = defaults.string(forKey: userAccessTokenKey)
        
        return Listenable<String?>(userAccessToken) { userAccessToken in
            defaults.set(userAccessToken, forKey: userAccessTokenKey)
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                
            }
        }
    }()
    /// 用户id
    static var userID: Listenable<Int?> = {
        let userID = defaults.integer(forKey: UserIDKey)
        
        return Listenable<Int?>(userID) { userID in
            defaults.set(userID, forKey: UserIDKey)
        }
    }()
    /// 家长id
    static var parentID: Listenable<Int?> = {
        let parentID = defaults.integer(forKey: ParentIDKey)
        
        return Listenable<Int?>(parentID) { parentID in
            defaults.set(parentID, forKey: ParentIDKey)
        }
    }()
    /// 个人资料id
    static var profileID: Listenable<Int?> = {
        let profileID = defaults.integer(forKey: ProfileIDKey)
        
        return Listenable<Int?>(profileID) { profileID in
            defaults.set(profileID, forKey: ProfileIDKey)
        }
    }()
    /// 登陆标示（以是否已填写学生姓名区分）
    static var firstLogin: Listenable<Bool?> = {
        let firstLogin = defaults.bool(forKey: FirstLoginKey)
        
        return Listenable<Bool?>(firstLogin) { firstLogin in
            defaults.set(firstLogin, forKey: FirstLoginKey)
        }
    }()
    
    // MARK: - Profile Info
    static var gender: Listenable<String?> = {
        let gender = defaults.string(forKey: GenderKey)
        
        return Listenable<String?>(gender) { gender in
            defaults.set(gender, forKey: GenderKey)
        }
    }()
    static var avatar: Listenable<String?> = {
        let avatar = defaults.string(forKey: AvatarKey)
        
        return Listenable<String?>(avatar) { avatar in
            defaults.set(avatar, forKey: AvatarKey)
        }
    }()
    
    
    // MARK: - Parent Info
    /// 学生姓名
    static var studentName: Listenable<String?> = {
        let studentName = defaults.string(forKey: StudentNameKey)
        
        return Listenable<String?>(studentName) { studentName in
            defaults.set(studentName, forKey: StudentNameKey)
        }
    }()
    /// 学校信息
    static var schoolName: Listenable<String?> = {
        let schoolName = defaults.string(forKey: SchoolNameKey)
        
        return Listenable<String?>(schoolName) { schoolName in
            defaults.set(schoolName, forKey: SchoolNameKey)
        }
    }()
    /// 当前选择城市
    static var currentCity: Listenable<BaseObjectModel?> = {
        var currentCity: BaseObjectModel?
        if let data = defaults.object(forKey: CurrentCityKey) as? Data {
            currentCity = NSKeyedUnarchiver.unarchiveObject(with: data) as? BaseObjectModel
        }
        
        return Listenable<BaseObjectModel?>(currentCity) { currentCity in
            if let object  = currentCity {
                let encodedObject = NSKeyedArchiver.archivedData(withRootObject: object)
                defaults.set(encodedObject, forKey: CurrentCityKey)
            }
        }
    }()
    /// 当前选择校区
    static var currentSchool: Listenable<SchoolModel?> = {
        var currentSchool: SchoolModel?
        if let data = defaults.object(forKey: CurrentSchoolKey) as? Data {
            currentSchool = NSKeyedUnarchiver.unarchiveObject(with: data) as? SchoolModel
        }
        
        return Listenable<SchoolModel?>(currentSchool) { currentSchool in
            if let object  = currentSchool {
                let encodedObject = NSKeyedArchiver.archivedData(withRootObject: object)
                defaults.set(encodedObject, forKey: CurrentSchoolKey)
            }
        }
    }()
    
    
    // MARK: - Class Method
    /// 清空UserDefaults
    class func cleanAllUserDefaults() {
        
        userAccessToken.removeAllListeners()
        userID.removeAllListeners()
        parentID.removeAllListeners()
        profileID.removeAllListeners()
        firstLogin.removeAllListeners()
        gender.removeAllListeners()
        avatar.removeAllListeners()
        studentName.removeAllListeners()
        schoolName.removeAllListeners()
        currentCity.removeAllListeners()
        currentSchool.removeAllListeners()
        
        defaults.removeObject(forKey: userAccessTokenKey)
        defaults.removeObject(forKey: UserIDKey)
        defaults.removeObject(forKey: ParentIDKey)
        defaults.removeObject(forKey: ProfileIDKey)
        defaults.removeObject(forKey: FirstLoginKey)
        defaults.removeObject(forKey: GenderKey)
        defaults.removeObject(forKey: AvatarKey)
        defaults.removeObject(forKey: StudentNameKey)
        defaults.removeObject(forKey: SchoolNameKey)
        defaults.removeObject(forKey: CurrentCityKey)
        defaults.removeObject(forKey: CurrentSchoolKey)
        
        // 配置清空成功表示注销成功
        MalaUserDefaults.isLogouted = defaults.synchronize()
    }
    
    class func userNeedRelogin() {
        
        if let _ = userAccessToken.value {
            
            cleanAllUserDefaults()
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                if let rootViewController = appDelegate.window?.rootViewController {
                    MalaAlert.alert(title: "麻辣老师", message: "用户验证错误，请重新登录！", dismissTitle: "重新登录", inViewController: rootViewController, withDismissAction: {
                        appDelegate.showLoginView()
                    })
                }
            }
        }
    }
}
