//
//  ATTDataManager.m
//  TwitterTask
//
//  Created by Oleg Lobachev on 22/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTDataManager.h"

#import "ATTNetworkManager.h"


@interface ATTDataManager()

@property (nonatomic, strong) ATTNetworkManager *networkManager;

@end


#pragma mark - Implementation

@implementation ATTDataManager


@synthesize networkManager = _networkManager;


- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc {
    [self stop];
}

- (BOOL)isStarted {
    return self.networkManager != nil;
}

- (void)start {
    self.networkManager = [[ATTNetworkManager alloc] init];
}

- (void)stop {
    self.networkManager = nil;
}


@end
