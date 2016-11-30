//
//  ATTStatusModel.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 30/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTStatusModel.h"

#import "ATTEntityModel.h"
#import "ATTEntityModel+ATTProtected.h"
#import "ATTUserModel.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTStatusModel ()
@end


#pragma mark - Implementation

@implementation ATTStatusModel


ATT_ENTITY_MODEL_IMPLEMENT_JSON_MAP_BEGIN
ATT_ENTITY_MODEL_IMPLEMENT_JSON_MAP_PROPERTY_NAME(@"text", @"text")
ATT_ENTITY_MODEL_IMPLEMENT_JSON_MAP_PROPERTY_NAME(@"user", @"user")
ATT_ENTITY_MODEL_IMPLEMENT_JSON_MAP_END


@end
