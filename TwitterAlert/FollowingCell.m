//
//  FollowingCell.m
//  TwitterAlert
//
//  Created by Jesper Nielsen on 15/01/13.
//  Copyright (c) 2013 Tallisoft.dk. All rights reserved.
//

#import "FollowingCell.h"

@implementation FollowingCell
@synthesize username = _username;
@synthesize handleText = _handleText;
@synthesize image = _image;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
