//
//  ATTNetworkManager.m
//  TwitterTask
//
//  Created by Oleg Lobachev on 23/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTNetworkManager.h"


@interface ATTNetworkManager()

/*
 * @brief access_token для аутентификации запросов на сервер. 
 * @details Добавляется в заголовок Authorization. 
 *      Полностью сформированная строка (bearer с_токеном).
 */
@property (nonatomic, copy, readonly) NSString *accessToken;

@end


#pragma merk - 

@implementation ATTNetworkManager


@synthesize accessToken = _accessToken;


- (instancetype)init {
    NSAssert(NO, @"Для работы необходим accessToken. Для инициализации используйте -initWithAccessToken.");
    return nil;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken {
    if (self = [super init]) {
        NSAssert([accessToken length] > 0, @"accessToken необходим для запросов и не может быть пустым");
        _accessToken = [accessToken copy];
    }
    return self;
}


@end
