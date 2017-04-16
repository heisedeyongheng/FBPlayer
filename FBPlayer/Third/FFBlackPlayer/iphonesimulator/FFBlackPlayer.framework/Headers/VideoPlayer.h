//
//  VideoPlayer.h
//  FFMPEGTest
//
//  Created by 王健 on 13-8-30.
//
//

#import <UIKit/UIKit.h>
#import "DLGPlayerView.h"
#import "DLGPlayerVideoFrame.h"
#include "libavcodec/avcodec.h"

#define FREEVIDEOBUF(frameBuf)    av_free(frameBuf->pFrame);if(frameBuf->pRGBFrame->data[0])av_free(frameBuf->pRGBFrame->data[0]);if(frameBuf->pDLGFrame != nil)[frameBuf->pDLGFrame release];frameBuf->pDLGFrame=nil;free(frameBuf);frameBuf=NULL;
#define IS_USE_GL

struct videoBuf
{
    AVFrame * pFrame;
    AVFrame * pRGBFrame;
    DLGPlayerVideoFrame * pDLGFrame;
    int index;
    struct videoBuf * next;
};



@interface VideoPlayer : UIView
{
    AVCodecContext * pVideoCode;
#ifdef IS_USE_GL
    DLGPlayerView * videoView;
#else
    UIImageView * videoView;
#endif
    NSTimer * showTimer;
    dispatch_queue_t queue;
    dispatch_semaphore_t vPlayLock;
    NSTimeInterval lastPts;
    NSTimeInterval lastDur;
    
    double FPS;
    double timeBaseUnit;
    double audioCurPlayTime;
    struct videoBuf * videoBufQueue;
}
@property int videoBufCount;
-(void)start;
-(void)pause;
-(void)stop;
-(void)clearLinkBuf;
-(void)setUpVideo:(AVCodecContext *)videoCode FPS:(float)fps timeBaseUnit:(double)_timeBaseUnit isYuv:(BOOL)isYuv;
-(void)setAudioCurPlayTime:(double)curPlayTime;
-(void)addVideoData:(struct videoBuf *)buf;
@end
