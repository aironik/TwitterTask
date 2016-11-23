//
//  ATTDataManager.h
//  TwitterTask
//
//  Created by Oleg Lobachev on 22/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATTDataManager : NSObject


/**
 * @brief Подготовить все данные и запустить менеджер данных.
 */
- (void)start;

/**
 * @brief Остановить менеджер данных и очистить все используемые ресурсы.
 */
- (void)stop;

/**
 * @brief Флаг готовности к работе.
 */
@property (nonatomic, readonly, getter=isStarted) BOOL started;


@end
