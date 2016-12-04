//
//  ATTSearchViewController.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 04/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTSearchViewController.h"

#import "ATTDataManager.h"
#import "ATTTwitterListViewController.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTSearchViewController ()

@property (nonatomic, weak) IBOutlet ATTTwitterListViewController *twitterListViewController;

@end


#pragma mark - Implementation

@implementation ATTSearchViewController


@synthesize dataManager = _dataManager;


- (void)setDataManager:(ATTDataManager *)dataManager {
    if (_dataManager != dataManager) {
        _dataManager = dataManager;
        self.twitterListViewController.dataSource = dataManager.persistenceStorage;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([@"ATTTwitterListViewController" isEqualToString:segue.identifier]) {
        ATTTwitterListViewController *vc = (ATTTwitterListViewController *)segue.destinationViewController;
        self.twitterListViewController = vc;
        [vc setDataSource:self.dataManager.persistenceStorage];
    }
}

@end