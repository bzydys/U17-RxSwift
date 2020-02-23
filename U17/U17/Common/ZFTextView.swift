//
//  BWYEditorTextController.swift
//  JsonTable
//
//  Created by 曾凡怡 on 2017/3/27.
//  Copyright © 2017年 曾凡怡. All rights reserved.
//

import UIKit
enum BWYTextLimitType : String{
    case All = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890"             // 字母数字都可以
    case Float = "1234567890."                                                              // 小数
    case UInt = "1234567890"                                                                // 正整数
    case Letter = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"                    // 英文字母
    case Capital = "QWERTYUIOPASDFGHJKLZXCVBNM"                                             // 大写字母
    case Lowercase = "qwertyuiopasdfghjklzxcvbnm"                                           // 小写字母
    /// 密码
    case Password = "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
    /// 十六进制
    case Hexadecimal = "0123456789abcdefABCDEFXx"
    /// 助记词
    case Mnemonic = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM "
    /// 搜索框
    case searchBar = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890 _"
}

class ZFTextField : UITextField , UITextFieldDelegate {
    
    /// 限制输入的类型
    var limitType : BWYTextLimitType? {
        didSet{
            guard let limit = limitType else {
                keyboardType = .default
                return
            }
            switch limit {
            case .Float:
                keyboardType = .decimalPad
            case .UInt:
                keyboardType = .numberPad
            case .All,.Letter,.Capital,.Lowercase,.Password,.Mnemonic,.searchBar:
                keyboardType = .asciiCapable
            default:
                break
            }
        }
    }
    /// 限制输入的最大数字
    var maxNumber : Double?
    /// 小数点后有几位
    var afterPoint : Int?
    /// 最大字符数量
    var maxCount : Int?
    /// 文字改变的通知
    var textChange : ((ZFTextField,String?)->())?
    /// 点击了回车按钮的 block
    var returnAction : ((UITextField) -> Bool)?

    var clearAction : ((UITextField) -> Bool)?
    
    /// 不允许输入的字符
    var notAllow : [String:String]?
    
    // 分割间隔
    var inserts : [Int]?
    // 分割符号
    var separete : String?
    
    // 取出 没有分隔符和不允许输入的字符的的字符串
    // 取出 没有分隔符的字符串
    var pureText : String {
        get{
            guard var str = pureString() else {return ""}
            str = str.bwy_replaceWith(notAllowType: notAllow)
            if let maxCount = maxCount , (str.count) > maxCount{str = str.ns_String.substring(to: maxCount)}
            return str
        }
        set{
            subMaxCount()
            replaceNotAllowString()
            pureString(newValue:newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(noti:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    func setLeftImage(margin:CGFloat,image:UIImage){
        let icon = UIImageView(image: image)
        // 设置左右两边的margin 添加到宽度中
        icon.bounds = CGRect(x: 0, y: 0, width: icon.bounds.width+margin*2, height: icon.bounds.height)
        // 图片居中显示
        icon.contentMode = .center
        leftView = icon
        leftViewMode = .always
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return returnAction?(self) ?? true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return clearAction?(self) ?? true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 检查是否包含不允许输入的字符
        guard string == string.bwy_replaceWith(notAllowType: notAllow) else {return false}
        if let newString = textField.text?.ns_String.replacingCharacters(in: range, with: string){
            // 进行分割显示
            if let inserts = inserts {
                // 限制文字最大数量
                if maxCount == nil {
                    maxCount = 0
                    for number in inserts{maxCount! += number}
                }
                
                // 文字类型限制
                guard let limit = limitType else {return false}
                // 最大长度限制
                guard (textField.text ?? "").filter(by: limit.rawValue).count + string.filter(by: limit.rawValue).count - range.length <= maxCount! else{return false}
                // 过滤文字后如果没有有用字符串则返回
                let inputReplaceText = string.filter(by: limit.rawValue)
                guard !(text != "" && inputReplaceText == "") else {return false}
                
                // 记录之前选中的位置
                let selectRange = selectedRange
                
                // 替换文字
                let text_loc = textFieldSeperateString(inputString: (textField.text ?? ""),selectRange:selectRange, range: range, replacementText: inputReplaceText , seperate: separete, inserts: inserts, filterSet: limit.rawValue)
                textField.text = text_loc.text
                setSelectedRange(range: NSRange.init(location: selectRange.location + text_loc.indexOffset, length: 0))
                textChange?(self,self.text)
                return false
            }

            // 检查是否限制了类型
            if var limitType = limitType?.rawValue  {
                if let separete = separete {limitType = limitType.appending(separete)}
                // 过滤字符串
                guard string == string.filter(by: limitType) else {
                    return false
                }
            }
            
            // 检测是否超过最大数字限制
            if let maxNumber = maxNumber {
                return newString.doubleValueValidate(maxNumber: maxNumber, afterPoint: afterPoint ?? 0)
            }
        }
        
        
        
        guard let maxCount = maxCount else {return true}
        /// 不是中文的直接截取
        let currentCount = text?.count ?? 0 // textView.ns_text.length
        let newTextCount = string.count
        
        /// 正常截取最大范围
        func subMaxRange()->Bool{
            
            // 判断是否已经超出了最大范围
            guard currentCount <= maxCount && self.text != nil else {
                self.text = self.text!.ns_String.substring(to: maxCount)
                return false
            }
            
            if  newTextCount + currentCount > maxCount // (text as NSString).length + count > maxCount
            {
                // 超出限制截取超出部分
                let subStr = NSString(string: string).substring(to: maxCount - currentCount)
                guard subStr.count > 0 else {
                    return false
                }
                let mStr = NSMutableString(string: text ?? "")
                mStr.insert(subStr, at: range.location)
                text = mStr as String
                return false
            }else{
                return true
            }
        }
        
        // 不是中文就正常截取
        guard let lang = UITextInputMode.activeInputModes.first?.primaryLanguage , lang == "zh-Hans" else{
            return subMaxRange()
        }
        
        // 没有高亮部分(拼音部分)就通过 正常截取
        guard let isPinyin = self.markedTextRange?.isEmpty , isPinyin == false else {
            return subMaxRange()
        }
        
        return true
    }
    
    @objc private func textChanged(noti:Notification)
    {
        guard (noti.object as? ZFTextField) == self else {return}
        // 没有限制不操作
        if let maxCount = maxCount , (self.text?.ns_String.length ?? 0) > maxCount {
            // 检查是否有拼音存在,没有就截取范围内的
            if let text = self.text , !self.isPinyin {
                self.text = String(text[..<text.index(text.startIndex, offsetBy: maxCount)])
            }
        }
        guard (noti.object as? ZFTextField) == self else {return}
        
        textChange?(self,self.text)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func subMaxCount(){
        if let maxCount = maxCount , (text?.count ?? 0) > maxCount{
            text = text?.ns_String.substring(to: maxCount)
        }
    }
    
    private func replaceNotAllowString(){
        // 检查是否包含不允许输入的字符
        text = text?.bwy_replaceWith(notAllowType: notAllow)
    }
    
    private func pureString()->String?{
        if inserts != nil && limitType != nil{
            return text?.filter(by: limitType!.rawValue)
        }else{
            return text
        }
    }
    private func pureString(newValue:String){
        if inserts != nil && limitType != nil{
            text = newValue.filter(by: limitType!.rawValue).insert(indexs: inserts!, separeteBy: separete)
        }else{
            text = newValue
        }
    }
}


class ZFTextView : UITextView , UITextViewDelegate {
    /// 限制输入的类型
    var limitType : BWYTextLimitType?
    var maxNumber : Double?
    var afterPoint : Int?
    var maxCount : Int?
    var textChange : ((String)->())?
    var inserts : [Int]?
    var separete : String?
    var notAllow : [String:String]?
    var placeHolder : (String,UIFont,UIColor)? {
        didSet
        {
            if placeHolder != nil {
                setPlaceHolder()
            }
        }
    }
    
    lazy var placeHolderLabel : UILabel = UILabel().set(text: placeHolder!.0).set(font:placeHolder!.1).set(color:placeHolder!.2)
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
    }
    
    func setupUI(){
        // 事件监听
        delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(noti:)), name: UITextView.textDidChangeNotification, object: nil)
        isScrollEnabled = true
    }
    
    // 拖动时收起键盘
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        resignFirstResponder()
    }
    
    // MARK: - placeHolder 设置
    func setPlaceHolder(){
        
        addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(5)
            make.top.equalTo(self).offset(8)
        }
        
        // 监听文字改变 决定是否隐藏
        let _ = rx.text
            .map({($0?.count ?? 0) > 0})
            .takeUntil(rx.deallocated)
            .subscribe({[weak self] (event) in
                self?.placeHolderLabel.isHidden = event.element ?? false
        })
    }
    
    // MARK: - 截取文字处理
    // 取出 没有分隔符的字符串
    var pureText : String {
        get{
            guard var str = pureString() else {return ""}
            str = str.bwy_replaceWith(notAllowType: notAllow)
            if let maxCount = maxCount , (str.count) > maxCount{str = str.ns_String.substring(to: maxCount)}
            return str
        }
        set{
            subMaxCount()
            replaceNotAllowString()
            pureString(newValue:newValue)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        // 检查是否包含不允许输入的字符
        guard text == text.bwy_replaceWith(notAllowType: notAllow) else {return false}
        if let newString = textView.text?.ns_String.replacingCharacters(in: range, with: text){
            // 进行分割显示
            if let inserts = inserts {
                // 限制文字最大数量
                if maxCount == nil {
                    maxCount = 0
                    for number in inserts{maxCount! += number}
                }
                
                // 文字类型限制
                guard let limit = limitType else {return false}
                // 最大长度限制
                guard textView.text.filter(by: limit.rawValue).count + text.filter(by: limit.rawValue).count - range.length <= maxCount! else{return false}
                // 过滤文字后如果没有有用字符串则返回
                let inputReplaceText = text.filter(by: limit.rawValue)
                guard !(text != "" && inputReplaceText == "") else {return false}
                
                // 记录之前选中的位置
                let selectRange = selectedRange
                
                // 替换文字
                let text_loc = textFieldSeperateString(inputString: textView.text,selectRange:selectRange, range: range, replacementText: inputReplaceText , seperate: separete, inserts: inserts, filterSet: limit.rawValue)
                textView.text = text_loc.text
                selectedRange = NSRange.init(location: selectRange.location + text_loc.indexOffset, length: 0)
                textChange?(self.text)
                return false
            }
            
            // 检查是否限制了类型
            if var limitType = limitType?.rawValue  {
                if let separete = separete {limitType = limitType.appending(separete)}
                // 过滤字符串
                guard text == text.filter(by: limitType) else {
                    return false
                }
            }
            
            // 检测是否超过最大数字限制
            if let maxNumber = maxNumber {
                return newString.doubleValueValidate(maxNumber: maxNumber, afterPoint: afterPoint ?? 0)
            }
        }
        

        
        guard let maxCount = maxCount else {return true}
        /// 不是中文的直接截取
        let currentCount = textView.text?.count ?? 0 // textView.ns_text.length
        let newTextCount = text.count
        
        /// 正常截取最大范围
        func subMaxRange()->Bool{
            
            // 判断是否已经超出了最大范围
            guard currentCount <= maxCount else {
                textView.text = textView.text.ns_String.substring(to: maxCount)
                return false
            }
            
            if  newTextCount + currentCount > maxCount // (text as NSString).length + count > maxCount
            {
                // 超出限制截取超出部分
                let subStr = NSString(string: text).substring(to: maxCount - currentCount)
                guard subStr.count > 0 else {
                    return false
                }
                let mStr = NSMutableString(string: textView.text ?? "")
                mStr.insert(subStr, at: range.location)
                textView.text = mStr as String
                return false
            }else{
                return true
            }
        }
        
        // 不是中文就正常截取
        guard let lang = UITextInputMode.activeInputModes.first?.primaryLanguage , lang == "zh-Hans" else{
            return subMaxRange()
        }
        
        // 没有高亮部分(拼音部分)就通过 正常截取
        guard let isPinyin = textView.markedTextRange?.isEmpty , isPinyin == false else {
            return subMaxRange()
        }
        
        return true
    }
    
    
    @objc private func textChanged(noti:Notification)
    {
        guard (noti.object as? ZFTextView) == self else {return}
        // 没有限制不操作
        if let maxCount = maxCount , self.text.ns_String.length > maxCount {
            // 检查是否有拼音存在,没有就截取范围内的
            if let text = self.text , !self.isPinyin {
                self.text = String(text[..<text.index(text.startIndex, offsetBy: maxCount)])
                
            }
        }
        guard (noti.object as? ZFTextView) == self else {return}
        
        textChange?(self.text)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func subMaxCount(){
        if let maxCount = maxCount , text.count > maxCount{
            text = text.ns_String.substring(to: maxCount)
        }
    }
    
    private func replaceNotAllowString(){
        // 检查是否包含不允许输入的字符
        text = text?.bwy_replaceWith(notAllowType: notAllow)
    }
    
    private func pureString()->String?{
        if inserts != nil && limitType != nil{
            return text.filter(by: limitType!.rawValue)
        }else{
            return text
        }
    }
    private func pureString(newValue:String){
        if inserts != nil && limitType != nil{
            text = newValue.filter(by: limitType!.rawValue).insert(indexs: inserts!, separeteBy: separete)
        }else{
            text = newValue
        }
    }
}

/// 根据各项参数得出分隔符分割后的字符串以及光标偏移量
///
/// - Parameters:
///   - inputString: textView 当前的 text
///   - selectRange: 更改 text 之前的选中范围
///   - range: 需要更改的范围
///   - replacementText: 需要更改的文字
///   - seperate: 分隔符
///   - inserts: 插入的间隔
///   - filterSet: 限制的字符
/// - Returns: 最终结果赋值给 text
func textFieldSeperateString(inputString:String,selectRange:NSRange,range:NSRange,replacementText:String,seperate:String?,inserts:[Int],filterSet:String)->(text:String,indexOffset:Int){
    let newString = inputString.ns_String.replacingCharacters(in: range, with: replacementText)
    let returnString = newString.filter(by: filterSet).insert(indexs: inserts, separeteBy: seperate)
    var operatorOffset = replacementText.count
    // 1. 删除和增加的情况
    if replacementText == "" {
        // 没有选中文字时正常删除
        if selectRange.length == 0 {
            // 操作以后的偏移量 判断是不是在最左边和
            operatorOffset = (selectRange.location > 0 ? -1 : 0)
            // 删除的时候左移
            if replacementText == "" && selectRange.location > 2
            {
                // 删除前的左边第二个是不是分隔符
                operatorOffset = inputString.ns_String.substring(with: NSRange.init(location: selectRange.location-2, length: 1)) == seperate ? operatorOffset - 1 : operatorOffset
            }
        }else{
            // 选中了 判断 location 左边是不是分隔,如果是 offset-1
            if replacementText == "" && selectRange.location > 1
            {
                // 删除前的左边第二个是不是分隔符
                operatorOffset = inputString.ns_String.substring(with: NSRange.init(location: selectRange.location-1, length: 1)) == seperate ? operatorOffset - 1 : operatorOffset
            }
        }
        
    }else{
        // 防止越界的情况下判断光标右边是否是空格
        // 正常输入情况
        if returnString.count > selectRange.location + 1{
            if returnString.ns_String.substring(with: NSRange.init(location: selectRange.location, length: 1)) == seperate {
                operatorOffset += 1
            }
        }else {
            // 粘贴时
            // 操作前空格数 inputString
            let beforeCount = inputString.filter(by: filterSet).insert(indexs: inserts, separeteBy: seperate).count - inputString.filter(by: filterSet).count
            let afterCount = returnString.count - returnString.filter(by: filterSet).count
            // 偏移操作后,多出或者少了多少个空格
            operatorOffset += afterCount - beforeCount
            // 当全局的空格数量不变,检查更改部分是否有空格
            if beforeCount == afterCount {
                operatorOffset += replacementText.insert(indexs: inserts, separeteBy: seperate).count - replacementText.count
            }
        }
    }
    return (returnString,operatorOffset)
}


extension UITextField{
    
    var isPinyin : Bool {
        // 检查是不是中文输入法
        guard let lang = UITextInputMode.activeInputModes.first?.primaryLanguage , lang == "zh-Hans" else{
            return false
        }
        
        
        // 获取 蓝色部分文字
        guard let markedTextRange = markedTextRange else {
            return false
        }
        
        // 蓝色部分不为空 就是中文输入中
        guard !markedTextRange.isEmpty else {
            return true
        }
        
        // 截取的文字不为空 则是中文
        return !(text(in: markedTextRange)?.isEmpty ?? false)
    }
    
    /// 获取当前选中的范围
    var selectedRange : NSRange {
        //        let beginning = beginningOfDocument
        //        let selectedRange = selectedTextRange
        //        let selectionStart = selectedRange.start
        //        let selectionEnd = selectedRange.end
        let location = offset(from: beginningOfDocument, to: selectedTextRange!.start)
        let length = offset(from: selectedTextRange!.start, to: selectedTextRange!.end)
        return NSRange.init(location: location, length: length)
    }
    
    /// 选中某个范围
    func setSelectedRange(range:NSRange){
        let startPosition = position(from: beginningOfDocument, offset: range.location)!
        let endPosition = position(from: beginningOfDocument, offset: range.location)!
        let selectionRange = textRange(from: startPosition, to: endPosition)
        selectedTextRange = selectionRange
    }
}
extension UITextView {
    
    var isPinyin : Bool {
        // 检查是不是中文输入法
        guard let lang = UITextInputMode.activeInputModes.first?.primaryLanguage , lang == "zh-Hans" else{
            return false
        }
        
        
        // 获取 蓝色部分文字
        guard let markedTextRange = markedTextRange else {
            return false
        }
        
        // 蓝色部分不为空 就是中文输入中
        guard !markedTextRange.isEmpty else {
            return true
        }
        
        // 截取的文字不为空 则是中文
        return !(text(in: markedTextRange)?.isEmpty ?? false)
    }
    
}
