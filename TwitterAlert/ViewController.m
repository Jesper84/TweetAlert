//
//  ViewController.m
//  TwitterAlert
//
//  Created by Jesper Nielsen on 13/01/13.
//  Copyright (c) 2013 Tallisoft.dk. All rights reserved.
//

#import "ViewController.h"
#import "TwitterRequest.h"
#import "AppDelegate.h"
#import "Following.h"
#import "FollowingCell.h"
#import "MBProgressHUD.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize followingTableView, followings;
- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.followings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.row];
    NSString *CellIdentifier = @"FollowingCell";
    FollowingCell *cell = (FollowingCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowingCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Following *following = [self.followings objectAtIndex:indexPath.row];
    cell.username.text = following.username;
    cell.handleText.text = following.handle;
    cell.onOffSwitch.on = NO;

    if (following.image) {
        cell.image.image = following.image;
    }else{
        NSURL *imageURL = [NSURL URLWithString:following.imageUrl];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_sync(dispatch_get_main_queue(), ^{
                following.image = [UIImage imageWithData:imageData];
                [followingTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        });
    }
    return cell;
}

- (void)twitterRequestDone:(NSArray *)followingArray{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    self.followings = [followingArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [self.followingTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Twitter Alert";
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading following", @"HUD Label: Loading");
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        TwitterRequest *twitterRequest = [[TwitterRequest alloc] init];
        twitterRequest.delegate = self;
        [twitterRequest retrieveTwitterFollowers];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
