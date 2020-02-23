//
//  String+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import UIKit

extension String {
    
    /// 将数字小数点后的补位0去掉
    var zf_removeZero : String {
        guard count > 0 else { return "" }
        guard contains(".") else {return ""}
        let strs = components(separatedBy: ".")
        guard let firstStr = strs.first else {return ""}
        guard var afterPointStr = strs.last else {return strs.first ?? ""}
        while afterPointStr.last == "0" , afterPointStr.count > 0 {
            guard afterPointStr.last == "0" else {break}
            afterPointStr = afterPointStr.substring(to: afterPointStr.count - 1)
        }
        guard afterPointStr.count > 0 else {return firstStr}
        return firstStr + "." + afterPointStr
    }

    
    //时间戳转date
    func dateFromTimestamp() -> Date {
        let timeInterval:TimeInterval = TimeInterval(self.ns_String.doubleValue)
        let date = Date.init(timeIntervalSince1970: timeInterval)
        return date
    }
    
    /// 按照指定的分割规则数组,分割字符串,插入字符
    func insert(indexs:[Int],separeteBy:String?) -> String{
        guard let separeteBy = separeteBy else {return self}
        let separeteString = self as NSString
        // 每次插入前从自己原始的字符串中 截取的开始下标
        var start = 0
        // 保存拼接完成的字符串
        var targetString : String = ""
        // 循环遍历插入下标数组
        for (idx,index) in indexs.enumerated(){
            // 判断截取是否会越界
            // 1. 不会越界 截取字符串,添加分隔符
            if (index + start) <= separeteString.length{
                let newString = separeteString.substring(with: NSRange.init(location: start, length: index))
                // 最后一个不添加分隔符
                targetString.append(newString + ((idx < indexs.count - 1 && start + index < separeteString.length) ? separeteBy : ""))
                start = start + index
            }else{
                // 2. 越界了 截取到最大位数
                guard separeteString.length - start > 0 else{
                    break
                }
                let newString = separeteString.substring(with: NSRange.init(location: start, length: separeteString.length - start))
                // 最后一个不添加分隔符
                targetString.append(newString)
                break
            }
        }
        return targetString
    }
    
    func isValidateIdCard()->Bool{
        let floatRegex = "^[A-Za-z0-9]+$"
        let floatTest = NSPredicate(format: "SELF MATCHES %@",floatRegex )
        return floatTest.evaluate(with: self)
    }
    
    func isValidateUInt()->Bool{
        let floatRegex = "^\\d+$"
        let floatTest = NSPredicate(format: "SELF MATCHES %@",floatRegex )
        return floatTest.evaluate(with: self)
    }
    
    func isValidateFloat()->Bool{
        let floatRegex = "^[0-9]+(.[0-9]{1,2})?$"
        let floatTest = NSPredicate(format: "SELF MATCHES %@",floatRegex )
        return floatTest.evaluate(with: self)
    }
    
    /// 验证是否是大写字母
    func isValidateCapital()->Bool{
        let regex = "^[A-Z]+$"
        let test = NSPredicate(format: "SELF MATCHES %@",regex)
        return test.evaluate(with: self)
    }
    
    /// 验证是否是小写字母
    func isValidateLowercase()->Bool{
        let regex = "^[a-z]+$"
        let test = NSPredicate(format: "SELF MATCHES %@",regex)
        return test.evaluate(with: self)
    }
    
    /// 验证是否是英文字母
    func isValidateLetter()->Bool{
        let regex = "^[A-Za-z]+$"
        let test = NSPredicate(format: "SELF MATCHES %@",regex)
        return test.evaluate(with: self)
    }
    
    /// 传入正则表达式验证
    func isValidate(regex:String)->Bool{
        let test = NSPredicate(format: "SELF MATCHES %@",regex)
        return test.evaluate(with: self)
    }
    
    func filter(by setString:String)->String{
        let setToRemove = NSCharacterSet(charactersIn: setString).inverted
        return self.components(separatedBy: setToRemove).joined(separator: "")
    }
    
    var numberString : String {
        let setToRemove = NSCharacterSet(charactersIn: "1234567890.").inverted
        var numbers = self.components(separatedBy: setToRemove)
        var passPoint : Bool = false
        for (idx,number) in numbers.enumerated().reversed(){
            if !passPoint {
                if number.contains("."){
                    let points = number.components(separatedBy: ".")
                    if points.count != 2{
                        var pointNumber : String = ""
                        for beforePoint in points[0..<points.count-1] {
                            pointNumber.append(beforePoint.replacingOccurrences(of: ".", with: ""))
                        }
                        numbers[idx] = pointNumber.appending(".").appending(points.last ?? "")
                    }
                    passPoint = true
                }
            }else{
                numbers[idx] = number.replacingOccurrences(of: ".", with: "")
            }
        }
        return numbers.joined()
    }
    
    /// 补全小数点后几位
    mutating func formatAfterPoint(less:Int) {
        // 没有小数点的 添加小数点到最后
        if !contains(".") , less > 0{
            append(".")
        }
        if afterPoint <= less {
            for _ in afterPoint..<less {
                append("0")
            }
        }
    }
    
    /// 检测字符串的 doubleValue 是不是符合要求
    func doubleValueValidate(maxNumber:Double,afterPoint:Int) -> Bool{
        // 检测是否超过最大数字限制
        guard ns_String.doubleValue < maxNumber else {
            return false
        }
        // 如果小数点后的数字大于0 就限制
        if afterPoint > 0{
            // 限制点的数量
            guard self.components(separatedBy: ".").count <= 2 else {
                return false
            }
            // 限制小数点后的数量
            if components(separatedBy: ".").count == 2 {
                guard let afterPointString = components(separatedBy: ".").last , afterPointString.count <= afterPoint else {
                    return false
                }
                return true
            }else{
                // 使用.分割为 0-1段时 表示没有点存在.但是限制了小数点后的位数.
                return true
            }
        }else{
            // afterPoint <= 0 时, 不含有.就是合格的 doubleValue
            return !contains(".")
        }
        
        
    }
    
    ///邮箱的正则表达判断
    func isValidateEmail()->Bool {
        let emailRegex = "^(([a-zA-Z0-9]+[\\.-]?)*[a-zA-Z0-9_]+)+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$" // 正则表达式
//        let emailRegex = "^[A-Za-z0-9\\u4e00-\\u9fa5]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@",emailRegex ) // 正则表达对象
        guard emailTest.evaluate(with: self) else {return false } // 进行校验
        let subs = self.components(separatedBy: "@") // 分割前后字符串
        guard subs.count == 2 else {return false} // 校验分割后的数量
        guard subs.first!.count <= 64 && subs.last!.count <= 255 else {return false } // 校验分割后的长度
        return true // 全通过返回 true
    }
    
    //MARK: - 修改密码的正则表达判断
    func isValidatePassword()->Bool
    {
        let passwordRegex = "^(?=.*[0-9].*)(?=.*[A-Z].*)(?=.*[a-z].*).{8,20}$"
        let regextestPassword = NSPredicate(format: "SELF MATCHES %@",passwordRegex)
        return regextestPassword.evaluate(with: self)
    }

    func isValidateMobile()->Bool
    {
        let mobile = "^[1][3,4,5,7,8][0-9]{9}$"
        //"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        //        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        //        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        //        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        return regextestmobile.evaluate(with: self)
        //        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        //        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        //        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        //        if ( )
        //            || (regextestcm.evaluate(with: self)  == true)
        //            || (regextestct.evaluate(with: self) == true)
        //            || (regextestcu.evaluate(with: self) == true))
        //        {
        //            return true
        //        }
        //        return false
    }
    
    var afterPoint : Int {
        return components(separatedBy: ".").last?.count ?? 0
    }
    
    func bwy_replaceWith(notAllowType:[String:String]?)->String{
        var str = self
        notAllowType?.zf_enumerate({origin,replace in str = str.replacingOccurrences(of: origin, with: replace)})
        return str
    }
    
    var ns_String : NSString
    {
        return self as NSString
    }
    
    var url : URL? {
        return URL(string: self)
    }
    
    /// 截取字符串 并防止截取字符串崩溃
    func bwy_subString(to index : Int)->String{
        guard index >= 0 else {return self}
        return ns_String.substring(to: index)
//        return String(self[self.index(self.startIndex, offsetBy: self.count > index ? index : self.count)])
    }
    
    /// 截取某一下标左边字符串
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }

    /// 业务需要去空格检查
    var bwy_isEmpty : Bool {
        return ns_String.replacingOccurrences(of: " ", with: "").isEmpty
    }
    
    /// 清除头尾的空格
    var la_removeWhiteSpaces : String {
        return trimmingCharacters(in: .whitespaces)
    }
    
    func notAllow(_ keys : [String])->String{
        var newString = self
        for key in keys {
            newString = newString.replacingOccurrences(of: key, with: "")
        }
        return newString
    }
    
    static func priceString(value:Double)->String{
        return String.init(format: "%.2f", value)
    }
    
    func zf_attributed(font:UIFont,color:UIColor) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.font : font,
                                                             NSAttributedString.Key.foregroundColor : color])
    }
    
    func copy(times:Int)->String {
        var new = ""
        for _ in (0..<times) {
            new += self
        }
        return new
    }
    
    var intValue:Int {
        return Int(self) ?? 0
    }
    
    var doubleValue:Double{
        return Double(self) ?? 0.0
    }
    
    var cgFloatValue:CGFloat{
        return CGFloat(self.doubleValue)
    }
}

extension URL {
    
    func zf_get(parameter:String) -> String?
    {
        guard let query = query else {return nil}
        let parameters = query.components(separatedBy: "&")
        guard parameters.count > 0 else {return nil}
        for kv in parameters {
            var kv = kv.components(separatedBy: "=")
            guard kv.count >= 2 else {continue}
            let key = kv[0]
            kv.remove(at: 0)
            let value = kv.joined(separator: "=")
            guard key == parameter else {continue}
            return value
        }
        return nil
    }
    
    func zf_getPath(afterName:String) -> String?
    {
        guard pathComponents.contains(afterName) else {return nil}
        var index : Int? = nil
        for (idx,path) in pathComponents.enumerated() {
            if path == afterName {
                index = idx+1
            }
        }
        return pathComponents.bwy_obj(in: index)
    }
    
}

