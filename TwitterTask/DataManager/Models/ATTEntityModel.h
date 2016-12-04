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
 * @brief Создать объект модели из десериализованного JSON.
 * @param json - NSDictionary, десереализованный из серверного JSON.
 * @return Новый, заполненный в соответствии с начальными данными, объект модели.
 */
+ (instancetype)createFromJson:(NSDictionary *)json;

/**
 * @brief Уникальный идентификатор сущности
 * @details JSON id_str
 */
@property (nonatomic, copy) NSString *entityId;

/**
 * @brief Словарь соответствий свойств Entity полям JSON'а.
 * @details json_key_name => entityPropertyKeypath.
 */
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSString *> *jsonMap;


@end
