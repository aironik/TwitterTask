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
static NSString *const kATTNetworkManagerStatusesKey = @"statuses";     // < Ключ массива
static const NSInteger kATTNetworkManagerErrorCode = 1;         // < Общая ошибка


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

/*
 * @brief Текущеий запрос, который выполняется.
 */
@property (nonatomic, strong) NSURLSessionTask *currentSearchTask;

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

- (void)search:(NSString *)searchText completionHandler:(ATTNetworkManagerSearchHandler)completionHandler {
    // Не организуем очередь. В каждый момент времени может выполняться только один запрос поиска,
    // остальные игнорируются.
    if (self.currentSearchTask == nil) {
        self.currentSearchTask = [self createTaskForSearch:searchText completionHandler:completionHandler];
        [self.currentSearchTask resume];
        ATTLog(ATT_NETWORK_LOG, @"Search Request started.");
    }
    else {
        ATTLog(ATT_NETWORK_LOG, @"Search Request executing. Ignore new one.");
        [self handleSearchError:@"Search Request already executing." completionHandler:completionHandler];
    }
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

- (NSURLSessionDataTask *)createTaskForSearch:(NSString *)searchText completionHandler:(ATTNetworkManagerSearchHandler)completionHandler {
    NSURLRequest *request = [self createRequestForSearch:searchText];

    WEAK_SELF;
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        STRONG_SELF;
        if (error != nil ||
                ![response isKindOfClass:[NSHTTPURLResponse class]]
                || [(NSHTTPURLResponse *)response statusCode] != 200)
        {
            [strongSelf handleSearchError:@"Search request returns error." completionHandler:completionHandler];
        }
        else {
            [strongSelf handleSearchResult:data completionHandler:completionHandler];
        }
        strongSelf.currentSearchTask = nil;
    }];

    return task;
}

- (void)handleSearchError:(NSString *)searchErrorString completionHandler:(ATTNetworkManagerSearchHandler)completionHandler {
    // TODO: handle errors
    ATTLog(ATT_NETWORK_LOG, @"Request error: %@", searchErrorString);
    NSError *error = [NSError errorWithDomain:@"me.aironik.Tasks.TwitterTask.NetworkError" code:kATTNetworkManagerErrorCode userInfo:@{}];
    completionHandler(nil, error);
}

- (void)handleSearchResult:data completionHandler:(ATTNetworkManagerSearchHandler)completionHandler {
    ATTLog(ATT_NETWORK_LOG, @"Result: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (![response isKindOfClass:[NSDictionary class]]) {
        [self handleSearchError:@"Error parse search result." completionHandler:completionHandler];
    }
    else {
        NSArray *statuses = response[kATTNetworkManagerStatusesKey];
        if (![statuses isKindOfClass:[NSArray class]]) {
            [self handleSearchError:@"Error parse search result." completionHandler:completionHandler];
        }
        else {
            [self handleSearchResultWithStatuses:statuses completionHandler:completionHandler];
        }
    }
}

- (void)handleSearchResultWithStatuses:(NSArray *)statuses  completionHandler:(ATTNetworkManagerSearchHandler)completionHandler {
    ATTLog(ATT_NETWORK_LOG, @"Received %@ statuses", @([statuses count]));
    completionHandler(statuses, nil);
}


@end
