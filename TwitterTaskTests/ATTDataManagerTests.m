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


#pragma mark - ATTDataManager

@interface ATTDataManager(Tests)

@property (nonatomic, strong) ATTNetworkManager *networkManager;

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

    [dataManager stop];
    XCTAssertNil(dataManager.networkManager, @"После остановки DataManager сеть должна остановиться.");
}

@end
