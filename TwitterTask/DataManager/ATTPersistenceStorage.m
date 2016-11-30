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
#import "ATTUserModel.h"


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
    ATTLog(ATT_STORAGE_LOG, @"Open database %@", self.storagePath);
    _db = [FMDatabase databaseWithPath:self.storagePath];
    if ([_db open]) {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS search_statuses ( "
                @"  id_str TEXT NOT NULL ON CONFLICT IGNORE UNIQUE ON CONFLICT REPLACE, "
                @"  idx INTEGER NOT NULL, "
                @"  text TEXT, "
                @"  user_id_str TEXT NOT NULL ON CONFLICT IGNORE "
                @");"
                @"CREATE TABLE IF NOT EXISTS users ( "
                @"  id_str TEXT NOT NULL ON CONFLICT IGNORE UNIQUE ON CONFLICT REPLACE, "
                @"  name TEXT NOT NULL ON CONFLICT IGNORE, "
                @"  profile_image_url_https TEXT "
                @");";
        result = [_db executeStatements:sql];
#if ATT_TRACE_SQLITE
        if ([_db executeStatements:@"PRAGMA sql_trace = true;"]) {
            ATTLog(ATT_STORAGE_LOG, @"sqlite trace enabled (PRAGMA sql_trace = true;)");
        }
#endif // ATT_TRACE_SQLITE
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
    [self.db beginTransaction];
    [self.searchStatuses enumerateObjectsUsingBlock:^(ATTStatusModel *status, NSUInteger idx, BOOL *stop) {
        status.idx = idx;
        [self saveSearchStatus:status];
    }];
    [self.db commit];
}

- (void)saveSearchStatus:(ATTStatusModel *)status {
    NSString *sql = @"INSERT INTO search_statuses ("
            @"      id_str, idx, text, user_id_str "
            @"  )"
            @"  VALUES ( "
            @"      (?), "
            @"      (?), "
            @"      (?), "
            @"      (?) "
            @"  );";
    [self.db executeUpdate:sql, status.entityId, @(status.idx), status.text, status.user.entityId];

    [self saveUser:status.user];
}

- (void)saveUser:(ATTUserModel *)user {
    NSString *sql = @"INSERT INTO users ("
            @"      id_str, name, profile_image_url_https "
            @"  )"
            @"  VALUES ( "
            @"      (?), "
            @"      (?), "
            @"      (?) "
            @"  );";
    [self.db executeUpdate:sql, user.entityId, user.name, user.profileImageUrlHttps];
}

- (NSArray<ATTStatusModel *> *)loadSearchStatuses {
    // Для простоты не учитываем дублирований записей. Всегда создаём новую копию.
    
    NSMutableArray<ATTStatusModel *> *result = [@[ ] mutableCopy];
    NSString *sql = @"SELECT search_statuses.id_str, idx, text, user_id_str, name, profile_image_url_https "
            @"  FROM search_statuses "
            @"  LEFT OUTER JOIN users "
            @"  WHERE search_statuses.user_id_str = users.id_str;";
    FMResultSet *resultSet = [_db executeQuery:sql];

    while ([resultSet next]) {
        ATTStatusModel *status = [[ATTStatusModel alloc] init];
        status.entityId = [resultSet stringForColumn:@"id_str"];
        status.idx = [resultSet intForColumn:@"idx"];
        status.text = [resultSet stringForColumn:@"text"];

        status.user = [[ATTUserModel alloc] init];
        status.user.entityId = [resultSet stringForColumn:@"user_id_str"];
        status.user.name = [resultSet stringForColumn:@"name"];
        status.user.profileImageUrlHttps = [resultSet stringForColumn:@"profile_image_url_https"];
        
        [result addObject:status];
    }
    return [result copy];
}

@end
