//
//  AppDelegate.h
//  TwitterTask
//
//  Created by Oleg Lobachev on 22/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ATTDataManager;


@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) ATTDataManager *dataManager;


@end

