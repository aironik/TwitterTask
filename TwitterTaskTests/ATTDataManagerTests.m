//
//  ATTDataManagerTests.m
//  TwitterTask
//
//  Created by Oleg Lobachev on 22/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ATTDataManager.h"
#import "ATTNetworkManager.h"
#import "ATTPersistenceStorage.h"


#pragma mark - Test Friends Categories

@interface ATTDataManager(DataManagerTests)

@property (nonatomic, strong) ATTNetworkManager *networkManager;
@property (nonatomic, strong) ATTPersistenceStorage *persistenceStorage;

@end

@interface ATTNetworkManager(DataManagerTests)

@property (nonatomic, copy, readonly) NSString *accessToken;

@end


#pragma mark - Tests

@interface ATTDataManagerTests : XCTestCase
@end


@implementation ATTDataManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStartAndStopDataManager {
    // Проверяем запуск менеджера.
    ATTDataManager *dataManager = [[ATTDataManager alloc] init];
    XCTAssertFalse(dataManager.started, @"До запуска DataManager должен быть !started");
    
    [dataManager start];
    XCTAssertTrue(dataManager.started, @"Запущенный DataManager должен быть стартован");
    
    [dataManager stop];
    XCTAssertFalse(dataManager.started, @"Остановленный DataManager должен быть !started");
}

- (void)testStartNetworkOnStartDataManager {
    // Проверяем, что запускается сетеывой менеджер при старте DataManager.
    
    ATTDataManager *dataManager = [[ATTDataManager alloc] init];
    XCTAssertNil(dataManager.networkManager, @"До запуска DataManager сеть не работает.");
    
    [dataManager start];
    XCTAssertNotNil(dataManager.networkManager, @"При запуске DataManager должен запустить сеть.");
    XCTAssertTrue(dataManager.networkManager.started, @"При запуске DataManager должен запустить сеть.");
    XCTAssertGreaterThan([dataManager.networkManager.accessToken length], 0, @"Network Manager должен запуститься с access_token'ом.");

    [dataManager stop];
    XCTAssertFalse(dataManager.networkManager.started, @"После остановки DataManager должен остановить сеть.");
    XCTAssertNil(dataManager.networkManager, @"После остановки DataManager сеть должна остановиться.");
}

- (void)testStartStorageOnStartDataManager {
    // Проверяем, что запускается хранилище данных при старте DataManager.
    
    ATTDataManager *dataManager = [[ATTDataManager alloc] init];
    XCTAssertNil(dataManager.persistenceStorage, @"До запуска DataManager хранилище не работает.");
    
    [dataManager start];
    XCTAssertNotNil(dataManager.persistenceStorage, @"При запуске DataManager должен запустить хранилище.");
    XCTAssertTrue(dataManager.persistenceStorage.started, @"При запуске DataManager хранилище должно запуститься.");
    
    [dataManager stop];
    XCTAssertNil(dataManager.persistenceStorage, @"После остановки DataManager хранилище должно остановиться.");
}


@end
