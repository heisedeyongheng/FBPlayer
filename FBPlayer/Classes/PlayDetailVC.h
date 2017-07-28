//
//  PlayDetailVC.h
//  FBPlayer
//
//  Created by apple on 2017/4/17.
//  Copyright © 2017年 王健. All rights reserved.
//

#import "BaseViewController.h"
#import "FFControler.h"

@interface ProcessView : UIView
{
    UIView * bgView;
    UIView * frontView;
    UIImageView * clkBtn;
    BOOL isStartMove;
    float curProcess;
}
-(void)setProcess:(float)process;
-(CGFloat)getProcess;
@end

@interface PlayDetailVC : BaseViewController<FFControlerDelegate>
{
    FFControler * playerController;
    UIButton * backBtn;
    UIView * topBar;
    UIView * bottomBar;
    ProcessView * processView;
    
    CGSize toSize;
}
@property(nonatomic,copy)NSString * videoPath;
@end
