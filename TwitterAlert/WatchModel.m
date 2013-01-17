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

- (void)save:(NSMutableDictionary *)switchStates{
    [switchStates writeToFile:[self getFilePath] atomically:YES];
}

- (NSMutableDictionary *)getSwitchStates{
    return [NSMutableDictionary dictionaryWithContentsOfFile:[self getFilePath]];
}

- (NSString *)getFilePath{
    return [NSHomeDirectory() stringByAppendingPathComponent:kWatchesFile];
}

@end
