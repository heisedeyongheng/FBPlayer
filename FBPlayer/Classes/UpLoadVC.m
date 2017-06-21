//
//  UpLoadVC.m
//  FBPlayer
//
//  Created by 王健 on 2017/3/29.
//  Copyright © 2017年 王健. All rights reserved.
//

#import "UpLoadVC.h"
#import "MyHTTPConnection.h"
#import "CusTool.h"
#import "AppDelegate.h"

extern AppDelegate * appDelegate;
@interface UpLoadVC ()

@end

@implementation UpLoadVC
-(void)dealloc
{
    httpServer = nil;
    FREEOBJECT(uploadAddressLab);
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControls];
    [self initHttpServer];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initControls
{
    [super setNavBg:self title:@"传输" back:nil right:nil];
    [self setBaseBg:[UIImage imageNamed:@"img_mainBg"]];
    
    uploadAddressLab = [[UILabel alloc] init];
    [uploadAddressLab setFrame:CGRectMake(20, appDelegate.screenHeight*0.2, appDelegate.screenWidth - 40, 120)];
    [uploadAddressLab setBackgroundColor:[UIColor clearColor]];
    [uploadAddressLab setTextColor:[UIColor whiteColor]];
    [uploadAddressLab setFont:[UIFont systemFontOfSize:22]];
    [uploadAddressLab setTextAlignment:NSTextAlignmentCenter];
    [uploadAddressLab setNumberOfLines:0];
    [uploadAddressLab setLineBreakMode:NSLineBreakByCharWrapping];
    [self.view addSubview:uploadAddressLab];
}
-(void)initHttpServer
{
    httpServer = [[HTTPServer alloc] init];
    [httpServer setType:@"_http._tcp."];
    NSString * docRoot = [[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"web"] stringByDeletingLastPathComponent];
    [httpServer setDocumentRoot:docRoot];
    
    [httpServer setConnectionClass:[MyHTTPConnection class]];
    
    [httpServer listeningPort];
    NSError *error = nil;
    if(![httpServer start:&error])
    {
        DEBUG_NSLOG(@"Error starting HTTP Server: %@", error);
    }
    
    DEBUG_NSLOG(@"listen %@:%d",[CusTool deviceIPAdress],[httpServer listeningPort]);
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d",[CusTool deviceIPAdress],[httpServer listeningPort]]];
    NSString * t = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    DEBUG_NSLOG(@"%@",t);
    [uploadAddressLab setText:[NSString stringWithFormat:@"请在浏览器中输入如下地址：\n\nhttp://%@:%d",[CusTool deviceIPAdress],[httpServer listeningPort]]];
}

@end
