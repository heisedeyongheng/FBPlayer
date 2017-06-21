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
@implementation PlayDetailVC
@synthesize videoPath;
-(void)dealloc
{
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
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        [playerController Pause];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        
        if(toSize.width > toSize.height){
            [playerController.videoView setFrame:CGRectMake(0, 0, appDelegate.screenHeight, appDelegate.screenWidth)];
        }
        else{
            [playerController.videoView setFrame:CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight)];
        }
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
    [self.view addSubview:playerController.videoView];
}
@end
