//
//  PlayDetailVC.h
//  FBPlayer
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 王健. All rights reserved.
//

#import "BaseViewController.h"
#import "FFControler.h"

@interface PlayDetailVC : BaseViewController
{
    FFControler * playerController;
    UIButton * backBtn;
    UIView * topBar;
    UIView * bottomBar;
    
    CGSize toSize;
}
@property(nonatomic,copy)NSString * videoPath;
@end
