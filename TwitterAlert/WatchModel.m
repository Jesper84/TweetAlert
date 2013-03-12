//
//  WatchModel.m
//  TwitterAlert
//
//  Created by Jesper Nielsen on 17/01/13.
//  Copyright (c) 2013 Tallisoft.dk. All rights reserved.
//

#import "WatchModel.h"
#import "TwitterRequest.h"
#define kWatchesFile @"Documents/watchesFile"
#define kSettings @"Documents/settingsDictionary"
#define kSinceId @"sinceId"
#define kUpdateFrequency @"updateFrequency"
@implementation WatchModel
static WatchModel *sharedInstance = nil;
@synthesize watchedHandles = _watchedHandles;
@synthesize updateFrequency = _updateFrequency;
@synthesize sinceId = _sinceId;
@synthesize settingsDictionary = _settingsDictionary;

+ (WatchModel *)sharedInstance{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}


- (void)saveWatchedHandles{
    [_watchedHandles writeToFile:[self getWatchesFilePath] atomically:YES];
}

- (void)saveSettingsDictionary{
    [_settingsDictionary setObject:_sinceId forKey:kSinceId];
    NSLog(@"Saving settings: id: %@", _sinceId);
    [_settingsDictionary setObject:[NSString stringWithFormat:@"%f",_updateFrequency] forKey:kUpdateFrequency];
    
    [_settingsDictionary writeToFile:[self getSettingsDictionaryPath] atomically:YES];
}

- (void)loadWatchedHandles{
    _watchedHandles = [NSMutableArray arrayWithContentsOfFile:[self getWatchesFilePath]];
    if (!_watchedHandles) {
        _watchedHandles = [NSMutableArray array];
    }
}

- (void)loadSettingsDictionary{
    _settingsDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[self getSettingsDictionaryPath]];
    if(!_settingsDictionary){
        _settingsDictionary = [NSMutableDictionary dictionary];
    }else{
        _sinceId = [_settingsDictionary objectForKey:kSinceId];
        _updateFrequency = [[_settingsDictionary objectForKey:kUpdateFrequency] floatValue];
        if (_updateFrequency == 0.0f) {
            _updateFrequency = 5.0f*60.0f;
        }
    }
}

- (NSString *)getWatchesFilePath{
    return [NSHomeDirectory() stringByAppendingPathComponent:kWatchesFile];
}

- (NSString *)getSettingsDictionaryPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:kSettings];
}

@end
