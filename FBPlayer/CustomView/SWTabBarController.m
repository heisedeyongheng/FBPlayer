//
//  SWTabBar.m
//  SuperWave
//
//  Created by 王健 on 13-8-23.
//  Copyright (c) 2013年 wj. All rights reserved.
//

#import "SWTabBarController.h"
#import "BaseViewController.h"
#import "Contast.h"

@implementation SWTabBar
-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
    }
    return self;
}
@end



@implementation SWTabBarController
@synthesize tabbarDelegate,currentSelectedIndex,buttons;
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
    FREEOBJECT(selectMaskView);
    FREEOBJECT(tabBar);
    FREEOBJECT(buttons);
    FREEOBJECT(left);
    FREEOBJECT(right);
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self initControls];
    if(self.viewControllers.count > 5)
        [self.moreNavigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initControls
{
    if(isInit)return;
// self.view.backgroundColor = [UIColor whiteColor];
    [self hideRealTabBar];
    [self initTabBar];
    [self showTabBar];
//    [self selectItem:0];//because in parent will call selectitem the wav will play twice
    isInit = YES;
}
-(void)hideRealTabBar
{
	for(UIView *view in self.view.subviews)
    {
		if([view isKindOfClass:[UITabBar class]])
        {
			view.hidden = YES;
			break;
		}
	}
}

-(void)initTabBar
{
    DEBUG_NSLOG(@"tabbar frame %@",NSStringFromCGRect(self.tabBar.frame));
//    [self.tabBar setFrame:CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y-10, self.tabBar.frame.size.width, self.tabBar.frame.size.height + 10)];
    tabBar = [[SWTabBar alloc] initWithFrame:CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
    [tabBar setImage:[UIImage imageNamed:@"img_tabBarBg"]];
    [tabBar setUserInteractionEnabled:YES];
    
    UIScrollView * mainScroll = [[UIScrollView alloc] initWithFrame:tabBar.bounds];
    [mainScroll setShowsHorizontalScrollIndicator:NO];
    [mainScroll setShowsVerticalScrollIndicator:NO];
    [mainScroll setClipsToBounds:NO];
    [mainScroll setDelegate:self];
    [mainScroll setTag:SCROLLTAG];
    [tabBar addSubview:mainScroll];
    [mainScroll release];
    
    //创建按钮
	NSInteger viewCount = self.viewControllers.count;
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
    for (int i = 0; i < viewCount; i++)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [btn setHighlighted:NO];
        
        UIImageView * image = [[UIImageView alloc] init];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        [btn addSubview:image];
        [image setTag:IMGTAG];
        [image release];
        
        UILabel * label = [[UILabel alloc] init];
        [label setTag:LABELTAG];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:10]];
        [btn addSubview:label];
        [label release];
        [mainScroll addSubview:btn];
        [self.buttons addObject:btn];
    }
    [self.view addSubview:tabBar];
    
    selectMaskView = [[UIImageView alloc] init];
    [selectMaskView setImage:[UIImage imageNamed:@"img_tabBarHight"]];
    [selectMaskView setHidden:YES];//for super girl
    [tabBar insertSubview:selectMaskView atIndex:0];
    
    //箭头
//    left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, tabBar.frame.size.height)];
//    [left setImage:[UIImage imageNamed:@"img_arrowLeft"]];
//    [tabBar addSubview:left];
//    right = [[UIImageView alloc] initWithFrame:CGRectMake(tabBar.frame.size.width - 20, 0, 20, tabBar.frame.size.height)];
//    [right setImage:[UIImage imageNamed:@"img_arrow_right"]];
//    [tabBar addSubview:right];
}
-(void)showTabBar
{
    NSInteger viewCount = self.viewControllers.count;
	double _width = self.tabBar.frame.size.width/(MIN(viewCount, 5));
    double _height = self.tabBar.frame.size.height;
    for (int i = 0; i < viewCount; i++)
    {
		UIViewController * v = [self.viewControllers objectAtIndex:i];
        UIButton * btn = [self.buttons objectAtIndex:i];
        UILabel * label = (UILabel*)[btn viewWithTag:LABELTAG];
        UIImageView * image = (UIImageView*)[btn viewWithTag:IMGTAG];
        [btn setFrame:CGRectMake(i*_width, 0, _width, _height)];
        [image setFrame:CGRectMake(0, 5, _width, _height - 20 - 10)];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        [image setCenter:CGPointMake(_width/2, (_height - 10)/2)];
        [image setImage:v.tabBarItem.image];
        [label setText:v.tabBarItem.title];
        [label setFrame:CGRectMake(0, _height-20, _width, 20)];
    }
    UIScrollView * mainSrcoll = (UIScrollView*)[tabBar viewWithTag:SCROLLTAG];
    [mainSrcoll setContentSize:CGSizeMake(_width*viewCount, _height)];
    [selectMaskView setFrame:CGRectMake(0, 2, _width - 10, _height-4)];
}
-(void)selectedTab:(UIButton *)button
{
	if(tabbarDelegate != nil)
    {
        BOOL isRespone = [tabbarDelegate onItemClick:button.tag];
        if(isRespone)
            return;
    }
	self.currentSelectedIndex = button.tag;
	self.selectedIndex = self.currentSelectedIndex;
    [self setHighLight];
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.2];
//    [selectMaskView setCenter:button.center];
//    [UIView commitAnimations];
    
//    UIScrollView * mainSrcoll = (UIScrollView*)[tabBar viewWithTag:SCROLLTAG];
//    [mainSrcoll scrollRectToVisible:button.frame animated:YES];
//    [self scrollViewDidScroll:mainSrcoll];
}
-(void)setHighLight
{
    int midItemW = 0;
    NSInteger viewCount = self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
	double _width = (self.tabBar.frame.size.width-midItemW) / viewCount;
    double _height = self.tabBar.frame.size.height;
    for(int i=0;i<self.buttons.count;i++)
    {
        UIButton * btn = [self.buttons objectAtIndex:i];
        UIViewController * v = [self.viewControllers objectAtIndex:i];
        UIImageView * image = (UIImageView*)[btn viewWithTag:IMGTAG];
        UILabel * lab = (UILabel*)[btn viewWithTag:LABELTAG];
        [btn setImage:nil forState:UIControlStateNormal];
        [image setImage:v.tabBarItem.image];
        [lab setTextColor:RGBA(255, 255, 255, 255)];
        if(self.currentSelectedIndex == i)
        {
            [image setImage:v.tabBarItem.selectedImage];
            [lab setTextColor:RGBA(222, 94, 96, 255)];
        }
    }
}
-(void)selectItem:(NSInteger)index
{
    [self initControls];
    if(index >= buttons.count)
        return;
    [self selectedTab:[buttons objectAtIndex:index]];
}

-(void)setHiddenTabBar:(BOOL)isHidden animation:(BOOL)isAnimation
{
    if(isHidden)
    {
        [tabBar setAlpha:1.0];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:(isAnimation ? 0.2 : 0.0)];
        [tabBar setAlpha:0.0];
        [UIView commitAnimations];
    }
    else
    {
        [tabBar setAlpha:0.0];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:(isAnimation ? 0.2 : 0.0)];
        [tabBar setAlpha:1.0];
        [UIView commitAnimations];
    }
}
#pragma mark scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int range = 30;
    int offsetL = scrollView.contentOffset.x;
    int offsetR = scrollView.contentOffset.x - (scrollView.contentSize.width-scrollView.frame.size.width);
    if(offsetL < range)
        [left setHidden:YES];
    else
        [left setHidden:NO];
    if(offsetR > -1*range)
        [right setHidden:YES];
    else
        [right setHidden:NO];
}
@end
