//
//  BDAdTool.h
//  FBPlayer
//
//  Created by apple on 2017/7/29.
//  Copyright © 2017年 王健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMobAdSDK/BaiduMobAdDelegateProtocol.h"
#import <BaiduMobAdSDK/BaiduMobAdView.h>

@interface BDAdTool : NSObject<BaiduMobAdViewDelegate>
{
    BaiduMobAdView * shareAdView;
}
+(BDAdTool*)shareInstance;
-(BaiduMobAdView*)barAdView;
@end
