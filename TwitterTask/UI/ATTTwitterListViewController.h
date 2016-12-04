//
//  ATTTwitterListViewController.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 04/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//


@class ATTPersistenceStorage;


/**
 * @brief View Controller, отображающий список твиттов.
 */
@interface ATTTwitterListViewController : UITableViewController


/**
 * @brief DataSource твиттов.
 */
@property (nonatomic, strong) ATTPersistenceStorage *dataSource;

@end
