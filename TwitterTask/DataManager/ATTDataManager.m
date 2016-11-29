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
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *persistenceStoragePath;

@end


#pragma mark - Implementation

@implementation ATTDataManager


@synthesize networkManager = _networkManager;
@synthesize persistenceStorage = _persistenceStorage;
@synthesize accessToken = _accessToken;
@synthesize persistenceStoragePath = _persistenceStoragePath;


- (instancetype)init {
    if (self = [super init]) {
        _accessToken = [self loadAccessToken];
        _persistenceStoragePath = [self loadPersistenceStoragePath];
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
    _networkManager = [[ATTNetworkManager alloc] initWithAccessToken:[self accessToken]];
    _persistenceStorage = [[ATTPersistenceStorage alloc] initWithStoragePath:self.persistenceStoragePath];
    
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

- (NSString *)loadPersistenceStoragePath {
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths firstObject];
    NSString *storagePath = [docPath stringByAppendingPathComponent:@"data/storage.db"];
    return storagePath;
}


@end
