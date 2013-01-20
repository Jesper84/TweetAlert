//
//  WatchModel.m
//  TwitterAlert
//
//  Created by Jesper Nielsen on 17/01/13.
//  Copyright (c) 2013 Tallisoft.dk. All rights reserved.
//

#import "WatchModel.h"
#define kWatchesFile @"Documents/watchesFile"
@implementation WatchModel
@synthesize watchedHandles = _watchedHandles;
- (void)saveWatchedHandles{
    [_watchedHandles writeToFile:[self getFilePath] atomically:YES];
}

- (void)loadWatchedHandles{
    _watchedHandles = [NSMutableArray arrayWithContentsOfFile:[self getFilePath]];
    if (!_watchedHandles) {
        _watchedHandles = [NSMutableArray array];
    }
}

- (NSString *)getFilePath{
    return [NSHomeDirectory() stringByAppendingPathComponent:kWatchesFile];
}

@end
