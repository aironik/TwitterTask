//
//  ATTDataManager.m
//  TwitterTask
//
//  Created by Oleg Lobachev on 22/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTDataManager.h"

#import "ATTNetworkManager.h"
#import "ATTPersistenceStorage.h"


@interface ATTDataManager()

@property (nonatomic, strong, readonly) ATTNetworkManager *networkManager;
@property (nonatomic, strong, readonly) ATTPersistenceStorage *persistenceStorage;

@end


#pragma mark - Implementation

@implementation ATTDataManager


@synthesize networkManager = _networkManager;
@synthesize persistenceStorage = _persistenceStorage;


- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc {
    [self stop];
}

- (BOOL)isStarted {
    return (_networkManager != nil && _persistenceStorage != nil);
}

- (void)start {
    _networkManager = [[ATTNetworkManager alloc] initWithAccessToken:[self loadAccessToken]];
    _persistenceStorage = [[ATTPersistenceStorage alloc] init];
    
    [_networkManager start];
    [_persistenceStorage start];
}

- (void)stop {
    [_persistenceStorage stop];
    [_networkManager stop];

    _persistenceStorage = nil;
    _networkManager = nil;
}

- (NSString *)loadAccessToken {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"access_token" ofType:@"txt"];
    NSString *fileContent = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];;
    return [fileContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


@end
