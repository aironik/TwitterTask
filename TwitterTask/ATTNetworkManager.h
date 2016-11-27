//
//  ATTNetworkManager.h
//  TwitterTask
//
//  Created by Oleg Lobachev on 23/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import <Foundation/Foundation.h>


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
 * @brief Выполнить поисковый запрос
 * @details
 *      cat access_token.txt | xargs -0 curl -v -X GET "https://api.twitter.com/1.1/search/tweets.json?q=mobile" -o search.json -H
 */
- (void)search:(NSString *)searchText completionHandler:(ATTNetworkManagerSearchHandler)completionHandler;

@end
