//
//  BaseModel.swift
//  WeiboSwift
//
//  Created by 曾凡怡 on 2017/1/5.
//  Copyright © 2017年 曾凡怡. All rights reserved.
//


import SwiftyJSON




public protocol Mapable {
    init?(jsonData:JSON)
}

public protocol Cachable {
    
}

extension Cachable {
    // 存储路径
    static var caches : String {
        
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! + "/" + fileName.uppercased(with: nil) + "/"
    }
    
    /// 文件名
    static var fileName : String { return "\(Self.self)"}
    
    /// 文件目录
    private static var savePath : String {
        return caches + fileName + ".plist"
    }
    
    static func pathWith(dirName : String, _ saveName:String?) -> String {
        return saveName == nil ? savePath : (caches + dirName + saveName! + ".plist")
    }
    
    /// 归档当前类型,rootObject 可以是数组或者单个Model的实例对象
    static func archiver(dirName:String = "",rootObject : Any, saveName : String? = nil){
        if !FileManager.default.fileExists(atPath: caches + dirName) {
            try? FileManager.default.createDirectory(atPath: caches + dirName, withIntermediateDirectories: true, attributes: nil)
        }
        NSKeyedArchiver.archiveRootObject(rootObject, toFile: pathWith(dirName:dirName,saveName))
    }
    
    /// 解档当前类型 或指定路径
    static func unarchiver(dirName : String = "" , _ saveName : String? = nil)-> Any? {
        //解档出来的元素
        return NSKeyedUnarchiver.unarchiveObject(withFile: pathWith(dirName:dirName, saveName))
    }
    
    /// 删除存储的 plist
    static func deleteArchiver(dirName : String = "" , _ saveName : String? = nil){
        if FileManager.default.isDeletableFile(atPath: pathWith(dirName:dirName,saveName)) {
            try? FileManager.default.removeItem(atPath: pathWith(dirName:dirName,saveName))
        }
    }
    
    static func loadList(dirName:String = "")->[Any]{
        guard let idArr = try? FileManager.default.contentsOfDirectory(atPath: self.caches + dirName) else {return []}
        let models = idArr.map{$0.replacingOccurrences(of: ".plist", with: "")}.compactMap{unarchiver(dirName:dirName,$0)}
        return models
    }
}


public class BaseModel : NSObject, Cachable {
    
//    // 存储路径
//    static var caches : String {return
//        NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! + "/" + fileName.uppercased(with: nil) + "/"
//    }
//
//    /// 文件名
//     private static var fileName : String { return NSStringFromClass(self) as String}
//
//    /// 文件目录
//    private static var savePath : String {
//        return caches + fileName + ".plist"
//    }
//
//    class func pathWith(dirName : String, _ saveName:String?) -> String {
//        return saveName == nil ? savePath : (caches + dirName + saveName! + ".plist")
//    }
//
//    /// 归档当前类型,rootObject 可以是数组或者单个Model的实例对象
//    class func archiver(dirName:String = "",rootObject : Any, saveName : String? = nil){
//        if !FileManager.default.fileExists(atPath: caches + dirName) {
//            try? FileManager.default.createDirectory(atPath: caches + dirName, withIntermediateDirectories: true, attributes: nil)
//        }
//        NSKeyedArchiver.archiveRootObject(rootObject, toFile: pathWith(dirName:dirName,saveName))
//    }
//
//    /// 解档当前类型 或指定路径
//    class func unarchiver(dirName : String = "" , _ saveName : String? = nil)-> Any? {
//        //解档出来的元素
//        return NSKeyedUnarchiver.unarchiveObject(withFile: pathWith(dirName:dirName, saveName))
//    }
//
//    /// 删除存储的 plist
//    class func deleteArchiver(dirName : String = "" , _ saveName : String? = nil){
//        if FileManager.default.isDeletableFile(atPath: pathWith(dirName:dirName,saveName)) {
//            try? FileManager.default.removeItem(atPath: pathWith(dirName:dirName,saveName))
//        }
//    }
//
//    class func loadList(dirName:String = "")->[Any]{
//        guard let idArr = try? FileManager.default.contentsOfDirectory(atPath: self.caches + dirName) else {return []}
//        let models = idArr.map{$0.replacingOccurrences(of: ".plist", with: "")}.compactMap{unarchiver(dirName:dirName,$0)}
//        return models
//    }
}
