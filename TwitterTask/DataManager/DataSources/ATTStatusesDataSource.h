//
//  ATTStatusesDataSource.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 04/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//


@class ATTStatusModel;
@protocol ATTStatusesDataSourceObserver;

/**
 * @brief Протокод источника данных твиттов. Позволяет получать текущую (кэшированную) ленту следить за изменениями.
 */
@protocol ATTStatusesDataSource <NSObject>


@required

/**
 * @brief Текущие статусы.
 */
@property (atomic, strong) NSArray<ATTStatusModel *> *statuses;

/**
 * @brief Слушатель изменений данных.
 */
@property(nonatomic, weak) id<ATTStatusesDataSourceObserver> observer;


@end
