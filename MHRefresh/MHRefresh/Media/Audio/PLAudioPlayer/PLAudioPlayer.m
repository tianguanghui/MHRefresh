//
//  PLAudioPlayer.m
//  MHRefresh
//
//  Created by panle on 2018/3/6.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "PLAudioPlayer.h"
#import "PLAudioThread.h"

@interface PLAudioPlayer ()

@property (nonatomic, strong) PLAudioThread *thread;

@end

@implementation PLAudioPlayer

@synthesize audioFileSource = _audioFileSource;
@synthesize url = _url;

@synthesize status = _status;
@synthesize error = _error;

@synthesize duration = _duration;
@synthesize currentTime = _currentTime;

@synthesize cachedPath = _cachedPath;
@synthesize cacheURL = _cacheURL;

@synthesize audioLength = _audioLength;
@synthesize bufferingRation = _bufferingRation;

@synthesize volume = _volume;
@synthesize playRate = _playRate;


#pragma mark - ======== init ========

+ (instancetype)initWithAudioFileSource:(id <PLAudioFileSource>)audioFileSource {
    return [[self alloc] initWithAudioFileSource:audioFileSource];
}

- (instancetype)initWithAudioFileSource:(id <PLAudioFileSource>)audioFileSource {
    if (self = [super init]) {
        _thread = [[PLAudioThread alloc] initWithAudioFileSource:audioFileSource];
    }
    return self;
}


#pragma mark - ======== public ========

- (void)play {
    [_thread play];
}

- (void)pause {
    [_thread pause];
}

- (void)stop {
    [_thread stop];
}

- (void)seekTime:(NSTimeInterval)time {
    [_thread seekTime:time];
}


#pragma mark - ======== synthesize ========

- (id <PLAudioFileSource>)audioFileSource {
    return [_thread audioFileSource];
}

- (NSURL *)url {
    return [_thread url];
}

- (PLAudioPlayerStatus)status {
    
    PLAudioPlayerStatus status;
    
    switch ([_thread status]) {
        case PLATStatusFlushing:
        case PLATStatusPlaying:
            status = PLAPStatusPlaying;
            break;
            
        case PLATStatusBuffering:
        case PLATStatusIdle:
            status = PLAPStatusBuffering;
            break;
        
        case PLATStatusPaused:
            status = PLAPStatusPaused;
            break;
            
        case PLATStatusStopped:
            status = PLAPStatusStopped;
            break;
            
        case PLATStatusQueueError:
        case PLATStatusBufferError:
        case PLATStatusError:
        case PLATStatusFileError:
            status = PLAPStatusError;
            break;
    }
    
    return status;
}

- (NSError *)error {
    return [_thread error];
}

- (NSTimeInterval)duration {
    [self pprintf];
    return [_thread duration];
}

- (void)pprintf {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DLog(@"%f %f", [_thread duration], [_thread currentTime]);
//        DLog(@"%f", [_thread bufferingRation]);
//        DLog(@"%llu", [_thread audioLength]);
        
        [self pprintf];
    });
}

- (NSTimeInterval)currentTime {
    return [_thread currentTime];
}

- (NSString *)cachedPath {
    return [_thread cachedPath];
}

- (NSURL *)cacheURL {
    return [_thread cacheURL];
}

- (UInt64)audioLength {
    return [_thread audioLength];
}

- (CGFloat)bufferingRation {
    return [_thread bufferingRation];
}

- (CGFloat)volume {
    
    if (_thread) {
        return [_thread volume];
    }
    
    return 1.0;
}

- (void)setVolume:(CGFloat)volume {
    [_thread setVolume:volume];
}

- (CGFloat)playRate {
    return [_thread playRate];
}

- (void)setPlayRate:(CGFloat)playRate {
    [_thread setPlayRate:playRate];
}

@end

