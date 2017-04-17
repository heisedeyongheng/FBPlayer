//
//  PlayListVC.m
//  FBPlayer
//
//  Created by 王健 on 2017/3/29.
//  Copyright © 2017年 王健. All rights reserved.
//

#import "PlayListVC.h"
#import "CusTool.h"
#import "FFApiTool.h"
#import "AppDelegate.h"

extern AppDelegate * appDelegate;

@implementation VideoCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initNotify];
    [self initControls];
    return self;
}
-(void)dealloc
{
    DEBUG_NSLOG(@"%s",__FUNCTION__);
    [self unInitNotify];
    FREEOBJECT(curFile);
    [super dealloc];
}
-(void)initNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetVideoInfo:) name:[FFApiTool onGetThumbKey] object:nil];
}
-(void)unInitNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:[FFApiTool onGetThumbKey]];
}
-(void)onGetVideoInfo:(NSNotification*)notify
{
    DEBUG_NSLOG(@"%s",__FUNCTION__);
    dispatch_async(dispatch_get_main_queue(), ^(){
        NSDictionary * dict = notify.userInfo;
        NSNumber * numTime = (NSNumber*)[dict valueForKey:[NSString stringWithFormat:@"time_%@",curFile]];
        UIImage * image = (UIImage*)[dict valueForKey:[NSString stringWithFormat:@"thumb_%@",curFile]];
        int64_t allTime = [numTime longLongValue];
        [imageView setImage:image];
        [timeLab setText:[NSString stringWithFormat:@"时长：%d:%02d",(int)allTime/60,(int)allTime%60]];
    });
}
-(void)initControls
{
    CGFloat cellH = [VideoCell cellH];
    CGFloat marginTop = 10;
    UIView * bgView = [[UIView alloc] init];
    [bgView setFrame:CGRectMake(marginTop, marginTop, appDelegate.screenWidth - marginTop*2, cellH - marginTop)];
    [bgView setBackgroundColor:RGBA(222, 94, 96, 255)];
    [self.contentView addSubview:bgView];
    [bgView release];
    
    CGFloat imageSize = bgView.frame.size.height - 10;
    CGFloat labW = bgView.frame.size.width - imageSize - 5;
    imageView = [[UIImageView alloc] init];
    [imageView setFrame:CGRectMake(5, 5, imageSize, imageSize)];
    [imageView setClipsToBounds:YES];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [bgView addSubview:imageView];
    [imageView release];
    nameLab = [[UILabel alloc] init];
    [nameLab setFrame:CGRectMake(OBJRIGHT(imageView) + 5, 5, labW, 30)];
    [nameLab setNumberOfLines:0];
    [nameLab setLineBreakMode:NSLineBreakByCharWrapping];
    [nameLab setTextColor:[UIColor whiteColor]];
    [nameLab setFont:[UIFont systemFontOfSize:16]];
    [bgView addSubview:nameLab];
    [nameLab release];
    timeLab = [[UILabel alloc] init];
    [timeLab setFrame:CGRectMake(nameLab.frame.origin.x, OBJBOTTOM(imageView) - 20, labW, 20)];
    [timeLab setLineBreakMode:NSLineBreakByCharWrapping];
    [timeLab setTextColor:[UIColor whiteColor]];
    [timeLab setFont:[UIFont systemFontOfSize:12]];
    [bgView addSubview:timeLab];
    [timeLab release];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
}
-(void)setData:(NSString *)videoFile
{
    [nameLab setText:videoFile];
    FREEOBJECT(curFile);
    curFile = [[NSString stringWithFormat:@"%@%@",[CusTool uploadPath],videoFile] copy];
    [[FFApiTool defaultInstance] getVideoThumbInBack:curFile];
}
+(CGFloat)cellH
{
    return 80.0f;
}
@end

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
    [mainTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    VideoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if(cell == nil){
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    NSString * videoFile = [videoFileList objectAtIndex:row];
    [cell setData:videoFile];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [VideoCell cellH];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
