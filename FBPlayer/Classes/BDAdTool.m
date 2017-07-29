//
//  BDAdTool.m
//  FBPlayer
//
//  Created by apple on 2017/7/29.
//  Copyright © 2017年 王健. All rights reserved.
//

#import "BDAdTool.h"

static BDAdTool * instance = NULL;
@implementation BDAdTool

+(BDAdTool*)shareInstance
{
    if(instance == NULL){
        instance = [[BDAdTool alloc] init];
    }
    return instance;
}

-(id)init
{
    self = [super init];
    return self;
}

- (NSString *)publisherId
{
    return @"e6c18c22";
}
-(NSString*)adPos
{
    return @"2006080";
}
-(BaiduMobAdView*)barAdView
{
    if(shareAdView == nil){
        shareAdView = [[BaiduMobAdView alloc] init];
        shareAdView.AdUnitTag = [self adPos];
        shareAdView.AdType = BaiduMobAdViewTypeBanner;
        shareAdView.delegate = self;
    }
    return shareAdView;
}

//点击关闭的时候移除广告
- (void)didAdClose {
    [shareAdView removeFromSuperview];
    shareAdView.delegate = nil;
    [shareAdView release];
    shareAdView = nil;
}
@end
