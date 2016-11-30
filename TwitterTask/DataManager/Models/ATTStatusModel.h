//
//  ATTStatusModel.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 30/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTEntityModel.h"

@class ATTUserModel;


/**
 * @brief Модель данных Twitter-Статуса
 */
@interface ATTStatusModel : ATTEntityModel


/**
 * @brief Текст Twitter-статуса.
 * @details JSON text;
 */
@property (nonatomic, copy) NSString *text;

/**
 * @brief Модель пользователя Twitter.
 * @details JSON user.
 */
@property (nonatomic, strong) ATTUserModel *user;


@end
