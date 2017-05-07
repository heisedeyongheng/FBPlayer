//
//  CusTool.m
//  FBPlayer
//
//  Created by apple on 2017/4/10.
//  Copyright © 2017年 王健. All rights reserved.
//

#import "CusTool.h"
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>

@implementation CusTool

+(NSString *)ReturnFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    return documentsDirectory;
}
+(NSString *)ReturnLibFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    return documentsDirectory;
}
+(NSString*)flagFilePath
{
    NSString * docPath = [NSString stringWithFormat:@"%@/infofile/",[CusTool ReturnFilePath]];
    [CusTool checkDirecotry:docPath];
    return [NSString stringWithFormat:@"%@/flag.plist",docPath];
}
+(void)checkDirecotry:(NSString*)dirPath
{
    BOOL isDir = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir ]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark public

+ (NSString *)deviceIPAdress
{
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}

+(NSString*)uploadPath
{
    NSString * docPath = [CusTool ReturnFilePath];
    return [NSString stringWithFormat:@"%@/videoUpload/",docPath];
}
+(NSString*)fileAddUploadPath:(NSString *)fileName
{
    return [NSString stringWithFormat:@"%@%@",[CusTool uploadPath],fileName];
}
+(void)setFlag:(NSString*)flagKey flagValue:(NSString*)flagValue
{
    NSString * flagFile = [CusTool flagFilePath];
    NSMutableDictionary * dict = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:flagFile]){
        dict = [NSMutableDictionary dictionaryWithContentsOfFile:flagFile];
    }
    else{
        dict = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    [dict setValue:flagValue forKey:flagKey];
    [dict writeToFile:flagFile atomically:YES];
}
+(NSString*)getFlag:(NSString*)flagKey
{
    NSString * flagFile = [CusTool flagFilePath];
    NSMutableDictionary * dict = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:flagFile]){
        dict = [NSMutableDictionary dictionaryWithContentsOfFile:flagFile];
        return (NSString*)[dict valueForKey:flagKey];
    }
    return @"";
}
@end
