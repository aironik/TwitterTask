//
//  ATTUpdateCoundownViewController.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 05/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//


@class ATTUpdater;


/**
 * @brief View Controller, отображающий время до обновления.
 */
@interface ATTUpdateCoundownViewController: UIViewController


@property (nonatomic, strong) ATTUpdater *updater;


@end
