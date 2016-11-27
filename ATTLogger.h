//
//  ATTLogger.h
//  TwitterTask
//
//  Created by Oleg Lobachev on 27/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#ifndef ATTLogger_h
#define ATTLogger_h


#if (!defined(DEBUG) && defined(LOG_ENABLED))
    #error Debul log enabled for not debug build?
#endif // (!defined(DEBUG) && defined(LOG_ENABLED))


#pragma mark - Log Features/Tags Definitions

#define ATT_NETWORK_LOG 1


#pragma mark - Log Implementation

#if LOG_ENABLED

    #define ATTLog(tag, ...) if (tag) { NSLog(@"%@", [@#tag ": " stringByAppendingString:[NSString stringWithFormat:__VA_ARGS__]]); }

#else // LOG_ENABLED

    #define ATTLog(...)

#endif // LOG_ENABLED

#endif /* ATTLogger_h */
