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
    UILabel * timeLabel;
    BOOL isStartMove;
    float curProcess;
    int totalSecond;
    int curSecond;
}
-(void)setProcess:(float)process totalTime:(int)total curTime:(int)cur;
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
