//
//  ATTSearchViewController.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 04/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//



@class ATTDataManager;

/**
 * @brief ViewController, отображающий список твитов поиска.
 */
@interface ATTSearchViewController : UIViewController

@property(nonatomic, strong) ATTDataManager *dataManager;

@end
