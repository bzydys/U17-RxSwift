//
//  LocalizationTool.swift
//  IB_iOS
//
//  Created by 李先生 on 2018/9/6.
//  Copyright © 2018年 曾凡怡. All rights reserved.
//

import UIKit


class LocalizationTool:NSObject {
    static let shareInstance = LocalizationTool()
    
    let def = UserDefaults.standard
    var bundle : Bundle?
    
    func valueWithKey(key: String!) -> String {
        let str = NSLocalizedString(key, tableName: "Localizable", bundle: LocalizationTool.shareInstance.bundle!, value: "default", comment: "default")
        if str == "default" {
            print("\"\(key!)\" = \"\(key!)\";")
        }
        return str
    }

    func setLanguage(language:String) {
        var str = language
        if str.contains("zh-Hans") {
            //  简体中文
            str = "zh-Hans"
        } else if str.contains("zh-Hant") {
            //  繁体中文
            str = "zh-Hant"
        } else if str.contains("en") {
            //  英文
            str = "en"
        }
        def.set(str, forKey: "langeuage")
        def.synchronize()
        let path = Bundle.main.path(forResource:str , ofType: "lproj")
        bundle = Bundle(path: path ?? "")
    }
}
