//
//  ATTEntityModel.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 30/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTEntityModel.h"
#import "ATTEntityModel+ATTProtected.h"

#import <objc/objc-runtime.h>


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTEntityModel ()
@end


#pragma mark - Implementation

@implementation ATTEntityModel


@synthesize jsonMap = _jsonMap;


+ (instancetype)createFromJson:(NSDictionary *)json {
    ATTEntityModel *result = [[[self class] alloc] init];
    if (![result fillFromJson:json]) {
        return nil;
    }
    return result;
}

- (BOOL)fillFromJson:(NSDictionary *)json {
    // Для простоты не учитываем дублирований записей. Всегда создаём новую копию.

    BOOL result = YES;
    // TODO: обрабатывать ошибки формата и парсинга.
    NSDictionary<NSString *, NSString *> *jsonMap = self.jsonMap;
    for (NSString *key in jsonMap) {
        result = (result && [self fillKeypath:jsonMap[key] withJsonValue:json[key]]);
    }
    return result;
}

- (BOOL)fillKeypath:(NSString *)keypath withJsonValue:(NSObject *)value {
    BOOL result = YES;
    NSAssert1([self respondsToSelector:NSSelectorFromString(keypath)], @"No property '%@' in model.", keypath);
    if (value == nil || value == [NSNull null]) {
        [self setValue:nil forKeyPath:keypath];
    }
    else if ([value isKindOfClass:[NSString class]]) {
        [self setValue:value forKeyPath:keypath];
    }
    else if ([value isKindOfClass:[NSDictionary class]]) {
        Class propertyClass = [self getPropertyClass:keypath];
        if (propertyClass != Nil && [propertyClass isSubclassOfClass:[ATTEntityModel class]]) {
            ATTEntityModel *entityValue = [propertyClass createFromJson:(NSDictionary *)value];
            [self setValue:entityValue forKeyPath:keypath];
        }
        else {
            result = NO;
        }
    }
    else {
        NSAssert2(NO, @"Unknown behaviour for key (keypath %@) with value class %@", keypath, NSStringFromClass([value class]));
        result = NO;
    }
    return result;
}

- (Class)getPropertyClass:(NSString *)keypath {
    NSString *typeString = nil;
    Class class = [self class];
    objc_property_t property = class_getProperty(class, [keypath UTF8String]);
    if (property != NULL) {
        unsigned int outCount = 0;
        objc_property_attribute_t *prop_attrs = property_copyAttributeList(property, &outCount);
        for (int i = 0; outCount; ++i) {
            if (prop_attrs[i].name[0] == 'T' && prop_attrs[i].value != NULL) {     // < атрибут -- тип свойства
                typeString = [NSString stringWithUTF8String:prop_attrs[i].value];
                break;
            }
        }
        free(prop_attrs);
    }
    
    if ([typeString hasPrefix:@"@"]) {      // < Только для классов ObjC
        typeString = [typeString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        return NSClassFromString(typeString);
    }
    return Nil;
}
    
- (NSDictionary<NSString *, NSString *> *)jsonMap {
    if (_jsonMap == nil) {
        _jsonMap = [[[self class] createJsonMap] copy];
    }
    return _jsonMap;
}

+ (NSMutableDictionary<NSString *, NSString *> *)createJsonMap {
    NSMutableDictionary<NSString *, NSString *> *result = [@{ } mutableCopy];
    result[@"id_str"] = @"entityId";
    return result;
}


@end
