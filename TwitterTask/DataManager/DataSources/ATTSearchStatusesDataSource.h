//
//  ATTSearchStatusesDataSource.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 04/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//


#import "ATTStatusesDataSource.h"


@class ATTPersistenceStorage;
@class ATTStatusModel;
@protocol ATTStatusesDataSourceObserver;


/**
 * @brief Источник данных результатов поиска
 */
@interface ATTSearchStatusesDataSource : NSObject<ATTStatusesDataSource>


/**
 * @brief Создать источник данных.
 */
- (instancetype)initWithPersistenceStorage:(ATTPersistenceStorage *)storage;

/* ATTStatusesDataSource implementation */
@property (atomic, strong) NSArray<ATTStatusModel *> *statuses;
@property (nonatomic, weak) id<ATTStatusesDataSourceObserver> observer;

@end
