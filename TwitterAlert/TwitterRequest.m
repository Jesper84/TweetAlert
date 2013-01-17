//
//  TwitterRequest.m
//  TwitterAlert
//
//  Created by Jesper Nielsen on 10/01/13.
//  Copyright (c) 2013 Tallisoft.dk. All rights reserved.
//

#import "TwitterRequest.h"
#import "Following.h"
#import "AppDelegate.h"

@implementation TwitterRequest
@synthesize twitterAccount, fetchDone, followings, delegate;

- (void)retrieveTwitterFollowers{
    self.followings = [[NSMutableArray alloc] init];
    self.fetchDone = NO;
    ACAccountStore *store = [[ACAccountStore alloc] init];
    
    ACAccountType *twitter = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [store requestAccessToAccountsWithType:twitter options:nil completion:^(BOOL granted, NSError *error){
        if (!granted) {
            NSLog(@"Not granted");
        }else{
            NSArray *twitterAccounts = [store accountsWithAccountType:twitter];
            
            if ([twitterAccounts count] > 0) {
                self.twitterAccount = [twitterAccounts objectAtIndex:0];
                [self retrieveFollowing];
            }
        }
    }];
}

- (void)retrieveFollowing{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"1" forKey:@"include_entities"];
    
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/friends/ids.json"];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
    
    [request setAccount:self.twitterAccount];
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
        if (!responseData) {
            NSLog(@"%@", error);
        } else {
            NSError *jsonError;
            NSDictionary *timeline = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
            if (timeline) {
                [self retrieveUsernamesFromIds:[timeline objectForKey:@"ids"]];
            } else {
                NSLog(@"%@", jsonError);
            }
        }
    }];
    
}

- (void)retrieveUsernamesFromIds:(NSArray *)ids{
    NSMutableArray *idArrays = [NSMutableArray array];
    
    int itemsRemaining = [ids count];
    int j = 0;
        
    while(j < [ids count]) {
        NSRange range = NSMakeRange(j, MIN(100, itemsRemaining));
        NSArray *subarray = [ids subarrayWithRange:range];
        [idArrays addObject:subarray];
        itemsRemaining-=range.length;
        j+=range.length;
    }
    
    __block int counter = 0;
    
    for (NSArray *array in idArrays) {
        NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1/users/lookup.json?user_id=%@",[array componentsJoinedByString:@","]];
        NSURL *url = [NSURL URLWithString:urlString];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:url parameters:nil];
        [request setAccount:self.twitterAccount];
        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
            if (!responseData) {
                NSLog(@"%@",error);
            } else {
                NSError *jsonError;
                NSArray *users = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
                for (NSDictionary *userDict in users) {
                    NSString *username = [userDict objectForKey:@"name"];
                    NSString *handle = [NSString stringWithFormat:@"@%@",[userDict objectForKey:@"screen_name"]];
                    NSString *imageUrl = [userDict objectForKey:@"profile_image_url"];
                    Following *following = [[Following alloc] initWithUsername:username handle:handle andImageUrl:imageUrl];
                    [self.followings addObject:following];
                }
            }
            if(counter == ([idArrays count]-1)){
                self.fetchDone = YES;
                [delegate twitterRequestDone:self.followings];
            }
            counter++;
        }];
        
    }
}

@end
