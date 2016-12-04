//
//  ATTDefinitions.h
//  TwitterTask
//
//  Created by Oleg Lobachev on 27/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#ifndef ATTDefinitions_h
#define ATTDefinitions_h


#define WEAK_SELF __weak typeof(self) weakSelf = self;
#define STRONG_SELF __strong typeof(weakSelf) strongSelf = weakSelf;

static inline dispatch_queue_t att_dispatch_get_current_queue() {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return dispatch_get_current_queue();
#pragma clang diagnostic pop
}

#define ATT_WAIT(waitTimeInterval) \
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:waitTimeInterval]];

#define ATT_TRY_WAIT(boolBlock, waitTimeInterval) \
    { \
        NSTimeInterval interval = 0.; \
        do { \
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:.1]]; \
            interval += .1; \
        } while (!boolBlock() && interval < waitTimeInterval); \
    }

#endif /* ATTDefinitions_h */
