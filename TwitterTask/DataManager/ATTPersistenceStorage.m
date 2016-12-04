//
//  ATTPersistenceStorage.m
//  TwitterTask
//
//  Created by Oleg Lobachev on 28/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTPersistenceStorage.h"

#import <fmdb/FMDB.h>

#import "ATTPersistenceStorageObserver.h"
#import "ATTStatusModel.h"
#import "ATTUserModel.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


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
    NSAssert(NSOperationQueue.currentQueue == _queue, @"Impropper GCD queue.");
    NSAssert(_queue != nil, @"On start the queueu have to be defined.");
    if (self.queue == nil) {
        self.queue = NSOperationQueue.currentQueue;
    }
    [self startDb];
}

- (void)stop {
    NSAssert(NSOperationQueue.currentQueue == _queue, @"Impropper queue.");

    [_db close];
    _db = nil;
}

- (BOOL)isStarted {
    return (_db != nil);
}

- (void)startDb {
    NSAssert(NSOperationQueue.currentQueue == _queue, @"Impropper queue.");
    NSAssert(_db == nil, @"Database has opened.");
    if (_db == nil) {
        if (![self createTablesIfNeeds]) {
            [self stopDb];
        }
        else {
            NSArray<ATTStatusModel *> *loadedStatuses = [self loadSearchStatuses];
            [self applyAndNotifyAddSearchStatuses:loadedStatuses resultSearchStatuses:loadedStatuses];
        }
    }
}

- (BOOL)createTablesIfNeeds {
    NSAssert(NSOperationQueue.currentQueue == _queue, @"Impropper queue.");
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
    NSAssert(NSOperationQueue.currentQueue == _queue, @"Impropper queue.");
    _searchStatuses = nil;
    [_db close];
    _db = nil;
}

- (void)addSearchStatusesJson:(NSArray<NSDictionary *> *)statuses {
    NSAssert(NSOperationQueue.currentQueue == _queue, @"Impropper queue.");

    // Для простоты, принимаем, что статусы всегда отсортированы по дате.
    // - Самые новые статусы всегда идут первыми.
    // - Добавляются всегда более новые статусы (именно они приходят из сети).
    // - В списке нет "пропущенных" статусов.
    // Исходя из этих утверждений, справедливо:
    // - Добавляемые статусы добавляются в начало
    // - Если в добавляемом массиве встретился первый элемент исходного массива, то все остальные элементы будут совпадать.

    NSArray<ATTStatusModel *> *statusesForAdd = [self unparseSearchStatusesJson:statuses];
    statusesForAdd = [self filteredStatusesForAdd:statusesForAdd];
    [self addSearchStatuses:statusesForAdd];
}

- (NSArray<ATTStatusModel *> *)filteredStatusesForAdd:(NSArray<ATTStatusModel *> *)statuses {
    // self.searchStatuses - неизменяемый массив. Его состав не может измениться,
    // но он может поменяться полностью. Поэтому, мы сохраняем указатель на массив
    // и имея сохранённый указатель, можем безопасно по нему итерироваться.
    ATTStatusModel *currentHead = self.searchStatuses.firstObject;
    for (NSUInteger i = 0; i < statuses.count; ++i) {
        if ([statuses[i] isEqual:currentHead]) {
            if (i == 0) {
                return @[ ];
            }
            else {
                return [statuses subarrayWithRange:NSMakeRange(0, i)];
            }
        }
    }
    return statuses;
}

- (void)addSearchStatuses:(NSArray<ATTStatusModel *> *)statusesForAdd {
    NSAssert(NSOperationQueue.currentQueue == _queue, @"Impropper queue.");

    NSArray<ATTStatusModel *> *resultStatuses = [statusesForAdd arrayByAddingObjectsFromArray:self.searchStatuses];
    [self saveSearchStatuses:resultStatuses];

    [self applyAndNotifyAddSearchStatuses:statusesForAdd resultSearchStatuses:resultStatuses];
}

- (void)applyAndNotifyAddSearchStatuses:(NSArray<ATTStatusModel *> *)statusesForAdd
                   resultSearchStatuses:(NSArray<ATTStatusModel *> *)resultStatuses
{
    if (statusesForAdd.count > 0) {
        NSMutableArray<NSIndexPath *> *indexPaths = [@[ ] mutableCopy];
        for (NSInteger i = 0; i < statusesForAdd.count; ++i) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        WEAK_SELF
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            STRONG_SELF
            [strongSelf.observer storageWillChangeSearchStatuses:self];
            strongSelf.searchStatuses = resultStatuses;
            [strongSelf.observer storage:strongSelf didAddSearchStatusesAtIndexPaths:indexPaths];
            [strongSelf.observer storageDidChangeSearchStatuses:self];
        }];
    }
}

- (NSArray<ATTStatusModel *> *)unparseSearchStatusesJson:(NSArray<NSDictionary *> *)statuses {
    NSAssert(NSOperationQueue.currentQueue == _queue, @"Impropper queue.");

    NSMutableArray *modelStatuses = [@[ ] mutableCopy];
    for (NSDictionary *stJson in statuses) {
        ATTStatusModel *model = [ATTStatusModel createFromJson:stJson];
        if (model != nil) {
            [modelStatuses addObject:model];
        }
    }
    return modelStatuses;
}

- (void)saveSearchStatuses:(NSArray<ATTStatusModel *> *)statusesForSave {
    NSAssert(NSOperationQueue.currentQueue == _queue, @"Impropper queue.");

    [self.db beginTransaction];
    [statusesForSave enumerateObjectsUsingBlock:^(ATTStatusModel *status, NSUInteger idx, BOOL *stop) {
        status.idx = idx;
        [self saveSearchStatus:status];
    }];
    [self.db commit];
}

- (void)saveSearchStatus:(ATTStatusModel *)status {
    NSAssert(NSOperationQueue.currentQueue == _queue, @"Impropper queue.");
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
    NSAssert(NSOperationQueue.currentQueue == _queue, @"Impropper queue.");
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
    
    NSAssert(NSOperationQueue.currentQueue == _queue, @"Impropper queue.");

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
