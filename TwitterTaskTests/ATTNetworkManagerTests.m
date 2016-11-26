//
//  ATTNetworkManagerTests.m
//  TwitterTask
//
//  Created by Oleg Lobachev on 23/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "ATTNetworkManager.h"


#pragma mark - Test Friends Categories

@interface ATTNetworkManager(NetworkManagerTests)

- (NSURLSessionDataTask *)createTaskForSearch:(NSString *)searchText;

@end


#pragma mark - Tests

@interface ATTNetworkManagerTests : XCTestCase

@property (nonatomic, copy, readonly) NSString *accessTocken;
@property (nonatomic, strong) ATTNetworkManager *networkManager;

@end



@implementation ATTNetworkManagerTests


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.networkManager = [[ATTNetworkManager alloc] initWithAccessToken:self.accessTocken];
}

- (void)tearDown {
    self.networkManager = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (NSString *)accessTocken {
    return @"test_access_token";
}

- (NSString *)searchText {
    return @"String For My Search";
}

- (void)testOnSearchStartNetworkRequest {
    id myNetworkManager = OCMPartialMock(self.networkManager);

    NSURLSessionTask *searchTask = OCMClassMock([NSURLSessionTask class]);
    OCMStub([searchTask resume]);
    OCMStub([myNetworkManager createTaskForSearch:self.searchText]).andReturn(searchTask);

    [myNetworkManager search:self.searchText];
    
    OCMVerify([searchTask resume]);
}

- (void)testSearchNetworkData {
    NSURLSessionTask *task = [self.networkManager createTaskForSearch:self.searchText];
    
    XCTAssertEqualObjects(task.currentRequest.HTTPMethod, @"GET", @"Неправильный метод для запроса.");
    XCTAssertEqualObjects(task.currentRequest.allHTTPHeaderFields[@"Authorization"], self.accessTocken, @"Нет заголовка авторизации.");

    NSString *query = [task.currentRequest.URL query];
    NSString *searchQuery = [query stringByRemovingPercentEncoding];
    XCTAssertTrue([searchQuery hasSuffix:self.searchText], @"Неправильный запрос");
}

@end
