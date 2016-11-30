//
//  ATTStatusTestsHelper.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 29/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

@class ATTStatusModel;


/**
 * @brief Класс-помщник для тестов Twitter-статусов.
 */
@interface ATTStatusTestsHelper : NSObject


/**
 * @brief Создаёт новый словарь, который является моком для распаршененого JSON'а из сети.
 * @return Возвращает NSDictionary, эмулирующий полученный из NetworkManager объект.
 */
+ (NSDictionary *)createJsonStatusWithId:(NSString *)statusId
                                  userId:(NSString *)userId
                         profileImageUrl:(NSString *)profileImageUrl;

/**
 * @brief Сравнить статус-модель с JSON-статусом.
 */
+ (BOOL)isEqualStatus:(ATTStatusModel *)statusModel toJson:(NSDictionary *)statusJson;


@end
