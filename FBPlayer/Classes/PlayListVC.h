//
//  PlayListVC.h
//  FBPlayer
//
//  Created by 王健 on 2017/3/29.
//  Copyright © 2017年 王健. All rights reserved.
//

#import "BaseViewController.h"

@interface VideoCell : UITableViewCell
{
    UIImageView * imageView;
    UILabel * nameLab;
    UILabel * timeLab;
    NSString * curFile;
}
-(void)initControls;
-(void)setData:(NSString*)videoFile;
+(CGFloat)cellH;
@end

@interface PlayListVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * videoFileList;
    UITableView * mainTable;
}
@end
