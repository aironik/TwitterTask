//
//  ATTStatusesDataSourceObserver.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 04/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//


@protocol ATTStatusesDataSource;


/**
 * @brief Протокол для слушателей изменений источника данных.
 */
@protocol ATTStatusesDataSourceObserver <NSObject>


@required

/**
 * @brief Метод, сообщающий слушателю о том, что начинается изменения данных.
 */
- (void)dataSourceWillChangeStatuses:(id<ATTStatusesDataSource>)dataSource;

/**
 * @brief Метод, сообщающий слушателю о добавлении элементов в результат.
 */
- (void)dataSource:(id<ATTStatusesDataSource>)dataSource didAddStatusesAtIndexPaths:(NSMutableArray<NSIndexPath *> *)indexPaths;

/**
 * @brief Метод, сообщающий слушателю о том, что изменения данных закончились.
 */
- (void)dataSourceDidChangeStatuses:(id<ATTStatusesDataSource>)dataSource;


@end
