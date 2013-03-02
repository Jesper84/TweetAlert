//
//  TwitterRequest.h
//  TwitterAlert
//
//  Created by Jesper Nielsen on 10/01/13.
//  Copyright (c) 2013 Tallisoft.dk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
@class TwitterRequest;
@protocol TwitterRequestDelegate <NSObject>

- (void)twitterRequestDone:(NSArray *)followingArray;
- (void)timelineFetched:(NSArray *)timeline;

@end
@interface TwitterRequest : NSObject
@property (nonatomic, weak) id <TwitterRequestDelegate> delegate;
@property (nonatomic, strong) ACAccount *twitterAccount;
@property (nonatomic, strong) NSMutableArray *followings;
@property (nonatomic) BOOL fetchDone;

- (void)retrieveTwitterFollowers;
- (void)retrieveFollowing;
- (void)retrieveUsernamesFromIds:(NSArray *)ids;
- (void)retrieveTimeline;

@end
