//
//  SettingsViewController.m
//  TweetAlert
//
//  Created by Jesper Nielsen on 20/01/13.
//  Copyright (c) 2013 Tallisoft.dk. All rights reserved.
//

#import "SettingsViewController.h"
#import "WatchModel.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize slider = _slider;
@synthesize sliderLabel = _sliderLabel;
@synthesize watchModel = _watchModel;
- (IBAction)closeSettings:(id)sender{
    [_watchModel setUpdateFrequency:[_slider value]*60.0f];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)sliderMoved:(id)sender{
    [self updateSliderLabel];
}

- (void)updateSliderLabel{
    _sliderLabel.text = [NSString stringWithFormat:@"Every %d minute(s)",(int)roundf(_slider.value)];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupSlider
{
    [_slider setMaximumValue:30.0f];
    [_slider setMinimumValue:1.0f];
    [_slider setContinuous:YES];
    WatchModel *model = [WatchModel sharedInstance];
    float frequency = model.updateFrequency;
    NSLog(@"Frequency: %f", frequency);
    [_slider setValue:frequency/60];
    [self updateSliderLabel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSlider];
    _watchModel = [WatchModel sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
