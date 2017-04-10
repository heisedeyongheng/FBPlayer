//
//  Contast.h
//  SuperWave
//
//  Created by 王健 on 13-8-6.
//  Copyright (c) 2013年 wj. All rights reserved.
//

#ifndef SuperWave_Contast_h
#define SuperWave_Contast_h
//for debug
#ifdef DEBUG
#define DEBUG_NSLOG(format, ...) NSLog(format, ## __VA_ARGS__)
#define MCRelease(x) [x release]
#else
#define DEBUG_NSLOG(format, ...)
#define MCRelease(x) [x release], x = nil
#endif


#define RGBA(r,g,b,a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0]
#define SYSVERSION              [[[UIDevice currentDevice] systemVersion] floatValue]
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define FREEOBJECT(obj)         if(obj != nil){[obj release]; obj = nil;}
#define OBJRIGHT(obj)           (obj.frame.origin.x + obj.frame.size.width)
#define OBJBOTTOM(obj)          (obj.frame.origin.y + obj.frame.size.height)

#endif
