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

@implementation ViewController
@synthesize followingTableView, followings, switchStates;
- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.followings count];
}

- (void)toggleSwitch:(UISwitch *)theSwitch{
    [switchStates setBool:theSwitch.isOn forKey:[NSString stringWithFormat:@"%d",theSwitch.superview.tag]];
    Following *following = [followings objectAtIndex:theSwitch.superview.tag];
    NSLog(@"Handle switched: %@",following.handle);
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
    
    UISwitch *switchView = (UISwitch *)[cell viewWithTag:666];
    if (![[switchView allTargets] count]) {
        [switchView addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    
    switchView.on = [switchStates boolForKey:[NSString stringWithFormat:@"%d",indexPath.row]];

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
    if ([indexPath row] == ((NSIndexPath *) [[followingTableView indexPathsForVisibleRows] lastObject]).row) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    cell.contentView.tag = indexPath.row;
    return cell;
}

- (void)twitterRequestDone:(NSArray *)followingArray{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    self.followings = [followingArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [self.followingTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)showSettings{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    switchStates = [NSMutableDictionary dictionary];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Twitter Alert";
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"wrench"] style:UIBarButtonItemStyleBordered target:self action:@selector(showSettings:)];
    self.navigationItem.rightBarButtonItem = settingsButton;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading followings", @"HUD Label: Loading");
    [hud show:YES];
    TwitterRequest *twitterRequest = [[TwitterRequest alloc] init];
    twitterRequest.delegate = self;
    [twitterRequest retrieveTwitterFollowers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
