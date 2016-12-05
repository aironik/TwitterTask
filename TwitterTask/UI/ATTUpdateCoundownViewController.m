//
//  ATTUpdateCoundownViewController.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 05/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTUpdateCoundownViewController.h"

#import "ATTUpdater.h"
#import "ATTUpdaterObserver.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTUpdateCoundownViewController ()<ATTUpdaterObserver>

@property (nonatomic, weak) IBOutlet UILabel *countdownLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@end


#pragma mark - Implementation

@implementation ATTUpdateCoundownViewController


#pragma mark - ATTUpdaterObserver

- (void)updater:(ATTUpdater *)updater didUpdateTimer:(NSTimeInterval)timer {
    [self.activityIndicator stopAnimating];
    self.countdownLabel.alpha = 1.f;
    self.countdownLabel.text = [NSString stringWithFormat:@"%.0f", timer];
}

- (void)updaterStartNetworkRequest:(ATTUpdater *)updater {
    [self.activityIndicator startAnimating];
    self.countdownLabel.alpha = 0.f;
}

- (void)updaterFinishNetworkRequest:(ATTUpdater *)updater {
    [self.activityIndicator stopAnimating];
    self.countdownLabel.alpha = 1.f;
    self.countdownLabel.text = @"Next";
}


#pragma mark -
- (void)setUpdater:(ATTUpdater *)updater {
    _updater.observer = nil;
    _updater = updater;
    _updater.observer = self;
}

@end
