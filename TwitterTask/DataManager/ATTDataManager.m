//
//  ATTDataManager.m
//  TwitterTask
//
//  Created by Oleg Lobachev on 22/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTDataManager.h"

#import "ATTNetworkManager.h"
#import "ATTImagesDataSource.h"
#import "ATTPersistenceStorage.h"
#import "ATTSearchStatusesDataSource.h"
#import "ATTStatusesDataSource.h"
#import "ATTCachedImagesDataSource.h"
#import "ATTUpdater.h"

#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTDataManager()

@property (nonatomic, strong, readonly) NSOperationQueue *queue;     // < очередь, на которой выполняются операции.
@property (nonatomic, strong, readonly) ATTPersistenceStorage *persistenceStorage;
@property (nonatomic, strong, readonly) ATTNetworkManager *networkManager;
@property (nonatomic, strong, readonly) ATTUpdater *updater;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *persistenceStoragePath;

@end


#pragma mark - Implementation

@implementation ATTDataManager


@synthesize queue = _queue;
@synthesize networkManager = _networkManager;
@synthesize persistenceStorage = _persistenceStorage;
@synthesize updater = _updater;
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
    return ([_networkManager isStarted] && [_persistenceStorage isStarted] && [_updater isStarted]);
}

- (void)start {
    _networkManager = [[ATTNetworkManager alloc] initWithAccessToken:[self accessToken]];
    _persistenceStorage = [[ATTPersistenceStorage alloc] initWithStoragePath:self.persistenceStoragePath];
    _updater = [[ATTUpdater alloc] initWithPersistenceStorage:_persistenceStorage networkManager:_networkManager];

    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.name = NSStringFromClass([self class]);
        _queue.maxConcurrentOperationCount = 1;             // < serial queue
    }
    _networkManager.queue = _queue;
    _persistenceStorage.queue = _queue;
    _updater.queue = _queue;
                                     
    WEAK_SELF
    [_queue addOperationWithBlock:^{
        STRONG_SELF
        [strongSelf.networkManager start];
        [strongSelf.persistenceStorage start];
        [strongSelf.updater start];
    }];
}

- (void)stop {
    if (_queue != NULL && _persistenceStorage != nil && _networkManager != nil) {
        WEAK_SELF
        [self.queue cancelAllOperations];
        [self.queue addOperationWithBlock:^{
            STRONG_SELF
            if (strongSelf != nil) {
                [strongSelf->_updater stop];
                [strongSelf->_persistenceStorage stop];
                [strongSelf->_networkManager stop];

                strongSelf->_updater = nil;
                strongSelf->_persistenceStorage = nil;
                strongSelf->_networkManager = nil;

                strongSelf->_queue = nil;
            }
        }];
    }
}

- (NSString *)loadAccessToken {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"access_token" ofType:@"txt"];
    NSString *fileContent = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];;
    return [fileContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)loadDataPath {
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths firstObject];
    NSString *dataPath = [docPath stringByAppendingPathComponent:@"data"];
    return dataPath;
}

- (NSString *)loadPersistenceStoragePath {
    NSString *storagePath = [[self loadDataPath] stringByAppendingPathComponent:@"storage.db"];
    return storagePath;
}

- (NSString *)loadImagesCachePath {
    NSString *cachePath = [[self loadDataPath] stringByAppendingPathComponent:@"images"];
    return cachePath;
}

- (id<ATTStatusesDataSource>)dataSourceForSearch {
    ATTSearchStatusesDataSource *result = [[ATTSearchStatusesDataSource alloc]
                                           initWithPersistenceStorage:self.persistenceStorage
                                           networkManager:self.networkManager];
    return result;
}

- (id<ATTImagesDataSource>)dataSourceForImages {
    ATTCachedImagesDataSource *result = [[ATTCachedImagesDataSource alloc]
                                         initWithPersistenceStorage:self.persistenceStorage
                                         networkManager:self.networkManager];
    result.queue = self.queue;
    return result;
}


@end
