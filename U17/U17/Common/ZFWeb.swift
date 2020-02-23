//
//  ZFWeb.swift
//  Lark
//
//  Created by ZengFanyi on 2019/3/22.
//  Copyright © 2019 曾凡怡. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit

class ZFWebController: CustomViewController<ZFWebView>{
    
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    
    var viewModel : ZFWebViewModel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupUI()
    }
    
    let urlStr : String?
    
    init(url:String?) {
        self.urlStr = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        viewModel = ZFWebViewModel(view:cView,bag:bag)
        // 加载url
        guard let urlStr = self.urlStr else {return}
        guard let url = URL(string: urlStr) else {return}
        cView.webView.load(URLRequest(url: url))
    }
}

class ZFWebViewModel : NSObject , UIWebViewDelegate,WKNavigationDelegate {
   
    
    let view : ZFWebView
    let bag : DisposeBag
    
    init(view:ZFWebView,
         bag:DisposeBag) {
        self.view = view
        self.bag = bag
        super.init()
        view.webView.navigationDelegate = self
     
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView.evaluateJavaScript("document.title") {[weak self] (title, error) in
            guard let `self` = self else {return}
            guard let title = title as? String else {return}
            self.view.navBar.titleLabel.text = title
            self.view.navBar.titleLabel.lineBreakMode = .byTruncatingHead
        }
        
    }
    
//
//    func setupBlueSocket(){
//        serverSocket = GCDAsyncSocket.init(delegate: self, delegateQueue: DispatchQueue.main)
//        do{
//            try serverSocket?.accept(onInterface: "127.0.0.1", port: 50005)
//            logg("监听成功")
//        }catch{
//            logg("监听失败")
//            logerr(error)
//        }
//    }
//
//    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
//        logg("收到连接地址" + (newSocket.connectedHost ?? "无效") + "端口号\(newSocket.connectedPort)")
//        let reply = "connected"
//        sock.write(reply.data, withTimeout: -1, tag: 1)
//        //再次准备读取Data,以此来循环读取Data
//        newSocket.readData(withTimeout: -1, tag: 0)
//        newSocket.delegate = self
//    }
//
//    var connectedPort : [UInt16] = []
//
//    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
//        let message = String(data: data, encoding: String.Encoding.utf8) ?? "解析消息失败"
//
//        if connectedPort.contains(sock.connectedPort) {
//            logg("新消息!!! :\(message)")
//        }else{
//            startConnect(sock:sock,message: message)
//            connectedPort.append(sock.connectedPort)
//            logg("发送40")
//            sock.write("40/scatter".data, withTimeout: -1, tag: 1)
//        }
//        logg("准备再次读取")
//        //再次准备读取Data,以此来循环读取Data
//        sock.readData(withTimeout: -1, tag: 0)
//    }
//
//    func startConnect(sock:GCDAsyncSocket,message:String){
//        // 获取收到的握手请求
//        let headers = message.components(separatedBy: "\r\n")
//        // 解析为字典
//        let allHeaders = headers.compactMap{ line -> [String:String] in
//            let kv = line.components(separatedBy: ":")
//            guard kv.count == 2 else {
//                return ["requestLine":kv.first ?? ""]
//            }
//            return [kv[0].replacingOccurrences(of: " ", with: ""):kv[1].replacingOccurrences(of: " ", with: "")]
//            }.bwy_mergeAllDictionary()
//        guard let allHeader = allHeaders else {return }
//        guard let requestModel = WKRequestHandelModel(jsonData: JSON(allHeader)) else {return}
//        guard requestModel.Connection == "Upgrade" else {return}
//        guard requestModel.Upgrade == "websocket" else { return }
//        guard let rSecKey = requestModel.SecWebSocketKey else {return}
//        // 返回的 sec-key
//        var secKey = rSecKey + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
//        secKey = secKey.sha1().data.base64EncodedString()
//        logg(secKey)
//
//        let reply =
//        """
//        HTTP/1.1 101 Switching Protocols
//        Upgrade: websocket
//        Connection: Upgrade
//        Sec-WebSocket-Accept: \(secKey)
//        Sec-WebSocket-Extensions: permessage-deflate
//        """
//        sock.write(reply.data, withTimeout: -1, tag: 0)
//        //再次准备读取Data,以此来循环读取Data
//        sock.readData(withTimeout: -1, tag: 0)
//    }
//
//    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
//        logg("socketDidDisconnect : \(err)")
//    }
    
}

class ZFWebView: ZFCustomNavView {
    
    let webView = WKWebView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI 初始化
    func setupUI()  {
        webView.scrollView.backgroundColor = .L2
        addSubview(webView)
//        webView.dk_progressLayer = DKProgressLayer.init(frame: CGRect(x: 0, y: NAVHEIGHT, width: bounds.width, height: 2))
//        webView.dk_progressLayer.progressStyle = .gradual
//        layer.addSublayer(webView.dk_progressLayer)
    }
    /// 自动布局代码
    override func layoutSubviews() {
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        super.layoutSubviews()
    }
    
}


import UIKit
import SwiftyJSON
class WKRequestHandelModel : BaseModel ,Mapable {
    
    var SecWebSocketVersion : String?
    var AcceptEncoding : String?
    var UserAgent : String?
    var SecWebSocketKey : String?
    var requestLine : String?
    var SecWebSocketExtensions : String?
    var Connection : String?
    var AcceptLanguage : String?
    var CacheControl : String?
    var Pragma : String?
    var Upgrade : String?

    required init?(jsonData: JSON) {
        super.init()
        self.update(jsonData: jsonData)
    }
    
    func update(jsonData:JSON){
        
        self.SecWebSocketVersion = jsonData["Sec-WebSocket-Version"].string
        self.AcceptEncoding = jsonData["Accept-Encoding"].string
        self.UserAgent = jsonData["User-Agent"].string
        self.SecWebSocketKey = jsonData["Sec-WebSocket-Key"].string
        self.requestLine = jsonData["requestLine"].string
        self.SecWebSocketExtensions = jsonData["Sec-WebSocket-Extensions"].string
        self.Connection = jsonData["Connection"].string
        self.AcceptLanguage = jsonData["Accept-Language"].string
        self.CacheControl = jsonData["Cache-Control"].string
        self.Pragma = jsonData["Pragma"].string
        self.Upgrade = jsonData["Upgrade"].string
        
    }
}
