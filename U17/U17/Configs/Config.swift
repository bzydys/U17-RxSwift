import UIKit

/// 网络环境
enum Environmental : String {
    case TEST
    case U17
}

enum ZFError: String , Error {
    case OperatingDisturbance
}

extension Environmental {
    var url : String {
        switch self {
        case .TEST: return "https://wallet.lpl.app/api/v1/"
        case .U17: return "https://w.lark.one/api/v1/"
        }
    }
}

//MARK:- 宏定义
///app的下载地址
let downloadURL = "xxxxxxx"
let keywindow = (UIApplication.shared.delegate?.window)!
let statusBarHeight : CGFloat = UIApplication.shared.statusBarFrame.height
/// 版本号,Version 例如 1.0
let BundleShortVersionString = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

var NAVHEIGHT : CGFloat {
    switch UIDevice.current.ib_DeviceScreenType {
    case .iPhoneX,
         .iPhoneXR,
         .iPhoneXsMax:
        return 88
    default:
        return 64
    }
}

var TabBarHeight : CGFloat {
    switch UIDevice.current.ib_DeviceScreenType {
    case .iPhoneX,
         .iPhoneXR,
         .iPhoneXsMax:
        return 83
    default:
        return 49
    }
}

let unknowBalance = "-.----"


//MARK:- 通用参数
/// 获取当前时间戳
var timeStamp : String {
    let timeInterval: TimeInterval = Date().timeIntervalSince1970
    let timeStamp = Int(timeInterval)
    return "\(timeStamp)"
}

/// 获取erc20model
//var ercModel:

/// 设备名称
var ib_deviceModel : String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier
}

//  获取设备设置语言
var user_Language:String {
    return NSLocale.preferredLanguages[0]
}

enum Language : String {
    case zh_Hans = "zh-Hans"
    case en
}

/// 当前选择的语言
var ib_CurrentLangeuage : Language {
    // 不支持的设备语言 默认返回中文
    guard let boo = UserDefaults.standard.string(forKey: "langeuage") else {return .zh_Hans}
    guard let lingual = Language.init(rawValue: boo) else {return .zh_Hans}
    return lingual
}


/// 设备 UUID
var ib_uuid : String {
    let key = "U17.uuid"
    guard let data = Keychain.load(key: key) , let uuid = String(data: data, encoding: String.Encoding.utf8) else {
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {return ""}
        _ = Keychain.save(key: key, data: uuid.data)
        return uuid
    }
    return uuid
}

//MARK:- UI

/// 间距
struct Margin {
    static var line : CGFloat = 1
    static var radius : CGFloat = 10
    static var top : CGFloat = 10¡
    static var bottom : CGFloat = -10¡
    static var left : CGFloat = 15¡
    static var right : CGFloat = -15¡
    static var leading : CGFloat = 20¡
    static var trailing : CGFloat = -20¡
    static var page : CGFloat = 24¡
    static var SectionMargin : CGFloat = 40¡¡
    static var SectionHeight : CGFloat = 44¡¡
    static var ButtonHeight : CGFloat = 46¡¡
    static var safeBottom : CGFloat {
        let type = UIDevice.current.ib_DeviceScreenType
        let isIPhonex = type == .iPhoneXR || type == .iPhoneX || type == .iPhoneXsMax
        if #available(iOS 11.0, *) , isIPhonex {
            return -15
        } else {
            return 0
        }
    }
}


/// 分享
func localAppleShare(image:UIImage , share : @escaping (UIActivityViewController)->()) {
    DispatchQueue.global().async {
        ///  有时会分享失败,可能图片过大,先压缩
        guard let data = image.jpegData(compressionQuality: 0.5) else{return}
        guard let thumbImage = UIImage(data: data) else {return}
        
        
        ///  applicationActivities 可以没有元素，系统会自动选择合适的平台
        let activityController = UIActivityViewController(activityItems: [thumbImage], applicationActivities: [])
        
        /// 可以排除一些不希望的平台 UIActivityType
        activityController.excludedActivityTypes = [.airDrop, .saveToCameraRoll, .assignToContact, .copyToPasteboard, .print,]
        
        activityController.completionWithItemsHandler = {
            (type, flag, array, error) -> Swift.Void in
            print(type ?? "")
        }
        DispatchQueue.main.async {
            share(activityController)
        }
    }
}

/// 根据iPhone 6 375*667 的宽度计算宽度.
func ib_W(_ width : CGFloat)->CGFloat{
    return width * UIDevice.current.ib_DeviceScreenType.ib_pixelScale
}

/// 根据iPhone 6 的高度 计算高度
func ib_H(_ height : CGFloat)->CGFloat{
    return height * UIDevice.current.ib_DeviceScreenType.ib_pixelScale
}


struct UserSetting {
    
    
    /// 当前baseUrl
    static var currentBaseURL : Environmental {
        set{
            UserDefaults.standard.set(newValue.rawValue, forKey: "UserSetting" + "currentBaseURL")
        }get{
            if let baseUrl = UserDefaults.standard.value(forKey: "UserSetting" + "currentBaseURL") as? String,
                let evn = Environmental(rawValue: baseUrl){
                return evn
            }
            #if TEST
            return .TEST
            #else
            return .U17
            #endif
        }
    }
    
    /// 是否打印网络信息
    static var printNetWork : Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "printNetWork")
        }get{
            return UserDefaults.standard.value(forKey: "UserSetting" + "printNetWork") as? Bool ?? true
        }
    }
    
    /// EOS 钱包数量
    static var eosWalletCount : Int? {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "eosWalletCount")
        }get{
            return UserDefaults.standard.value(forKey: "UserSetting" + "eosWalletCount") as? Int
        }
    }
    
    /// ETH 钱包数量
    static var ethWalletCount : Int? {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "ethWalletCount")
        }get{
            return UserDefaults.standard.value(forKey: "UserSetting" + "ethWalletCount") as? Int
        }
    }
    
    
    /// EOS 已导入的助记词标记存储
    static var eosMnemonicsKeys : [String] {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "eosMnemonicsKeys")
        }get{
            return (UserDefaults.standard.value(forKey: "UserSetting" + "eosMnemonicsKeys") as? [String]) ?? []
        }
    }
    
    
    /// 是否同意用户协议
    static var agreeAgreement : Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "agreeAgreement")
        }get{
            return UserDefaults.standard.value(forKey: "UserSetting" + "agreeAgreement") as? Bool ?? false
        }
    }
    
    
    /// 是否同意币币兑换用户协议
    static var agreeCoinExchangeAgreement : Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "agreeCoinExchangeAgreement")
        }get{
            return UserDefaults.standard.value(forKey: "UserSetting" + "agreeCoinExchangeAgreement") as? Bool ?? false
        }
    }
    
    
    /// 是否加载过默认列表
    static var loadedDefaultAssets : Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "loadedDefaultAssets")
        }get{
            return UserDefaults.standard.value(forKey: "UserSetting" + "loadedDefaultAssets") as? Bool ?? false
        }
    }
    
    /// 是否加载过默认行情
    static var loadedDefaultQuota : Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "loadedDefaultQuota")
        }get{
            return UserDefaults.standard.value(forKey: "UserSetting" + "loadedDefaultQuota") as? Bool ?? false
        }
    }
    
    /// 是否已经备份助记词
    static var isBackupedCook : Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "isBackupedCook")
        }get{
            return UserDefaults.standard.value(forKey: "UserSetting" + "isBackupedCook") as? Bool ?? false
        }
    }
    
    /// 是否已经提示过备份助记词
    static var isBackupCookTipShowed : Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "isBackupCookTipShowed")
        }get{
            return UserDefaults.standard.value(forKey: "UserSetting" + "isBackupCookTipShowed") as? Bool ?? false
        }
    }
    
    
    /// 手势解锁的密码
    static var gestureCacheCode : String? {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "gestureCacheCode")
        }get{
            return UserDefaults.standard.value(forKey: "UserSetting" + "gestureCacheCode") as? String
        }
    }
    
    
    /// 手势解锁是否激活
    static var gestureEnable : Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "gestureEnable")
        }get{
            return UserDefaults.standard.value(forKey: "UserSetting" + "gestureEnable") as? Bool ?? false
        }
    }
    
    /// 手势解锁是否激活
    static var fingerEnable : Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "fingerEnable")
        }get{
            return UserDefaults.standard.value(forKey: "UserSetting" + "fingerEnable") as? Bool ?? false
        }
    }
    
    /// 货币单位
    static var monetaryUnit : MonetaryUnitType {
        set{
            UserDefaults.standard.set(newValue.rawValue, forKey: "UserSetting" + "monetaryUnit")
        }get{
            return MonetaryUnitType.init(rawValue: (UserDefaults.standard.value(forKey: "UserSetting" + "monetaryUnit") as? String) ?? MonetaryUnitType.CNY.rawValue) ?? .CNY
        }
    }
    
    /// 所有资产数量法币价值
    static var totalAssetsBalance : String {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "totalAssetsBalance")
        }get{
            return UserDefaults.standard.value(forKey: "UserSetting" + "totalAssetsBalance") as? String ?? "0"
        }
    }
    
    /// 安全密码
    static var secCode : String {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "secCode")
        }get{
            return UserDefaults.standard.value(forKey: "UserSetting" + "secCode") as? String ?? ""
        }
    }
    
    /// 是否隐藏余额
    static var isHideBalance : Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "isHideBalance")
        }get{
            return UserDefaults.standard.value(forKey: "UserSetting" + "isHideBalance") as? Bool ?? false
        }
    }
    
    /// 涨跌颜色
    static var isRedUp : Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: "UserSetting" + "isRedUp")
        }get{
            return (UserDefaults.standard.value(forKey: "UserSetting" + "isRedUp") as? Bool) ?? false
        }
    }
    
    /// 记录授权的dapp
    static func agreementDAPP(host:String,mark:String) {
        var agreementList = UserDefaults.standard.value(forKey: "UserSetting.agreementList") as? [String:[String]] ?? [:]
        agreementList[host] = (agreementList[host] ?? []) + [mark]
        UserDefaults.standard.setValue(agreementList, forKey: "UserSetting.agreementList")
    }
    
    /// 查看dapp是否已获取授权
    static func isAgreementDAPP(host:String,mark:String) -> Bool{
        var agreementList = UserDefaults.standard.value(forKey: "UserSetting.agreementList") as? [String:[String]] ?? [:]
        return agreementList[host]?.contains(mark) ?? false
    }
    
    /// 清除已经授权的dapp
    static func removeAgreementDAPP(host:String) {
        var agreementList = UserDefaults.standard.value(forKey: "UserSetting.agreementList") as? [String:[String]] ?? [:]
        agreementList[host] = []
        UserDefaults.standard.setValue(agreementList, forKey: "UserSetting.agreementList")
    }
    
    /// 记录授权快速交易的的dapp
    static func dapp_quickTransfer(host:String,mark:String) {
        UserDefaults.standard.set(mark, forKey: "UserSetting" + ".app_quickTransfer." + host)
    }
    
    /// 查看dapp是否已获取快速交易授权
    static func isDapp_quickTransfer(host:String,mark:String) -> Bool{
        guard let saveMark = (UserDefaults.standard.value(forKey: "UserSetting" + ".app_quickTransfer." + host) as? String) else {return false}
        return saveMark == mark
    }
    
}

let LA_BalanceHideString = "****"

enum MonetaryUnitType : String {
    case CNY
    case USD
}

extension MonetaryUnitType {
    var symbol : String {
        switch self {
        case .CNY: return "¥"
        case .USD: return "$"
        }
    }
}

