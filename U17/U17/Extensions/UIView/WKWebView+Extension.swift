//
//  WKWebView+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import WebKit

extension WKWebView {
    /// 暂停播放网页内的音频、视频
    func pausePlay(){
        evaluateJavaScript("pauseVideo()") { (data, error) in
        }
        evaluateJavaScript("pauseAudio()") { (data, error) in
        }
    }
}


extension WKWebViewConfiguration {
    
    /// 注入暂停播放音乐和视频的JS
    func injectPauseJS() {
        let pauseJSString:String =
        """
var videos = document.getElementsByTagName("video");
        function pauseVideo(){
            var len = videos.length
            for(var i=0;i<len;i++){
                videos[i].pause();
            }
        }
        var audios = document.getElementsByTagName("audio");
        function pauseAudio(){
            var len = audios.length
            for(var i=0;i<len;i++){
                audios[i].pause();
            }
        }
"""
        let pauseJS = WKUserScript.init(source: pauseJSString, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        userContentController.addUserScript(pauseJS)
    }
    
    func injectPra_middleware(path:String){
        
        guard let data = NSData(contentsOfFile: path) as Data? else { return }
        
        guard let str = String(data: data, encoding: String.Encoding.utf8) else {return}
        
        let praJS = WKUserScript.init(source: str, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(praJS)
    }
}
