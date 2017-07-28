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
-(void)dealloc
{
    [super dealloc];
    FREEOBJECT(bgView);
    FREEOBJECT(frontView);
    FREEOBJECT(clkBtn);
    FREEOBJECT(timeLabel);
}
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
    
    timeLabel = [[UILabel alloc] init];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel setFont:[UIFont systemFontOfSize:12]];
    [timeLabel setTextColor:[UIColor whiteColor]];
    [timeLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:timeLabel];
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
    [timeLabel setFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height/2, self.frame.size.width/2, self.frame.size.height)];
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
        [clkBtn setCenter:CGPointMake(point.x, self.frame.size.height/2)];
        [frontView setFrame:CGRectMake(0, (self.frame.size.height - 2)/2, point.x, 2)];
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    isStartMove = NO;
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    curProcess = point.x/self.frame.size.width;
    [self layoutSubviews];
}
-(void)setProcess:(float)process totalTime:(int)total curTime:(int)cur
{
    if(process - curProcess > 0.01){
        curProcess = process;
        if(isStartMove == NO){
            [self layoutSubviews];
        }
    }
    if(cur - curSecond > 1){
        curSecond = cur;
        totalSecond = total;
        int cHourt = curSecond/3600;
        int cMinute = (curSecond%3600)/60;
        int cSec = (curSecond%3600)%60;
        int tHourt = totalSecond/3600;
        int tMinute = (totalSecond%3600)/60;
        int tSec = (totalSecond%3600)%60;
        NSString * tStr = nil;
        NSString * cStr = nil;
        if(tHourt > 0){
            tStr = [NSString stringWithFormat:@"%02d:%02d:%02d",tHourt,tMinute,tSec];
        }
        else{
            tStr = [NSString stringWithFormat:@"%02d:%02d",tMinute,tSec];
        }
        if(cHourt > 0){
            cStr = [NSString stringWithFormat:@"%02d:%02d:%02d",cHourt,cMinute,cSec];
        }
        else{
            cStr = [NSString stringWithFormat:@"%02d:%02d",cMinute,cSec];
        }
        [timeLabel setText:[NSString stringWithFormat:@"%@/%@",cStr,tStr]];
    }
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
    [processView setProcess:percent totalTime:totalSeconds curTime:playTime];
}
@end
