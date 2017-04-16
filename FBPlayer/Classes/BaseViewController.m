//
//  BaseViewController.m
//  SuperWave
//
//  Created by 王健 on 13-8-6.
//  Copyright (c) 2013年 wj. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

extern AppDelegate * appDelegate;
@implementation BaseViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [self unInitNotify];
    FREEOBJECT(navBarView);
    FREEOBJECT(navTitleView);
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:navBarView];
    if([self isKindOfClass:NSClassFromString(@"UpLoadVC")]){
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if([self isKindOfClass:NSClassFromString(@"UpLoadVC")]){
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNotify];
    //[self adapterForIOS7];
	// Do any additional setup after loading the view.
}
-(void)initNotify
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRecvieUpdate:) name:LANGUECHANGENNOTIFY object:nil];
}
-(void)unInitNotify
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:LANGUECHANGENNOTIFY object:nil];
}
-(void)onRecvieUpdate:(NSNotification*)notice
{
    [self viewWillAppear:YES];
}
#if __IPHONE_5_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == [BaseViewController Orientation]);
}
#endif
#if __IPHONE_6_0
- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [BaseViewController Orientation];
}
#endif
+(NSUInteger)Orientation
{
    if(SYSVERSION >= 6.0)
        return UIInterfaceOrientationMaskPortrait;
    else
        return UIInterfaceOrientationPortrait;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)adapterForIOS7
{
#ifdef __IPHONE_7_0
    if(SYSVERSION >= 7.0)
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setExtendedLayoutIncludesOpaqueBars:NO];
        [self setModalPresentationCapturesStatusBarAppearance:NO];
    }
#endif
}

//完全使用自定义控件添加在当前view中来实现自定义navbaar
-(void)initNavBar:(NSString*)navBgImg titleObj:(id)titleObj back:(id)backObj right:(id)rightObj
{
    NSString * imgPath = [NSString stringWithFormat:@"%@",@"img_navbar"];
    if(navBgImg != nil && navBgImg.length > 0)
        imgPath = [NSString stringWithFormat:@"%@",navBgImg];
    navBarHeight = 72;
    navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth, navBarHeight)];
    UIImageView * navBg = [[UIImageView alloc] initWithFrame:navBarView.bounds];
    [navBg setImage:[UIImage imageNamed:imgPath]];
    [navBarView addSubview:navBg];
    [navBg release];
    [navBarView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:navBarView];
    
    navTitleView = [[UILabel alloc] initWithFrame:navBarView.bounds];
    [navTitleView setBackgroundColor:[UIColor clearColor]];
    [navTitleView setTextAlignment:NSTextAlignmentCenter];
    [navTitleView setFont:[UIFont systemFontOfSize:20]];
    [navTitleView setTextColor:RGBA(156, 70, 0, 255)];
    
    if(titleObj != nil)
    {
        if([titleObj isKindOfClass:[NSString class]])
        {
            NSString * titleStrl = (NSString*)titleObj;
            if(titleStrl.length > 0)
            {
                [navTitleView setText:titleStrl];
            }
            else
            {
                UIImageView * logoView = [[UIImageView alloc] init];
                UIImage * logo = [UIImage imageNamed:@"img_navLogo"];
                [logoView setFrame:CGRectMake(0, 0, 42, 25)];
                [logoView setCenter:CGPointMake(navTitleView.frame.size.width/2, navTitleView.frame.size.height/2)];
                [logoView setImage:logo];
                [navTitleView addSubview:logoView];
                [logoView release];
            }
        }
        else
        {
            if([titleObj isKindOfClass:[UIView class]])
            {
                [titleObj setCenter:CGPointMake(navTitleView.frame.size.width/2, navTitleView.frame.size.height/2)];
                [navTitleView addSubview:titleObj];
            }
            else if([titleObj isKindOfClass:[UIImage class]])
            {
                UIImageView * tmpImg = [[UIImageView alloc] initWithImage:(UIImage*)titleObj];
                tmpImg.contentMode = UIViewContentModeScaleAspectFit;
                [tmpImg setFrame:CGRectMake(0, 0, 120, 30)];
                [tmpImg setCenter:CGPointMake(navBarView.frame.size.width/2, navBarHeight/2)];
                [navBarView addSubview:tmpImg];
                [tmpImg release];
            }
        }
    }
    [navBarView addSubview:navTitleView];
    
    if(backObj != nil)
    {
        if([backObj isKindOfClass:[NSString class]])
        {
            UIButton * backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            backbtn.frame = CGRectMake(7, (navBarHeight-40)/2, 53, 40);
            [backbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            backbtn.titleLabel.font = [UIFont systemFontOfSize:13];
            
            NSString * backStr = (NSString*)backObj;
            if(backStr.length == 0)
                [backbtn setImage:[UIImage imageNamed:@"img_back"] forState:UIControlStateNormal];
            else
                [backbtn setTitle:backStr forState:UIControlStateNormal];
            [backbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [backbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [backbtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [backbtn setBackgroundImage:[UIImage imageNamed:@"img_backBg"] forState:UIControlStateNormal];
            [backbtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
            [navBarView addSubview:backbtn];
        }
        else if([backObj isKindOfClass:[UIButton class]])
        {
            UIButton * backbtn = (UIButton*)backObj;
            [backbtn setCenter:CGPointMake(backbtn.frame.size.width/2+7, navBarHeight/2)];
            [navBarView addSubview:backbtn];
        }
    }
    
    if(rightObj != nil)
    {
        if([rightObj isKindOfClass:[NSString class]])
        {
            NSString * rightStr = (NSString*)rightObj;
            
            UIButton * rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rightbtn.frame = CGRectMake(navBarView.frame.size.width-65, (navBarHeight-40)/2, 53, 40);
            [rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            rightbtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [rightbtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
            if(rightStr.length == 0)
                [rightbtn setImage:[UIImage imageNamed:@"img_rightBtn"] forState:UIControlStateNormal];
            else
                [rightbtn setTitle:NSLocalizedString(rightStr, nil) forState:UIControlStateNormal];
            [rightbtn setBackgroundImage:[UIImage imageNamed:@"img_rightBg"] forState:UIControlStateNormal];
            [rightbtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
            [navBarView addSubview:rightbtn];
        }
        else if([rightObj isKindOfClass:[UIButton class]])
        {
            [navBarView addSubview:(UIButton*)rightObj];
        }
    }
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)setBaseBg:(UIImage*)bg
{
    UIImageView * grayBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth, self.view.frame.size.height)];
    [grayBg setTag:BASEBG];
    [grayBg setContentMode:UIViewContentModeScaleAspectFill];
    [grayBg setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [grayBg setImage:bg];
    [self.view addSubview:grayBg];
    [grayBg release];
}

//在系统navbar的基础上修改背景来实现自定义效果
//backobj nill sys default. string show .button show button
//rightobj nil do not show right. string show .button show button
//titleobj is same as up two
-(void)setNavBg:(UIViewController *)target title:(id)titleObj back:(id)backObj right:(id)rightObj
{
    NSString * navBgImg = @"img_navbar";
    if(SYSVERSION >= 7.0)
        navBgImg = @"img_navbar";
    
    [self adapterForIOS7];
    //NSString * imagePath = [[SkinTool defaultInstance] getSkin:navBgImg];
    NSString * imagePath = [NSString stringWithFormat:@"%@",navBgImg];
    UIImage * barBgImg = [UIImage imageNamed:navBgImg];
    barBgImg = [barBgImg resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    UINavigationBar * navBar = self.navigationController.navigationBar;
    
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        //if iOS 5.0 and later
        [navBar setBackgroundImage:barBgImg forBarMetrics:UIBarMetricsDefault];
        //        [navBar setBackgroundImage:[UIImage imageNamed:imagePath] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[navBar viewWithTag:NAVBARBG];
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagePath]];
            [imageView setTag:NAVBARBG];
            [navBar insertSubview:imageView atIndex:0];
            [imageView release];
        }
    }
    //返回按钮背景
    if(backObj != nil)
    {
        UIView * backContain = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [backContain setBackgroundColor:[UIColor clearColor]];
        if([backObj isKindOfClass:[NSString class]])
        {
            UIButton * backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            backbtn.frame = CGRectMake(0, (backContain.frame.size.height - 30)/2, 53, 30);
            [backbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            backbtn.titleLabel.font = [UIFont systemFontOfSize:13];
            
            NSString * backStr = (NSString*)backObj;
            if(backStr.length == 0)
                //[backbtn setImage:[UIImage imageNamed:[[SkinTool defaultInstance] getSkin:@"img_backBtn"]] forState:UIControlStateNormal];
                [backbtn setImage:[UIImage imageNamed:@"img_nav_back"] forState:UIControlStateNormal];
            else
                [backbtn setTitle:backStr forState:UIControlStateNormal];
            
            //[backbtn setBackgroundImage:[UIImage imageNamed:[[SkinTool defaultInstance] getSkin:@"img_backBg"]] forState:UIControlStateNormal];
            [backbtn setBackgroundImage:[UIImage imageNamed:@"img_nav_label"] forState:UIControlStateNormal];
            
            [backbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [backbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [backbtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [backbtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
            [backContain addSubview:backbtn];
            UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:backContain];
            target.navigationItem.leftBarButtonItem = backItem;
            [backItem release];
        }
        else if([backObj isKindOfClass:[UIButton class]])
        {
            [backContain addSubview:(UIButton*)backObj];
            UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:(UIButton*)backContain];
            target.navigationItem.leftBarButtonItem = backItem;
            [backItem release];
        }
        [backContain release];
    }
    //rightbtn
    if(rightObj != nil)
    {
        if([rightObj isKindOfClass:[NSString class]])
        {
            UIButton * rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rightbtn.frame = CGRectMake(0, 5, 51, 30);
            
            [rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            rightbtn.titleLabel.font = [UIFont systemFontOfSize:13];
            NSString * rightStr = (NSString*)rightObj;
            if(rightStr.length == 0)
            {
                //[rightbtn setImage:[UIImage imageNamed:[[SkinTool defaultInstance] getSkin:@"img_rightBtn"]] forState:UIControlStateNormal];
                [rightbtn setImage:[UIImage imageNamed:@"img_nav_label"] forState:UIControlStateNormal];
                [rightbtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
                [rightbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
            }
            else
                [rightbtn setTitle:NSLocalizedString(rightStr, nil) forState:UIControlStateNormal];
            //[rightbtn setBackgroundImage:[UIImage imageNamed:[[SkinTool defaultInstance] getSkin:@"img_rightBg"]] forState:UIControlStateNormal];
            [rightbtn setBackgroundImage:[UIImage imageNamed:@"img_nav_label"] forState:UIControlStateNormal];
            [rightbtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
            target.navigationItem.rightBarButtonItem = rightItem ;
            [rightItem release];
        }
        else if([rightObj isKindOfClass:[UIButton class]])
        {
            UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:(UIButton*)rightObj];
            target.navigationItem.rightBarButtonItem = rightItem ;
            [rightItem release];
        }
    }
    
    
    if(titleObj != nil)
    {
        if([titleObj isKindOfClass:[NSString class]])
        {
            NSString * titleStrl = (NSString*)titleObj;
            if(titleStrl.length > 0)
            {
                
                UILabel * title = [[UILabel alloc] init];
                [title setBackgroundColor:[UIColor clearColor]];
                [title setFrame:CGRectMake(0, 0, appDelegate.screenWidth/2, 44)];
                [title setTextAlignment:NSTextAlignmentCenter];
                [title setTextColor:RGBA(156, 70, 0, 255)];
                [title setText:titleStrl];
                [title setFont:[UIFont systemFontOfSize:20]];
                target.navigationItem.titleView = title;
                [title release];
            }
            else
            {
                UIImageView * logoView = [[UIImageView alloc] init];
                UIImage * logo = [UIImage imageNamed:@"img_navLogo"];
                [logoView setFrame:CGRectMake(0, 0, 42, 25)];
                [logoView setImage:logo];
                [logoView setContentMode:UIViewContentModeScaleAspectFit];
                [target.navigationItem.titleView setBackgroundColor:[UIColor clearColor]];
                target.navigationItem.titleView = logoView;
                [logoView release];
            }
        }
        else
        {
            if([titleObj isKindOfClass:[UIView class]])
                [target.navigationItem.titleView addSubview:titleObj];
        }
    }
}

-(UIImage*)getBaseBg
{
    UIImageView * grayBg = (UIImageView*)[self.view viewWithTag:BASEBG];
    return grayBg.image;
}
-(void)backAction:(UIButton*)btn
{
    if(self.navigationController != nil)
        [self.navigationController popViewControllerAnimated:YES];
    else
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f) {
            [self dismissViewControllerAnimated:YES completion:NO];
        }
        else
            [self dismissModalViewControllerAnimated:YES];
    }
}
-(void)rightAction:(UIButton*)btn
{
//    [appDelegate showMain];
}
-(float)navBarHeight
{
    if([navBarView isHidden])
        return 0;
    return navBarHeight;
}
-(CGFloat)mainH
{
    return appDelegate.screenHeight - 64 - 59;
}
@end
