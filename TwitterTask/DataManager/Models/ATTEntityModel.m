//
//  ATTEntityModel.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 30/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTEntityModel.h"
#import "ATTEntityModel+ATTProtected.h"


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
    [result fillFromJson:json];
    return result;
}

- (void)fillFromJson:(NSDictionary *)json {
    // TODO: обрабатывать ошибки формата и парсинга.
    NSDictionary<NSString *, NSString *> *jsonMap = self.jsonMap;
    for (NSString *key in jsonMap) {
        NSString *keypath = jsonMap[key];
        NSObject *value = json[key];
        NSAssert1([self respondsToSelector:NSSelectorFromString(keypath)], @"No property '%@' in model.", keypath);

        if ([value isKindOfClass:[NSString class]]) {
            [self setValue:value forKeyPath:keypath];
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            // TODO: WRITE ME
        }
        else {
            NSAssert2(NO, @"Unknown behaviour for key %@ with value class %@", key, NSStringFromClass([value class]));
        }
    }
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
