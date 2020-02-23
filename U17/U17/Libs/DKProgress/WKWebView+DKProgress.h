//
//  WKWebView+DKProgress.h
//  Lark
//
//  Created by ZengFanyi on 2019/4/30.
//  Copyright © 2019 曾凡怡. All rights reserved.
//

#import <WebKit/WebKit.h>

#import <UIKit/UIKit.h>

@class DKProgressLayer;

@interface WKWebView (DKProgress)

@property (nonatomic, strong) DKProgressLayer *dk_progressLayer;
/** 是否显示加载进度条, 默认YES */
@property (nonatomic, assign) BOOL dk_showProgressLayer;

//- (void)dk_showCustomProgressView;

@end

