//
//  ATTNetworkManager.h
//  TwitterTask
//
//  Created by Oleg Lobachev on 23/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * @brief Класс, являющей центром сетевой активности.
 */
@interface ATTNetworkManager : NSObject

/**
 * @brief Инициализировать новый объект сетевого менеджера.
 * @param accessToken токен для доступа к API.
 */
- (instancetype)initWithAccessToken:(NSString *)accessToken;


@end
