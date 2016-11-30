//
//  ATTUserModel.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 30/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTUserModel.h"

#import "ATTEntityModel.h"
#import "ATTEntityModel+ATTProtected.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTUserModel ()
@end


#pragma mark - Implementation

@implementation ATTUserModel


ATT_ENTITY_MODEL_IMPLEMENT_JSON_MAP_BEGIN
ATT_ENTITY_MODEL_IMPLEMENT_JSON_MAP_PROPERTY_NAME(@"name", @"name")
ATT_ENTITY_MODEL_IMPLEMENT_JSON_MAP_PROPERTY_NAME(@"profile_image_url_https", @"profileImageUrlHttps")
ATT_ENTITY_MODEL_IMPLEMENT_JSON_MAP_END


@end
