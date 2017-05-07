//
//  CusTool.h
//  FBPlayer
//
//  Created by apple on 2017/4/10.
//  Copyright © 2017年 王健. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FLAG_KEY_ISWEB   @"isShowWeb"
#define FLAG_KEY_WEBURL  @"webUrl"

@interface CusTool : NSObject

+(NSString*)deviceIPAdress;
+(NSString*)uploadPath;
+(NSString*)getFlag:(NSString*)flagKey;
+(NSString*)fileAddUploadPath:(NSString*)fileName;
+(void)setFlag:(NSString*)flagKey flagValue:(NSString*)flagValue;
@end
