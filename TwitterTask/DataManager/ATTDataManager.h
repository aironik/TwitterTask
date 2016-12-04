//
//  ATTDataManager.h
//  TwitterTask
//
//  Created by Oleg Lobachev on 22/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//


@class ATTPersistenceStorage;
@class ATTNetworkManager;
@protocol ATTStatusesDataSource;
@protocol ATTImagesDataSource;


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
@property (nonatomic, assign, readonly, getter=isStarted) BOOL started;


/**
 * @brief Получить источник данных для поиска.
 */
- (id<ATTStatusesDataSource>)dataSourceForSearch;

/**
 * @brief Получить источник данных для картинок.
 */
- (id<ATTImagesDataSource>)dataSourceForImages;

@end
