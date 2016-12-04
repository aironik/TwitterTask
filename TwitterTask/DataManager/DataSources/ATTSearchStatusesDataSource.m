//
//  ATTSearchStatusesDataSource.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 04/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTSearchStatusesDataSource.h"

#import "ATTNetworkManager.h"
#import "ATTPersistenceStorage.h"
#import "ATTPersistenceStorageObserver.h"
#import "ATTStatusesDataSource.h"
#import "ATTStatusesDataSourceObserver.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTSearchStatusesDataSource ()<ATTPersistenceStorageObserver>

@property (nonatomic, strong) ATTPersistenceStorage *storage;
@property (nonatomic, strong) ATTNetworkManager *networkManager;

@end


#pragma mark - Implementation

@implementation ATTSearchStatusesDataSource


@synthesize statuses = _statuses;
@synthesize observer = _observer;


- (instancetype)initWithPersistenceStorage:(ATTPersistenceStorage *)storage  networkManager:(ATTNetworkManager *)networkManager {
    if (storage == nil || networkManager == nil) {
        self = nil;
    }
    else if (self = [super init]) {
        _storage = storage;
        _networkManager = networkManager;
        storage.observer = self;
    }
    return self;
}


#pragma mark - ATTPersistenceStorageObserver

- (void)storageWillChangeSearchStatuses:(ATTPersistenceStorage *)storage {
    __strong id<ATTStatusesDataSourceObserver> observer = self.observer;
    [observer dataSourceWillChangeStatuses:self];
}

- (void)storage:(ATTPersistenceStorage *)storage didAddSearchStatusesAtIndexPaths:(NSMutableArray<NSIndexPath *> *)indexPaths {
    self.statuses = storage.searchStatuses;
    __strong id<ATTStatusesDataSourceObserver> observer = self.observer;
    [observer dataSource:self didAddStatusesAtIndexPaths:indexPaths];
}

- (void)storageDidChangeSearchStatuses:(ATTPersistenceStorage *)storage {
    __strong id<ATTStatusesDataSourceObserver> observer = self.observer;
    [observer dataSourceDidChangeStatuses:self];
}


@end
