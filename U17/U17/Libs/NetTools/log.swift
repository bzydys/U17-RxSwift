
//
//  ZFRefreshHeader.swift
//  WeiboSwift
//
//  Created by 曾凡怡 on 2017/1/9.
//  Copyright © 2017年 曾凡怡. All rights reserved.
//
import SwiftyLog

import UIKit
//1. Build Settings 搜索并展开 Other C Flags；
//2. 点击 +；
//3. 输入 -D DEBUG 。
//4. 代码中加入 #if DEBUG <your code> #endif

fileprivate let logger : Logger = {
    let logger = Logger.shared
    #if DEBUG
    logger.level = .info
    logger.ouput = .debugerConsoleAndFile
    #else
    logger.level = .info
    logger.ouput = .debugerConsoleAndFile
//    logger.level = .none
    #endif
    return logger
}()

private let dateFormatter : DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd HH:mm:ss:SSS"
    return dateFormatter
}()

//fileprivate func logTime(subfix:String){
//    logger.timeFormate = { date -> String in
//        return subfix + " " + dateFormatter.string(from: date)
//    }
//}

private var currentTime : Date {
    return Date(timeIntervalSinceNow: 0)
}

public func logg(_ item: Any?,
         file: String = #file,
         method: String = #function,
         line: Int = #line)
{
    #if DEBUG
//        logTime(subfix: "✏️")
        guard let obj = item else {
            logger.d("\(item ?? "null")",currentTime: currentTime,fileName: file,functionName: method,lineNumber: line,thread: Thread.current)
            return
        }
        guard let jsonString = transformJSONString(from: obj) else {
            logger.d("\(obj)",currentTime: currentTime,fileName: file,functionName: method,lineNumber: line,thread: Thread.current)
            return
        }
    logger.d(jsonString,currentTime: currentTime,fileName: file,functionName: method,lineNumber: line,thread: Thread.current)
    #endif
}


public func logurl(_ item: Any,
           file: String = #file,
           method: String = #function,
           line: Int = #line)
{
    #if DEBUG
//    logTime(subfix: "🌏")
    logger.i("\(item)",currentTime: currentTime,fileName: file,functionName: method,lineNumber: line,thread: Thread.current)
    #endif
}

public func logerr(_ item: Any,
            file: String = #file,
            method: String = #function,
            line: Int = #line)
{
    #if DEBUG
//    logTime(subfix: "❣️")
    logger.e("\(item)",currentTime: currentTime,fileName: file,functionName: method,lineNumber: line,thread: Thread.current)
    #endif
}


public func logobj(_ item: Any,
            file: String = #file,
            method: String = #function,
            line: Int = #line)
{
    #if DEBUG
//    logTime(subfix: "🐘")
    logger.i("\(item)",currentTime: currentTime,fileName: file,functionName: method,lineNumber: line,thread: Thread.current)
    #endif
}

/**
 字典转换为JSONString
 
 - parameter dictionary: 字典参数
 
 - returns: JSONString
 */
fileprivate func transformJSONString(from object:Any) -> String? {
    if (!JSONSerialization.isValidJSONObject(object)) {
        return nil
    }
    let jsonData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
    guard let data = jsonData else {return nil}
    let JSONString = NSString(data:data,encoding: String.Encoding.utf8.rawValue)
    return JSONString as String?
    
}
