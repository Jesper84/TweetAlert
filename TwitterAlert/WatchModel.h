//
//  WatchModel.h
//  TwitterAlert
//
//  Created by Jesper Nielsen on 17/01/13.
//  Copyright (c) 2013 Tallisoft.dk. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface WatchModel : NSObject

@property (nonatomic, strong) NSMutableArray *watchedHandles;
@property (nonatomic) float updateFrequency;
@property (nonatomic, strong) NSString *sinceId;
@property (nonatomic, strong) NSMutableDictionary *settingsDictionary;
+ (id)sharedInstance;
- (void)saveWatchedHandles;
- (void)loadWatchedHandles;
- (void)saveSettingsDictionary;
- (void)loadSettingsDictionary;

@end
