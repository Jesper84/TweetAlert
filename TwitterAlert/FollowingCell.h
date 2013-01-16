//
//  FollowingCell.h
//  TwitterAlert
//
//  Created by Jesper Nielsen on 15/01/13.
//  Copyright (c) 2013 Tallisoft.dk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowingCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *username;
@property (nonatomic, weak) IBOutlet UILabel *handleText;
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, strong) IBOutlet UISwitch *onOffSwitch;
@end
