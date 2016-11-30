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

@property (nonatomic, strong) NSArray<ATTStatusModel *> *searchStatuses;

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
        if (![self createTablesIfNeeds]) {
            [self stopDb];
        }
        else {
            _searchStatuses = @[ ];
        }
    }
}

- (BOOL)createTablesIfNeeds {
    BOOL result = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.storagePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[self.storagePath stringByDeletingLastPathComponent]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.storagePath];
    _db = [FMDatabase databaseWithPath:self.storagePath];
    if ([_db open]) {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS search_statuses ( "
                @"  id_str TEXT NOT NULL ON CONFLICT IGNORE UNIQUE ON CONFLICT REPLACE, "
                @"  text TEXT, "
                @"  user_id_str TEXT NOT NULL ON CONFLICT IGNORE "
                @");"
                @"CREATE TABLE IF NOT EXISTS users ( "
                @"  id_str TEXT NOT NULL ON CONFLICT IGNORE UNIQUE ON CONFLICT REPLACE, "
                @"  name TEXT NOT NULL ON CONFLICT IGNORE, "
                @"  profile_image_url_https TEXT "
                @");";
        result = [_db executeStatements:sql];
    }
    return result;
}

- (void)stopDb {
    _searchStatuses = nil;
    [_db close];
    _db = nil;
}

- (void)addSearchStatusesJson:(NSArray<NSDictionary *> *)statuses {
    NSArray<ATTStatusModel *> *modelStatuses = [self unparseSearchStatusesJson:statuses];
    [self addSearchStatuses:modelStatuses];
    [self saveSearchStatuses];
}

- (void)addSearchStatuses:(NSArray<ATTStatusModel *> *)statuses {
    self.searchStatuses = [statuses arrayByAddingObjectsFromArray:self.searchStatuses];
}

- (NSArray<ATTStatusModel *> *)unparseSearchStatusesJson:(NSArray<NSDictionary *> *)statuses {
    NSMutableArray *modelStatuses = [@[ ] mutableCopy];
    for (NSDictionary *stJson in statuses) {
        ATTStatusModel *model = [ATTStatusModel createFromJson:stJson];
        if (model != nil) {
            [modelStatuses addObject:model];
        }
    }
    return modelStatuses;
}

- (void)saveSearchStatuses {
}

- (NSArray<ATTStatusModel *> *)loadSearchStatuses {
    return @[ ];
}

@end
