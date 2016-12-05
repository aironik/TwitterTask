//
//  ATTUpdater.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 05/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTUpdater.h"
#import "ATTPersistenceStorage.h"
#import "ATTNetworkManager.h"
#import "ATTUpdaterObserver.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTUpdater ()

@property (nonatomic, strong) ATTPersistenceStorage *storage;
@property (nonatomic, strong) ATTNetworkManager *networkManager;
@property (nonatomic, strong) NSBlockOperation *updateOperation;
@property (nonatomic, assign) NSTimer *countdownTimer;    // < счётчик секунд до следующего запуска.
@property (nonatomic, assign, readwrite) NSTimeInterval countdownTimeInterval;

@end


#pragma mark - Implementation

@implementation ATTUpdater

- (instancetype)initWithPersistenceStorage:(ATTPersistenceStorage *)storage networkManager:(ATTNetworkManager *)networkManager {
    if (storage == nil || networkManager == nil) {
        self = nil;
    }
    else if (self = [super init]) {
        _storage = storage;
        _networkManager = networkManager;
        _updateTimeInterval = 60.;
    }
    return self;
}

- (void)start {
    [self startNextStep];
}

- (void)stop {
    [self.updateOperation cancel];
    self.updateOperation = nil;
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
}

- (BOOL)isStarted {
    return ((self.updateOperation != nil && !self.updateOperation.isCancelled && !self.updateOperation.finished)
            || self.countdownTimer == nil);
}

- (void)startNextStep {
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
    NSBlockOperation *op = [self createUpdateOperation];
    [self.queue addOperation:op];
}

- (void)scheduleNextStep {
    WEAK_SELF

    self.countdownTimeInterval = self.updateTimeInterval;
    self.countdownTimer = [NSTimer timerWithTimeInterval:1. repeats:YES block:^(NSTimer *timer) {
        STRONG_SELF
        strongSelf.countdownTimeInterval -= 1.;
        ATTLog(ATT_UPDATER_LOG, @"Left For Update: %.0f", strongSelf.countdownTimeInterval);
        [strongSelf.observer updater:strongSelf didUpdateTimer:strongSelf.countdownTimeInterval];
        if (strongSelf.countdownTimeInterval < 0.1) {
            [strongSelf startNextStep];
        }
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.countdownTimer forMode:NSDefaultRunLoopMode];
}

- (NSBlockOperation *)createUpdateOperation {
    ATTLog(ATT_UPDATER_LOG, @"Start network update");
    WEAK_SELF
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        STRONG_SELF
        [strongSelf.observer updaterStartNetworkRequest:strongSelf];
    }];
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        STRONG_SELF
        [strongSelf.networkManager search:@"Mobile" completionHandler:^(NSArray *searchResults, NSError *error) {
            ATTLog(ATT_UPDATER_LOG, @"Network update receive: results: %@, errors: %@", @(searchResults.count), error == nil ? @"NO" : @"YES");
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                STRONG_SELF
                [strongSelf.observer updaterFinishNetworkRequest:strongSelf];
            }];
            STRONG_SELF
            // TODO: handle errors
            if (error == nil) {
                [strongSelf.storage addSearchStatusesJson:searchResults];
            }
            [strongSelf scheduleNextStep];
        }];
    }];

    return op;
}


@end
