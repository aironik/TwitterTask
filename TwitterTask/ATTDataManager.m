//
//  ATTDataManager.m
//  TwitterTask
//
//  Created by Oleg Lobachev on 22/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTDataManager.h"

@interface ATTDataManager()

@property (nonatomic, readwrite, getter=isStarted) BOOL started;

@end


#pragma mark - Implementation

@implementation ATTDataManager


- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)start {
    self.started = YES;
}

- (void)stop {
    self.started = NO;
}


@end
