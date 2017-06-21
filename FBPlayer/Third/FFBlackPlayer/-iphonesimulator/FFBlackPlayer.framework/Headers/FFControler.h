//
//  FFControler.h
//  FFMPEGTest
//
//  Created by 健 王 on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifdef DEBUG
#define DEBUG_NSLOG(format, ...) NSLog(format, ## __VA_ARGS__)
#define MCRelease(x) [x release]
#else
#define DEBUG_NSLOG(format, ...)
#define MCRelease(x) [x release], x = nil
#endif
#define FREECLASS(obj)         if(obj != NULL){delete obj; obj = NULL;}
#define FREEOBJECT(obj)         if(obj != nil){[obj release]; obj = nil;}

#import <Foundation/Foundation.h>
#import "AudioPlayer.h"
#import "VideoPlayer.h"
//extern "C"{
#include "libavcodec/avcodec.h"
#include "libavformat/avformat.h"
#include "libavutil/avutil.h"
#include "libswscale/swscale.h"
#include "libswresample/swresample.h"
//}

#ifndef INT64_C 
#define INT64_C(c) (c ## LL) 
#define UINT64_C(c) (c ## ULL) 
#endif

@interface Utilities : NSObject {
    
}

+(NSString *)bundlePath:(NSString *)fileName;
+(NSString *)documentsPath:(NSString *)fileName;

@end


@protocol FFControlerDelegate <NSObject>
-(void)onPlayTime:(double)playTime totalSeconds:(double)totalSeconds;
@end

enum FFPlayState{
    Playing = 1,
    Initing,
    Pause,
    Stop,
    Seeking
};

@interface FFControler : UIView<AudioPlayerDelegate,VideoPlayerDelegate>
{
    //ffmpeg
    AVFormatContext *pFormatCtx;
    AVCodecContext	*pCodecCtx;
    AVCodecContext	*pAudioCodecCtx;
    struct SwsContext	*pSWSCtx;
    AVFrame	*pFrame;
    AVFrame *pAudioFrame;
    AudioPlayer * pAudioPlayer;
    VideoPlayer * pVideoPlayer;
    double videoTimebase;
    double audioTimeBase;
    int videoStream;
    int audioStream;
    int pictureStream;
    BOOL isYUV;
    BOOL isVideo;
    BOOL isAudio;
    BOOL isLoad;
    BOOL isThreadActive;
    BOOL isThreadRun;
    int playerState;
    NSString * curFileName;
    dispatch_queue_t backQueue;
    
    int64_t curVideoDecodeTime;
    int64_t curAudioDecodeTime;
    
    unsigned char * audioData;
    int audioDataLen;
    int maxBufCount;
    int64_t totalSeconds;
}
@property(nonatomic,assign)id<FFControlerDelegate> delegate;
-(UIView*)videoView;
-(UIImage*)getImage:(int)seconds;
-(int64_t)allTimeLen;
-(void)setPlayUrl:(NSString *)fileName;
-(int)playState;
-(void)Play;
-(void)Pause;
-(void)Stop;
-(void)setMaxBufCount:(int)count;
-(void)SeekTo:(int)seconds;;
+(NSString*)StateKey;
@end
