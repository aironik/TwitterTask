//
//  ATTNetworkManager.h
//  TwitterTask
//
//  Created by Oleg Lobachev on 23/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

typedef void(^ATTNetworkManagerSearchHandler)(NSArray *searchResults, NSError *error);

/**
 * @brief Класс, являющей центром сетевой активности.
 */
@interface ATTNetworkManager : NSObject

/**
 * @brief Инициализировать новый объект сетевого менеджера.
 * @param accessToken токен для доступа к API.
 */
- (instancetype)initWithAccessToken:(NSString *)accessToken;

/**
 * @brief Подготавливает окружение, стартует сессию...
 */
- (void)start;

/**
 * @brief Останавливает сетевое взаимодействие и освобождает ресурсы.
 */
- (void)stop;

/**
 * @brief Флаг готовности к работе.
 */
@property (nonatomic, assign, readonly, getter=isStarted) BOOL started;

/**
 * @brief Очередь, на которой выполняются операции.
 */
@property (nonatomic, strong) NSOperationQueue *queue;

/**
 * @brief Выполнить поисковый запрос
 * @details
 *      cat access_token.txt | xargs -0 curl -v -X GET "https://api.twitter.com/1.1/search/tweets.json?q=mobile" -o search.json -H
 */
- (void)search:(NSString *)searchText completionHandler:(ATTNetworkManagerSearchHandler)completionHandler;

@end
