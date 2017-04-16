//
//  FFApiTool.h
//  FFBlackPlayer
//
//  Created by 王健 on 2017/4/16.
//  Copyright © 2017年 王健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFControler.h"

@interface FFApiTool : NSObject
{
    FFControler * ffController;
    dispatch_queue_t backQueue;
}
+(FFApiTool*)defaultInstance;
+(NSString*)onGetThumbKey;
-(void)getVideoThumbInBack:(NSString*)videoFile;
@end
