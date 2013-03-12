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
#define kFollowCellHeight 44.0
@implementation ViewController
@synthesize followingTableView, followings, watchModel, twitterRequest, selectedIndexes;
- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.followings count];
}

- (void)toggleSwitch:(UISwitch *)theSwitch{
    
    Following *following = [followings objectAtIndex:theSwitch.superview.tag];
    if (theSwitch.isOn) {
        [watchModel.watchedHandles addObject:following.handle];
    }else{
        [watchModel.watchedHandles removeObject:following.handle];
    }

    NSLog(@"Watched: %@", watchModel.watchedHandles);
    [watchModel saveWatchedHandles];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    
    switchView.on = [watchModel.watchedHandles containsObject:following.handle];

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
    [self startWatchingTimeline];
}

- (void)timelineFetched:(NSArray *)timeline{
    int count = 0;
    for (NSDictionary *tweet in timeline) {
        if (count == 0) {
            watchModel.sinceId = [tweet objectForKey:@"id_str"];
        }
        NSDictionary *user = [tweet objectForKey:@"user"];
        NSString *username = [user objectForKey:@"screen_name"];
        if ([watchModel.watchedHandles containsObject:[NSString stringWithFormat:@"@%@",username]]) {
            NSLog(@"Oh yes!");
            NSString *text = [tweet objectForKey:@"text"];
            NSLog(@"%@ tweeted: %@", username, text);
            NSString *alertText = [NSString stringWithFormat:@"%@ tweeted: %@", username, text];
            if (![NSThread isMainThread]) {
                [self performSelectorOnMainThread:@selector(showAlert:) withObject:alertText waitUntilDone:NO];
            }else{
                [self showAlert:alertText];
            }
            
        }
        count++;
    }
}

- (void)showAlert:(NSString *)alertText{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tweet!" message:alertText delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)startWatchingTimeline{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(startTimer) withObject:nil waitUntilDone:NO];
    }
}

- (void)startTimer{
    [NSTimer scheduledTimerWithTimeInterval:watchModel.updateFrequency target:self selector:@selector(watchTimeline) userInfo:nil repeats:YES];
}

- (void)watchTimeline{
    NSLog(@"Calling with id: %@", watchModel.sinceId);
    [self.twitterRequest retrieveTimeline:watchModel.sinceId];
}

- (void)showSettings{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self cellIsSelected:indexPath]){
        return kFollowCellHeight * 2.0;
    }
    return kFollowCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL isSelected = ![self cellIsSelected:indexPath];
    NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
    [selectedIndexes setObject:selectedIndex forKey:indexPath];
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (BOOL)cellIsSelected:(NSIndexPath *)indexPath{
    NSNumber *selectedIndex = [selectedIndexes objectForKey:indexPath];
    return selectedIndex == nil ? NO : [selectedIndex boolValue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedIndexes = [[NSMutableDictionary alloc] init];
    
    watchModel = [WatchModel sharedInstance];
    [watchModel loadWatchedHandles];
    [watchModel loadSettingsDictionary];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading followings", @"HUD Label: Loading");
    [hud show:YES];
    self.twitterRequest = [[TwitterRequest alloc] init];
    self.twitterRequest.delegate = self;
    [self.twitterRequest retrieveTwitterFollowers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
