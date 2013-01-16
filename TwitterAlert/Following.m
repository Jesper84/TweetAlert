//
//  Following.m
//  TwitterAlert
//
//  Created by Jesper Nielsen on 13/01/13.
//  Copyright (c) 2013 Tallisoft.dk. All rights reserved.
//

#import "Following.h"

@implementation Following
@synthesize username,handle,imageUrl,image;

- (id)initWithUsername:(NSString *)twitterName handle:(NSString *)twitterHandle andImageUrl:(NSString *)url{
    self.username = twitterName;
    self.handle = twitterHandle;
    self.imageUrl = url;
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"Name: %@, handle: %@, imageUrl: %@",self.username,self.handle,self.imageUrl];
}

@end
