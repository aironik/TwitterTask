//
//  ATTPersistenceStorage.m
//  TwitterTask
//
//  Created by Oleg Lobachev on 28/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTPersistenceStorage.h"

#import <fmdb/FMDB.h>

#import "ATTStatusModel.h"


@interface ATTPersistenceStorage()

@property (nonatomic, copy, readonly) NSString *storagePath;
@property (nonatomic, strong, readonly) FMDatabase *db;

@end


#pragma mark - Implementation

@implementation ATTPersistenceStorage


@synthesize storagePath = _storagePath;
@synthesize db = _db;


- (instancetype)init {
    NSAssert(NO, @"Для работы необходим storagePath. Для инициализации используйте -initWithStoragePath:.");
    return nil;
}
- (instancetype)initWithStoragePath:(NSString *)storagePath {
    if (self = [super init]) {
        _storagePath = [storagePath copy];
    }
    return self;
}

- (void)start {
    [self startDb];
}

- (void)stop {
    [_db close];
    _db = nil;
}

- (BOOL)isStarted {
    return (_db != nil);
}

- (void)startDb {
    NSAssert(_db == nil, @"Database has opened.");
    if (_db == nil) {
        _db = [FMDatabase databaseWithPath:self.storagePath];
    }
}

- (void)stopDb {
    NSAssert(_db != nil, @"Database is closed.");
    [_db close];
    _db = nil;
}

- (void)addSearchStatusesDicts:(NSArray<NSDictionary *> *)statuses {

}

- (NSArray<ATTStatusModel *> *)loadSearchStatuses {
    return @[ ];
}

@end
