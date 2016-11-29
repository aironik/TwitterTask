//
//  ATTPersistenceStorage.h
//  TwitterTask
//
//  Created by Oleg Lobachev on 28/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

@interface ATTPersistenceStorage : NSObject

/**
 * @brief Инициализировать постоянное хранилище.
 * @param storagePath Полное имя файла, в котором сохраняются данные.
 */
- (instancetype)initWithStoragePath:(NSString *)storagePath;

/**
 * @brief Подготовить все данные и запустить хранилище.
 */
- (void)start;

/**
 * @brief Остановить хранилище и очистить все используемые ресурсы.
 */
- (void)stop;

/**
 * @brief Флаг готовности к работе.
 */
@property (nonatomic, assign, readonly, getter=isStarted) BOOL started;


@end
