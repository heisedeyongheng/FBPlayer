//
//  KLA.h
//  KLSDK
//
//  Created by 王健 on 14-5-29.
//  Copyright (c) 2014年 blackteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLA : NSObject<NSURLConnectionDelegate>
{
    NSMutableData * netData;
    NSURLConnection * netConnection;
    BOOL isRun;
}
+(KLA*)defaultInstance;
-(void)start;
@end
