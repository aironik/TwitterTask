//
//  ATTEntityModel(ATTProtected).m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 30/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//


#import "ATTEntityModel.h"


//* @details json_key_name => entityPropertyKeypath.

#define ATT_ENTITY_MODEL_IMPLEMENT_JSON_MAP_BEGIN \
    + (NSMutableDictionary<NSString *, NSString *> *)createJsonMap { \
        NSMutableDictionary<NSString *, NSString *> *result = [super createJsonMap];

#define ATT_ENTITY_MODEL_IMPLEMENT_JSON_MAP_PROPERTY_NAME(jsonKeyName, entityPropertyKeypath) \
        result[jsonKeyName] = entityPropertyKeypath;

#define ATT_ENTITY_MODEL_IMPLEMENT_JSON_MAP_END \
        return result; \
    }


@interface ATTEntityModel (ATTProtected)


/**
 * @brief Создать словарь соответствия jsonMap;
 */
+ (NSMutableDictionary<NSString *, NSString *> *)createJsonMap;


@end

