//
//  SettingsViewController.h
//  TweetAlert
//
//  Created by Jesper Nielsen on 20/01/13.
//  Copyright (c) 2013 Tallisoft.dk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet UILabel *sliderLabel;
- (IBAction)closeSettings:(id)sender;
-(IBAction)sliderMoved:(id)sender;

@end
