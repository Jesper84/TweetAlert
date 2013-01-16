//
//  Following.h
//  TwitterAlert
//
//  Created by Jesper Nielsen on 13/01/13.
//  Copyright (c) 2013 Tallisoft.dk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Following : NSObject
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *handle;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) UIImage *image;
- (id)initWithUsername:(NSString *)twitterName handle:(NSString *)twitterHandle andImageUrl:(NSString *)url;
@end
