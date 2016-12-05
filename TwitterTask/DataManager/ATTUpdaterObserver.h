//
//  ATTUpdaterObserver.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 05/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//


/**
 * @brief Протокол для слежения за состоянием обновления.
 */
@protocol ATTUpdaterObserver<NSObject>
@required
- (void)updater:(ATTUpdater *)updater didUpdateTimer:(NSTimeInterval)timer;

- (void)updaterStartNetworkRequest:(ATTUpdater *)updater;

- (void)updaterFinishNetworkRequest:(ATTUpdater *)updater;
@end
