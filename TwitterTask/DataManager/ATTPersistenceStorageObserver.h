//
//  ATTPersistenceStorageObserver.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 02/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//


@class ATTPersistenceStorage;


/**
 * @brief Протокол, определяющий интерфейс слушателя изменений PersistenceStorage'а
 */
@protocol ATTPersistenceStorageObserver <NSObject>


@required

/**
 * @brief Метод, сообщающий слушателю о том, что начинается изменения данных.
 */
- (void)storageWillChangeSearchStatuses:(ATTPersistenceStorage *)storage;

/**
 * @brief Метод, сообщающий слушателю о добавлении элементов в поисковый результат.
 */
- (void)storage:(ATTPersistenceStorage *)storage didAddSearchStatusesAtIndexPaths:(NSMutableArray<NSIndexPath *> *)indexPaths;

/**
 * @brief Метод, сообщающий слушателю о том, что изменения данных закончились.
 */
- (void)storageDidChangeSearchStatuses:(ATTPersistenceStorage *)storage;


@end
