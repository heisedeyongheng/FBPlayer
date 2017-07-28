//
//  PlayDetailVC.m
//  FBPlayer
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 王健. All rights reserved.
//

#import "PlayDetailVC.h"
#import "AppDelegate.h"


extern AppDelegate * appDelegate;

@implementation ProcessView
-(void)initControls
{
    bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:RGBA(200, 200, 200, 255)];
    [self addSubview:bgView];
    frontView = [[UIView alloc] init];
    [frontView setBackgroundColor:RGBA(0, 0, 200, 255)];
    [self addSubview:frontView];
    clkBtn = [[UIImageView alloc] init];
    [clkBtn setFrame:CGRectMake(0, 0, 20, 20)];
    [clkBtn.layer setCornerRadius:10];
    [clkBtn.layer setMasksToBounds:YES];
    [clkBtn setBackgroundColor:[UIColor redColor]];
    [self addSubview:clkBtn];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if(bgView == nil){
        [self initControls];
    }
    [bgView setFrame:CGRectMake(0, (self.frame.size.height - 2)/2, self.frame.size.width, 2)];
    [frontView setFrame:CGRectMake(0, (self.frame.size.height - 2)/2, self.frame.size.width*curProcess, 2)];
    [clkBtn setCenter:CGPointMake(self.frame.size.width*curProcess, self.frame.size.height/2)];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    BOOL isInBtn = CGRectContainsPoint(clkBtn.frame,point);
    if(isInBtn){
        isStartMove = YES;
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(isStartMove){
        curProcess = point.x/self.frame.size.width;
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    isStartMove = NO;
    [self layoutSubviews];
}
-(void)setProcess:(float)process
{
    curProcess = process;
    [self layoutSubviews];
}
-(CGFloat)getProcess
{
    return curProcess;
}
@end


@implementation PlayDetailVC
@synthesize videoPath;
-(void)dealloc
{
    FREEOBJECT(playerController);
    FREEOBJECT(topBar);
    FREEOBJECT(bottomBar);
    FREEOBJECT(processView);
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControls];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(playerController != nil){
        [playerController Play];
    }
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    DEBUG_NSLOG(@"%s",__FUNCTION__);
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    toSize = size;
    [playerController Pause];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        
        if(toSize.width > toSize.height){
            //横屏
            [playerController.videoView setFrame:CGRectMake(0, 0, appDelegate.screenHeight, appDelegate.screenWidth)];
            [topBar setFrame:CGRectMake(0, 0, appDelegate.screenHeight, topBar.frame.size.height)];
            [bottomBar setFrame:CGRectMake(0, appDelegate.screenWidth - topBar.frame.size.height, appDelegate.screenHeight, topBar.frame.size.height)];
        }
        else{
            [playerController.videoView setFrame:CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight)];
            [topBar setFrame:CGRectMake(0, 0, appDelegate.screenWidth, topBar.frame.size.height)];
            [bottomBar setFrame:CGRectMake(0, appDelegate.screenHeight - topBar.frame.size.height, appDelegate.screenWidth, topBar.frame.size.height)];
        }
        [processView setFrame:CGRectMake(0, 5, bottomBar.frame.size.width, 20)];
        [playerController.videoView layoutSubviews];
        [playerController Pause];
    }];
}


-(void)initControls
{
    DEBUG_NSLOG(@"视频地址：%@",self.videoPath);
    [self.view.layer setMasksToBounds:YES];
    playerController = [[FFControler alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenWidth)];
    [playerController setPlayUrl:self.videoPath];
    [playerController setDelegate:self];
    [self.view addSubview:playerController.videoView];
    
    float barH = 45;
    topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth,barH)];
    [topBar setBackgroundColor:RGBA(0, 0, 0, 125)];
    [self.view addSubview:topBar];
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(10, 0, barH, barH)];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [backBtn setImage:[UIImage imageNamed:@"img_back"] forState:UIControlStateNormal];
    [backBtn setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, appDelegate.screenHeight - barH, appDelegate.screenWidth, barH)];
    [bottomBar setBackgroundColor:RGBA(0, 0, 0, 125)];
    [self.view addSubview:bottomBar];
    processView = [[ProcessView alloc] init];
    [processView setFrame:CGRectMake(0, 5, bottomBar.frame.size.width, 20)];
    [bottomBar addSubview:processView];
}

-(void)backAction:(UIButton*)btn
{
    [playerController Stop];
    [super backAction:nil];
}
#pragma mark - FFControlerDelegate
-(void)onPlayTime:(double)playTime totalSeconds:(double)totalSeconds
{
    float percent = playTime/totalSeconds;
    [processView setProcess:percent];
}
@end
