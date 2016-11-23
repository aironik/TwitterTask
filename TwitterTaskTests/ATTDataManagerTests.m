//
//  ATTDataManagerTests.m
//  TwitterTask
//
//  Created by Oleg Lobachev on 22/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ATTDataManager.h"


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

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
