//
//  ATTStatusTestsHelper.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 29/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTStatusTestsHelper.h"

#import <XCTest/XCTest.h>

#import "ATTStatusModel.h"
#import "ATTUserModel.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTStatusTestsHelper ()
@end


#pragma mark - Implementation

@implementation ATTStatusTestsHelper


+ (NSDictionary *)createJsonStatusWithId:(NSString *)statusId
                                  userId:(NSString *)userId
                         profileImageUrl:(NSString *)profileImageUrl
{
    // Мы используем только часть полей. Поэтому, для тестов используем сокращённый вариант.
//        @"{"
//            @"'id': 801533559660023808,"
//            @"'id_str': '801533559660023808',"
//            @"'text': 'Tweet with id 801533559660023808 Text 1',"
//            @"'user': {"
//                @"'id': 150663697,"
//                @"'id_str': '150663697',"
//                @"'name': 'JarQue DeJota',"
//                @"'profile_image_url_https': 'https://pbs.twimg.com/profile_images/674920599102349312/zXwTYz-T_normal.jpg',"
//            @"}"
//        @"},"
    return @{
            @"id_str": statusId,
            @"text": [NSString stringWithFormat:@"Tweet Text With id %@.", statusId],
            @"user": @{
                    @"id_str": userId,
                    @"name": [NSString stringWithFormat:@"User With id %@", userId],
                    @"profile_image_url_https": profileImageUrl
            }
    };
}

+ (BOOL)isEqualStatus:(ATTStatusModel *)model toJson:(NSDictionary *)json {
    BOOL result = YES;
    XCTAssertTrue((result = result && [model.entityId isEqualToString:json[@"id_str"]]), @"Не равны");
    XCTAssertTrue((result = result && [model.text isEqualToString:json[@"text"]]), @"Не равны");
    result = result && [self isEqualUser:model.user toJson:json[@"user"]];
    return result;
}

+ (BOOL)isEqualUser:(ATTUserModel *)model toJson:(NSDictionary *)json {
    BOOL result = YES;
    XCTAssertTrue((result = result && [model.entityId isEqualToString:json[@"id_str"]]), @"Не равны");
    XCTAssertTrue((result = result && [model.name isEqualToString:json[@"name"]]), @"Не равны");
    XCTAssertTrue((result = result && [model.profileImageUrlHttps isEqualToString:json[@"profile_image_url_https"]]), @"Не равны");
    return result;
}

@end
