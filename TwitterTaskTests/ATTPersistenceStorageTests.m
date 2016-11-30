//
//  ATTPersistenceStorageTests.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 29/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//


#import <XCTest/XCTest.h>

#import "ATTPersistenceStorage.h"
#import "ATTPersistenceStorageTestsHelper.h"
#import "ATTStatusModel.h"
#import "ATTStatusTestsHelper.h"
#import "ATTUserModel.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


#pragma mark - Test Friends Categories

@interface ATTPersistenceStorage(PersistenceStorageTests)
@end


#pragma mark - Tests

@interface ATTPersistenceStorageTests : XCTestCase

@end


#pragma mark - Implementation

@implementation ATTPersistenceStorageTests


- (void)setUp {
    [super setUp];

    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.

    [super tearDown];
}

- (void)testEmptyNewStorage {
    ATTPersistenceStorage *persistenceStorage = [ATTPersistenceStorageTestsHelper createWithNewTemporaryStorage];

    NSArray *loadedSearchStatuses = [persistenceStorage loadSearchStatuses];
    XCTAssertNotNil(loadedSearchStatuses, @"Загруженные статусы всегда должны быть массивом");
    XCTAssertEqual([loadedSearchStatuses count], 0, @"В новом хранилище не должно быть данных");
}


- (void)testCreateUserModelFromJson {
    NSDictionary *json = [ATTStatusTestsHelper createJsonStatusWithId:@"12345678901234567890"
                                                               userId:@"12345678901234567890"
                                                      profileImageUrl:@"https://pbs.twimg.com/profile_images/674920599102349312/zXwTYz-T_normal.jpg"];
    ATTUserModel *model = [ATTUserModel createFromJson:json[@"user"]];
    XCTAssertTrue([ATTStatusTestsHelper isEqualUser:model toJson:json[@"user"]],
            @"Загруженный объект не равер сохранённому.");
}

- (void)testCreateStatusModelFromJson {
    NSDictionary *json = [ATTStatusTestsHelper createJsonStatusWithId:@"12345678901234567890"
                                                               userId:@"12345678901234567890"
                                                      profileImageUrl:@"https://pbs.twimg.com/profile_images/674920599102349312/zXwTYz-T_normal.jpg"];
    ATTStatusModel *model = [ATTStatusModel createFromJson:json];
    XCTAssertTrue([ATTStatusTestsHelper isEqualStatus:model toJson:json],
            @"Загруженный объект не равер сохранённому.");
}

- (void)testLoadSaved {
    ATTPersistenceStorage *persistenceStorage = [ATTPersistenceStorageTestsHelper createWithMemoryStorage];

    NSDictionary *json1 = [ATTStatusTestsHelper createJsonStatusWithId:@"12345678901234567890"
                                                                userId:@"12345678901234567890"
                                                       profileImageUrl:@"https://pbs.twimg.com/profile_images/674920599102349312/zXwTYz-T_normal.jpg"];
    NSDictionary *json2 = [ATTStatusTestsHelper createJsonStatusWithId:@"12345678901234567891"
                                                                userId:@"12345678901234567892"
                                                       profileImageUrl:@"https://pbs.twimg.com/profile_images/674920599102349/zXwTYz-T_normal.jpg"];
    NSDictionary *json3 = [ATTStatusTestsHelper createJsonStatusWithId:@"12345678901234567893"
                                                                userId:@"12345678901234567890"
                                                       profileImageUrl:@"https://pbs.twimg.com/profile_images/674920599102349312/zXwTYz-T_normal.jpg"];

    NSArray<NSDictionary *> *jsonStatuses = @[
            json1,
            json2,
            json3
    ];
    [persistenceStorage addSearchStatusesDicts:jsonStatuses];

    NSArray<ATTStatusModel *> *loadedSearchStatuses = [persistenceStorage loadSearchStatuses];
    XCTAssertEqual([loadedSearchStatuses count], [jsonStatuses count], @"Загружено должно быть столько же, сколько сохранялось.");

    for (NSUInteger i = 0; i < 3; ++i) {
        ATTStatusModel *model = loadedSearchStatuses[i];
        XCTAssertTrue([ATTStatusTestsHelper isEqualStatus:loadedSearchStatuses[i] toJson:jsonStatuses[i]],
                @"Загруженный объект не равер сохранённому.");
    }
}


@end
