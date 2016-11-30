//
//  ATTEntityModel.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 30/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//


/**
 * @brief Базовый класс для моделей данных хранилища
 */
@interface ATTEntityModel : NSObject


/**
 * @brief Уникальный идентификатор сущности
 * @details JSON id_str
 */
@property (nonatomic, copy) NSString *entityId;

/**
 * @brief Словарь соответствий свойств Entity полям JSON'а.
 * @details json_key_name => entityPropertyKeypath.
 * @return
 */
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSString *> *jsonMap;


@end
