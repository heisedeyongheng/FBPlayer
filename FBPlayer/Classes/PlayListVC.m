//
//  PlayListVC.m
//  FBPlayer
//
//  Created by 王健 on 2017/3/29.
//  Copyright © 2017年 王健. All rights reserved.
//

#import "PlayListVC.h"

@interface PlayListVC ()

@end

@implementation PlayListVC

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
    [super setNavBg:self title:@"列表" back:nil right:nil];
    [self setBaseBg:[UIImage imageNamed:@"img_mainBg"]];
}
@end
