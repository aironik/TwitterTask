//
//  ATTPersistenceStorage.h
//  TwitterTask
//
//  Created by Oleg Lobachev on 28/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

@class ATTStatusModel;

@protocol ATTPersistenceStorageObserver;


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

/**
 * @brief Очередь, на которой выполняются операции.
 */
@property (nonatomic, strong) NSOperationQueue *queue;

/**
 * @brief Слушатель изменений хранилишь
 * @details Интерфейс подогнан для более удобной работы с UITableView
 */
@property (nonatomic, weak) id<ATTPersistenceStorageObserver> observer;

/**
 * @brief Загрузить ранее сохранённый поисковый результат их хранилища.
 * @details Загружает данных с диска и возвращает результат. Внутреннее состояние не изменяется.
 * @return Загруженных из БД массив статусов.
 */
- (NSArray<ATTStatusModel *> *)loadSearchStatuses;

/**
 * @brief Добавить поисковый результат в хранилище.
 * @param statuses Массив NSDictionary, десереализованный из JSON.
 */
- (void)addSearchStatusesJson:(NSArray<NSDictionary *> *)statuses;



@end
