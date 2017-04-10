//
//  AppDelegate.m
//  Anna
//
//  Created by 王健 on 14-3-9.
//  Copyright (c) 2014年 Jietone Voice Tech Design Limited. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayListVC.h"
#import "UpLoadVC.h"
#import "SettingVC.h"
#import "Contast.h"

AppDelegate * appDelegate;//全局访问对象

@implementation AppDelegate
@synthesize screenHeight,screenWidth;
-(void)dealloc
{
    FREEOBJECT(pTabBar);
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    appDelegate = (AppDelegate*)self;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    DEBUG_NSLOG(@"screenH:%f----screenW:%f",self.screenHeight,self.screenWidth);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self initAllViewControl];
//    [self initWelcome];
    [self showView:0];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)initAllViewControl
{
    UINavigationController * playLisstNav = [self createController:[PlayListVC class] selectedImg:[UIImage imageNamed:@"img_video_hig"] unSelectedImg:[UIImage imageNamed:@"img_video_nor"] navBarHidden:NO title:@"视频" isARC:YES];
    UINavigationController * uploadNav = [self createController:[UpLoadVC class] selectedImg:[UIImage imageNamed:@"img_tran_hig"] unSelectedImg:[UIImage imageNamed:@"img_tran_nor"] navBarHidden:NO title:@"传输" isARC:YES];
    UINavigationController * settingNav = [self createController:[SettingVC class] selectedImg:[UIImage imageNamed:@"img_my_hig"] unSelectedImg:[UIImage imageNamed:@"img_my_nor"] navBarHidden:NO title:@"我的" isARC:YES];
    
    pTabBar = [[SWTabBarController alloc] init];
    [pTabBar setTabbarDelegate:self];
    NSArray * controllers = [[NSArray arrayWithObjects:playLisstNav,uploadNav,settingNav, nil] autorelease];
    pTabBar.viewControllers = controllers;
    isHiddenTabBar = NO;
    self.window.rootViewController = pTabBar;
}
-(UINavigationController*)createController:(Class)targetClass selectedImg:(UIImage*)selectedImg unSelectedImg:(UIImage*)unSelectedImg navBarHidden:(BOOL)navBarHidden title:(NSString*)title isARC:(BOOL)isARC
{
    UIViewController * controller = nil;
    if([targetClass isSubclassOfClass:[UIViewController class]])
        controller = [[targetClass alloc] initWithNibName:nil bundle:nil];
    UINavigationController * nav = nil;
    if(isARC)
        nav = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
    else
        nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [controller release];
    [nav setNavigationBarHidden:navBarHidden];
    nav.tabBarItem = [[[UITabBarItem alloc] initWithTitle:title image:unSelectedImg selectedImage:selectedImg] autorelease];
    return nav;
}
-(void)initWelcome
{
    welcome = [[UIImageView alloc] initWithFrame:self.window.bounds];
    if(appDelegate.screenHeight > 480)
        [welcome setImage:[UIImage imageNamed:@"Default-568h@2x.png"]];
    else
        [welcome setImage:[UIImage imageNamed:@"Default"]];
    [self.window addSubview:welcome];
    [self.window bringSubviewToFront:welcome];
    
    [welcome setTransform:CGAffineTransformRotate(welcome.transform, M_PI)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    [UIView setAnimationDuration:3];
    [welcome setTransform:CGAffineTransformRotate(welcome.transform, M_PI)];
    [UIView commitAnimations];
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}

//mainview调用该函数
-(void)showView:(int)index
{
    [self.window setRootViewController:pTabBar];
    [pTabBar selectItem:index];
}
-(void)setHiddenTabBar:(BOOL)isHidden animation:(BOOL)isAnimation
{
    [pTabBar setHiddenTabBar:isHidden animation:isAnimation];
}
#pragma swtabbar delegate
-(BOOL)onItemClick:(NSInteger)_index
{
    return NO;
}
//直接隐藏tabbar
-(void)hiddenTabBar:(BOOL)hiddenbar
{
    
    if(isHiddenTabBar == hiddenbar)
        return;
    isHiddenTabBar = hiddenbar;
    //    [parent setHidesBottomBarWhenPushed:YES];
    
    for(UIView *view in pTabBar.view.subviews)
    {
        
        if([view isKindOfClass:[UITabBar class]] || [view isKindOfClass:[SWTabBar class]])
        {
            if (!hiddenbar) {//no
                [view setFrame:CGRectMake(view.frame.origin.x, appDelegate.screenHeight-49, view.frame.size.width, view.frame.size.height)];
                //                view.hidden =NO;
            } else {//hidden
                [view setFrame:CGRectMake(view.frame.origin.x, appDelegate.screenHeight + 20, view.frame.size.width, view.frame.size.height)];
                //                view.hidden =YES;
            }
        } else {//修改view
            if (!hiddenbar) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, appDelegate.screenHeight-49)];
            } else {//hidden
                
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, appDelegate.screenHeight)];
                
            }
        }
    }
}

@end
