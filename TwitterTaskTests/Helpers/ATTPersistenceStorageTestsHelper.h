//
//  ATTPersistenceStorageTestsHelper.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 29/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//


@class ATTPersistenceStorage;


/**
 * @brief Класс-помщник для тестов ATTPersistenceStorage.
 */
@interface ATTPersistenceStorageTestsHelper : NSObject


/**
 * @brief Создать новое хранилище без дискового представления.
 */
+ (ATTPersistenceStorage *)createWithMemoryStorage;

/**
 * @brief Создать новое хранилище с файлом в tmp из предыдущего запуска.
 * @detail +createWithExistingsTemporaryStorage или +createWithNewTemporaryStorage.
 */
+ (ATTPersistenceStorage *)createWithExistingsTemporaryStorage;

/**
 * @brief Создать новое хранилище с новым файлом в tmp. Если файл существовал, он удаляется.
 */
+ (ATTPersistenceStorage *)createWithNewTemporaryStorage;


@end
