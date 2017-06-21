//
//  AudioPlayer.h
//  FFMPEGTest
//
//  Created by 健 王 on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>
#import <AVFoundation/AVFoundation.h>
#import <libavcodec/avcodec.h>
#define NUM_BUFFERS 3
struct bufObj
{
    unsigned char * data;
    long dataLen;
    double pts;
    double durtion;
    struct bufObj * next;
};

@protocol AudioPlayerDelegate <NSObject>
-(void)onQueueBuf;
@end

@interface AudioPlayer : NSObject
{
    AudioFileID audioFile;
    //音频流描述对象
    AudioStreamBasicDescription dataFormat;
    //音频队列
    AudioQueueRef queue;
    SInt64 packetIndex;
    UInt32 numPacketsToRead;
    UInt32 bufferByteSize;
    uint8_t *inbuf;
    AudioStreamPacketDescription *packetDescs;
    AudioQueueBufferRef buffers[NUM_BUFFERS];
    FILE *wavFile; 
    //add by wj
    unsigned char * audioBufData;
    long audioBufLen;
    double curPlayTime;
    
    struct bufObj * bufQueue;
    int bufCount;
}
@property(nonatomic,assign)id<AudioPlayerDelegate> delegate;
@property AudioQueueRef queue;
@property int bufCount;
//stop play and clear buf\queue
-(void)start;
-(void)stop;
-(void)pause:(bool)isPause;
-(void)clearLink;
-(double)getCurPlayTime;
//init audio
-(void)setUpAudio:(AVCodecContext*)pAudioCode;
//put audio data and it auto play
-(void)setAudioData:(unsigned char*)data dataLen:(long)len pts:(double)pts durtion:(double)durtion;
-(id)initWithAudio:(NSString *) path;
//定义缓存数据读取方法
-(void)audioQueueOutputWithQueue:(AudioQueueRef)audioQueue queueBuffer:(AudioQueueBufferRef)audioQueueBuffer;
-(UInt32)readPacketsIntoBuffer:(AudioQueueBufferRef)buffer;
@end
//定义回调(Callback)函数
static void BufferCallback(void *inUserData,AudioQueueRef inAQ,AudioQueueBufferRef buffer);
