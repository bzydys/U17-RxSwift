
//
//  MapJSON.swift
//  AlamofireDemo
//
//  Created by 曾凡怡 on 2017/3/14.
//  Copyright © 2017年 曾凡怡. All rights reserved.
//

import UIKit
import SwiftyJSON

/// 控制台打印model.json文件中的 json 数据 或者传入字典对象
public func zf_mapJSON(_ jsonObj : Any? = nil){

    /// 打印的内部方法
    func printMap(_ jsonObj : [String : Any]){
        // 归档方法
        var coderFunction : String = "required init?(coder aDecoder: NSCoder) {\n"
        var ivarList :[String] = []
        
        print("import UIKit\nimport SwiftyJSON")
        print("class <#className#> : BaseModel ,Mapable , NSCoding {\n")
        for (key,value) in jsonObj{
            ivarList.append(key)
            if value is NSNumber {
                print("var \(key) : NSNumber?")
                coderFunction.append("\(key) = aDecoder.decodeObject(forKey: \"\(key)\") as? NSNumber\n")
            }else
                if value is [String : Any] {
                    print("var \(key) : <#modelType#>?")
                    coderFunction.append("\(key) = aDecoder.decodeObject(forKey: \"\(key)\") as? <#modelType#>\n")
                }else if value is [[String : Any]]{
                    print("var \(key) : [<#modelType#>]!")
                    coderFunction.append("\(key) = aDecoder.decodeObject(forKey: \"\(key)\") as? [<#modelType#>]\n")
                }else if value is [Any]{
                    print("var \(key) : [<#type#>]!")
                    coderFunction.append("\(key) = aDecoder.decodeObject(forKey: \"\(key)\") as? <#type#>\n")
                }else{
                    print("var \(key) : String?")
                    coderFunction.append("\(key) = aDecoder.decodeObject(forKey: \"\(key)\") as? String\n")
            }
        }
        coderFunction.append("}")
        // 归档
        print(coderFunction)
        // 解档
        print("func encode(with aCoder: NSCoder) {")
        for ivar in ivarList {
            print("aCoder.encode(\(ivar), forKey: \"\(ivar)\")")
        }
        print("}")
        print("\nrequired init?(jsonData: JSON) {\nsuper.init()\nself.update(jsonData: jsonData)\n}\nfunc update(jsonData:JSON){\n")
        
        for (key,value) in jsonObj{
            if value is NSNumber {
                print("self.\(key) = jsonData[\"\(key)\"].number")
            }else
                if value is [String : Any] {
                    print("self.\(key) = <#modelType#>(jsonData: jsonData[\"\(key)\"])")
                }else if value is [[String : Any]]{
                    print("var \(key)Arr : [<#modelType#>] = []\nfor \(key) in jsonData[\"\(key)\"].arrayValue{\n\(key)Arr.append(<#modelType#>(jsonData : \(key))!)\n}\nself.\(key) = \(key)Arr")
                }else if value is [Any]{
                    print("self.\(key) = jsonData[\"\(key)\"].arrayObject as? [<#type#>] ?? []")
                }else{
                    print("self.\(key) = jsonData[\"\(key)\"].string")
            }
        }
        print("\n}\nvar jsonData : JSON {\nvar json = JSON()\n")

        for (key,value) in jsonObj{
            if value is NSNumber {
                print("json[\"\(key)\"].number = \(key)")
            }else
                if value is [String : Any] {
                    print("json[\"\(key)\"] = \(key)?.jsonData ?? JSON()")
                }else if value is [[String : Any]]{
                    print("json[\"\(key)\"] = JSON(\(key).map{$0.jsonData})")
                }else if value is [Any]{
                    print("json[\"\(key)\"] = \(key).array as? [<#type#>] ?? []")
                }else{
                    print("json[\"\(key)\"].string = \(key)")
            }
        }
        print("return json\n}\n}")
    } 
    
    
    
    /// 解析传入的JSON
    if let jsonObj = jsonObj as? [String : Any] {
        printMap(jsonObj)
        return
    }
    
    /// 解析传入的JSON
    if let jsonObj = (jsonObj as? JSON)?.dictionaryObject {
        printMap(jsonObj)
        return
    }
    
    /// 读取文件中的JSON
    guard let jsonData = zf_jsonData(forResource:"model.json") else{
        return
    }
    
    //转换成Dic
    guard let jsonDic = zf_JSONDicFrom(jsonData:jsonData) else {
        return
    }
    
    printMap(jsonDic)
}


func zf_jsonData(forResource:String)->Data?{
    /// 读取文件中的JSON
    guard let filePath = Bundle.main.path(forResource: "model.json", ofType: nil) else{
        print("找不到JSON路径")
        return nil
    }
    
    //读取data
    guard let jsonData = NSData.init(contentsOfFile: filePath) else{
        print("读取Data失败")
        return nil
    }
    
    return jsonData as Data
}

func zf_JSONDicFrom(jsonData : Data)->[String:Any]?{
    //将data转换为Anyobject
    guard let jsonObj = try? JSONSerialization.jsonObject(with:jsonData , options: JSONSerialization.ReadingOptions.mutableContainers) else{
        print("转换json失败")
        return nil
    }
    //转换成Dic
    guard let jsonDic = jsonObj as? [String:Any] else {
        print("转换字典失败")
        return nil
    }
    return jsonDic
}
