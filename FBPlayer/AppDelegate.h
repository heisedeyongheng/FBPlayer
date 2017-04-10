//
//  AppDelegate.h
//  Anna
//
//  Created by 王健 on 13-8-6.
//  Copyright (c) 2013年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,SWTabBarDelegate>
{
    UIImageView * welcome;
    
    SWTabBarController * pTabBar;
    BOOL isHiddenTabBar;
    
    float screenWidth;
    float screenHeight;
}
@property (strong, nonatomic) UIWindow *window;
@property float screenWidth;
@property float screenHeight;
-(void)setHiddenTabBar:(BOOL)isHidden animation:(BOOL)isAnimation;
-(void)hiddenTabBar:(BOOL)hiddenbar;
@end
