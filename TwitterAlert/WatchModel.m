//
//  WatchModel.m
//  TwitterAlert
//
//  Created by Jesper Nielsen on 17/01/13.
//  Copyright (c) 2013 Tallisoft.dk. All rights reserved.
//

#import "WatchModel.h"
#define kWatchesFile @"Documents/watchesFile"
#define kUpdateFrequencyFile @"Documents/updateFrequencyFile"
@implementation WatchModel
@synthesize watchedHandles = _watchedHandles;
@synthesize updateFrequency = _updateFrequency;
- (void)saveWatchedHandles{
    [_watchedHandles writeToFile:[self getWatchesFilePath] atomically:YES];
}

- (void)loadWatchedHandles{
    _watchedHandles = [NSMutableArray arrayWithContentsOfFile:[self getWatchesFilePath]];
    if (!_watchedHandles) {
        _watchedHandles = [NSMutableArray array];
    }
}

//TODO plist to save properties like updatefrequency??

- (NSString *)getWatchesFilePath{
    return [NSHomeDirectory() stringByAppendingPathComponent:kWatchesFile];
}

- (NSString *)getUpdateFrequencyFilePath{
    return [NSHomeDirectory() stringByAppendingPathComponent:kUpdateFrequencyFile];
}

@end
