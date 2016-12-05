//
//  ATTUpdater.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 05/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//


@class ATTNetworkManager;
@class ATTPersistenceStorage;
@protocol ATTUpdaterObserver;


/**
 * @brief Объект, занимающийся обновлением поиска.
 */
@interface ATTUpdater : NSObject

/**
 * @brief Инициализировать новый updater для обновления данных в storage через сеть networkManager
 */
- (instancetype)initWithPersistenceStorage:(ATTPersistenceStorage *)storage  networkManager:(ATTNetworkManager *)networkManager;

/**
 * @brief Очередь, на которой выполняются операции.
 */
@property (nonatomic, strong) NSOperationQueue *queue;

/**
 * @brief Период обновления в секундах.
 * @details Значение по умолчанию 60 секунд.
 */
@property (nonatomic, assign) NSTimeInterval updateTimeInterval;

/**
 * @brief Время до следующего запуска обновления.
 */
@property (nonatomic, assign, readonly) NSTimeInterval countdownTimeInterval;

- (void)start;
- (void)stop;
@property (nonatomic, assign, readonly, getter=isStarted) BOOL started;

- (void)scheduleNextStep;

@property (nonatomic, weak) id<ATTUpdaterObserver> observer;

@end
