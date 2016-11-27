//
//  ATTNetworkManager.m
//  TwitterTask
//
//  Created by Oleg Lobachev on 23/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTNetworkManager.h"


static const NSTimeInterval kATTNetworkManagerTimeout = 30.;    // < Timeout сетевых запросов
static const NSTimeInterval kATTNetworkManagerRetrive = 60.;    // < Время между запросами до повторения.


@interface ATTNetworkManager()

/*
 * @brief access_token для аутентификации запросов на сервер. 
 * @details Добавляется в заголовок Authorization. 
 *      Полностью сформированная строка (bearer с_токеном).
 */
@property (nonatomic, copy, readonly) NSString *accessToken;

/*
 * @brief NEURLSession, через которую происходят сетевые запросы.
 */
@property (nonatomic, strong, readonly) NSURLSession *urlSession;

/*
 * @brief HTTP заголовки, которые добавляются во все сетевые запросы.
 */
@property (nonatomic, copy, readonly) NSDictionary *httpHeaders;

@end


#pragma merk - 

@implementation ATTNetworkManager


@synthesize accessToken = _accessToken;
@synthesize urlSession = _urlSession;
@synthesize httpHeaders = _httpHeaders;


- (instancetype)init {
    NSAssert(NO, @"Для работы необходим accessToken. Для инициализации используйте -initWithAccessToken.");
    return nil;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken {
    if (self = [super init]) {
        NSAssert([accessToken length] > 0, @"accessToken необходим для запросов и не может быть пустым");
        _accessToken = [accessToken copy];
        
        NSURLSessionConfiguration *urlSessionConfiguration = [[NSURLSessionConfiguration defaultSessionConfiguration] copy];
        urlSessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
        _urlSession = [NSURLSession sessionWithConfiguration:urlSessionConfiguration];
        ATTLog(ATT_NETWORK_LOG, @"NSURLSession has started.");
    }
    return self;
}

- (void)dealloc {
    [_urlSession invalidateAndCancel];
}

- (NSDictionary *)httpHeaders {
    if (_httpHeaders == nil) {
        _httpHeaders = @{
            @"User-Agent": @"TwitterTask",
            @"Authorization": _accessToken,
        };
    }
    return _httpHeaders;
}

- (void)search:(NSString *)searchText {
    NSURLSessionDataTask *task = [self createTaskForSearch:searchText];
    [task resume];
    ATTLog(ATT_NETWORK_LOG, @"Search Request started");
}

- (NSURLRequest *)createRequestForSearch:(NSString *)searchText {
    // TODO: URL Encode searchText
    NSString *encodedSearchText = [searchText stringByAddingPercentEncodingWithAllowedCharacters:
                                   [NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlString = [@"https://api.twitter.com/1.1/search/tweets.json?q=" stringByAppendingString:encodedSearchText];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:kATTNetworkManagerTimeout];
    request.allHTTPHeaderFields = self.httpHeaders;
    request.timeoutInterval = kATTNetworkManagerTimeout;
    
    return request;
}

- (NSURLSessionDataTask *)createTaskForSearch:(NSString *)searchText {
    NSURLRequest *request = [self createRequestForSearch:searchText];

    WEAK_SELF;
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        STRONG_SELF;
        [strongSelf handleSearchResult:data response:response error:error];
    }];

    return task;
}

- (void)handleSearchResult:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {
    // TODO: Error does't handle.
    if (error != nil || ![response isKindOfClass:[NSHTTPURLResponse class]] || [(NSHTTPURLResponse*)response statusCode] != 200) {
        // TODO: Handle Errors.
        ATTLog(ATT_NETWORK_LOG, @"ERROR: Request finish with error.");
    }
    else {
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        ATTLog(ATT_NETWORK_LOG, @"Result: %@", jsonString);
        
    }

}


@end
