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
