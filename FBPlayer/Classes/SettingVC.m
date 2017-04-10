//
//  SettingVC.m
//  FBPlayer
//
//  Created by 王健 on 2017/3/29.
//  Copyright © 2017年 王健. All rights reserved.
//

#import "SettingVC.h"

@interface SettingVC ()

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControls];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initControls
{
    [super setNavBg:self title:@"设置" back:nil right:nil];
    [self setBaseBg:[UIImage imageNamed:@"img_mainBg"]];
}

@end
