//
//  PlayListVC.h
//  FBPlayer
//
//  Created by 王健 on 2017/3/29.
//  Copyright © 2017年 王健. All rights reserved.
//

#import "BaseViewController.h"

@interface PlayListVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * videoFileList;
    UITableView * mainTable;
}
@end
