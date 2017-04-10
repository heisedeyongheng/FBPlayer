//
//  BaseViewController.h
//  SuperWave
//
//  Created by 王健 on 13-8-6.
//  Copyright (c) 2013年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contast.h"

#define NAVBARBG        2000
#define BASEBG          2200
#define NAVBARH         [self navBarHeight]

@interface BaseViewController : UIViewController
{
    //完全自定义navbar
    UIView * navBarView;
    UILabel * navTitleView;
    int navBarHeight;
}
-(float)navBarHeight;
-(void)initNavBar:(NSString*)navBgImg titleObj:(id)titleObj back:(id)backObj right:(id)rightObj;
-(void)setNavBg:(UIViewController *)target title:(id)titleObj back:(id)backObj right:(id)rightObj;
-(void)setBaseBg:(UIImage*)bg;
-(UIImage*)getBaseBg;
+(NSUInteger)Orientation;
@end
