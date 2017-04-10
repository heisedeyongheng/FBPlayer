//
//  SWTabBar.h
//  SuperWave
//
//  Created by 王健 on 13-8-23.
//  Copyright (c) 2013年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LABELTAG            1000
#define IMGTAG              1001
#define SCROLLTAG           1002

@protocol SWTabBarDelegate <NSObject>
-(BOOL)onItemClick:(NSInteger)_index;
@end

@interface SWTabBar : UIImageView

@end

@interface SWTabBarController : UITabBarController<UIScrollViewDelegate>
{
    SWTabBar * tabBar;
    NSMutableArray *buttons;
    UIImageView * selectMaskView;
    UIImageView * left;
    UIImageView * right;
    
    BOOL isInit;
	NSInteger currentSelectedIndex;
    id<SWTabBarDelegate> tabbarDelegate;
}
@property (nonatomic,assign)id<SWTabBarDelegate> tabbarDelegate;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic,retain) NSMutableArray *buttons;
-(void)selectItem:(NSInteger)index;
-(void)setHiddenTabBar:(BOOL)isHidden animation:(BOOL)isAnimation;
@end
