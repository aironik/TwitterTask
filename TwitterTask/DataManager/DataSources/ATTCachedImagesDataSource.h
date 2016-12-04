//
//  ATTCachedImagesDataSource.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 05/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTImagesDataSource.h"


/**
 * @brief Источник данных для картинок с кешированием в памяти и на диске.
 */
@interface ATTCachedImagesDataSource : NSObject<ATTImagesDataSource>


/**
 * @brief Инициализировать хранилище картинок.
 * @param cachePath Путь в файловой системе для хранения картинок.
 */
- (instancetype)initWithCachePath:(NSString *)cachePath;

/**
 * @brief Очередь, на которой выполняются операции.
 */
@property (nonatomic, strong) NSOperationQueue *queue;

@end
