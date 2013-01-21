//
//  ViewController.h
//  TwitterAlert
//
//  Created by Jesper Nielsen on 13/01/13.
//  Copyright (c) 2013 Tallisoft.dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterRequest.h"
#import "WatchModel.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TwitterRequestDelegate>
@property (nonatomic, strong) IBOutlet UITableView *followingTableView;
@property (nonatomic, strong) NSArray *followings;
@property (nonatomic, strong) WatchModel *watchModel;
@end
