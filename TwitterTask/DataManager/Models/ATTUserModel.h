//
//  ATTUserModel.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 30/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//



#import "ATTEntityModel.h"

/**
 * @brief Модель данных пользователя Twitter.
 */
@interface ATTUserModel : ATTEntityModel


/**
 * @brief Ник пользователя.
 * @details JSON name
 */
@property (nonatomic, copy) NSString *name;

/**
 * @brief URL до картинки-аватарки пользователя.
 * @detail JSON profile_image_url_https
 */
@property (nonatomic, copy) NSString *profileImageUrlHttps;


@end
