//
//  PlayListVC.m
//  FBPlayer
//
//  Created by 王健 on 2017/3/29.
//  Copyright © 2017年 王健. All rights reserved.
//

#import "PlayListVC.h"
#import "CusTool.h"
#import "AppDelegate.h"

extern AppDelegate * appDelegate;

@implementation PlayListVC
-(void)dealloc
{
    FREEOBJECT(videoFileList);
    FREEOBJECT(mainTable);
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPars];
    [self initControls];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initPars
{
    videoFileList = [[NSMutableArray alloc] init];
    NSString * uploadPath = [CusTool uploadPath];
    NSArray * fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:uploadPath error:nil];
    [videoFileList addObjectsFromArray:fileList];
    DEBUG_NSLOG(@"视频:%d",(int)videoFileList.count);
}
-(void)initControls
{
    [super setNavBg:self title:@"列表" back:nil right:nil];
    [self setBaseBg:[UIImage imageNamed:@"img_mainBg"]];
    
    mainTable = [[UITableView alloc] init];
    [mainTable setFrame:CGRectMake(0, 0, appDelegate.screenWidth, [self mainH])];
    [mainTable setBackgroundColor:[UIColor clearColor]];
    [mainTable setDelegate:self];
    [mainTable setDataSource:self];
    [self.view addSubview:mainTable];
}
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return videoFileList.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSString * cellIden = @"vCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    NSString * videoFile = [videoFileList objectAtIndex:row];
    [cell.textLabel setText:videoFile];
    return cell;
}
@end
