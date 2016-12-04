//
//  ATTCachedImagesDataSource.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 05/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTImagesDataSource.h"


@class ATTPersistenceStorage;
@class ATTNetworkManager;


/**
 * @brief Источник данных для картинок с кешированием в памяти и на диске.
 */
@interface ATTCachedImagesDataSource : NSObject<ATTImagesDataSource>


/**
 * @brief Инициализировать источник данных картинок.
 */
- (instancetype)initWithPersistenceStorage:(ATTPersistenceStorage *)storage  networkManager:(ATTNetworkManager *)networkManager;

/**
 * @brief Очередь, на которой выполняются операции.
 */
@property (nonatomic, strong) NSOperationQueue *queue;

@end
