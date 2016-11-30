//
//  ATTStatusTestsHelper.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 29/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

@class ATTStatusModel;
@class ATTUserModel;


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
+ (BOOL)isEqualStatus:(ATTStatusModel *)model toJson:(NSDictionary *)json;

/**
 * @brief Сравнить модель User с JSON-статусом.
 */
+ (BOOL)isEqualUser:(ATTUserModel *)model toJson:(NSDictionary *)json;

@end
