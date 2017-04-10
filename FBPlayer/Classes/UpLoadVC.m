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

@interface UpLoadVC ()

@end

@implementation UpLoadVC
-(void)dealloc
{
    httpServer = nil;
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
}

@end
