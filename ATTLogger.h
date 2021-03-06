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

#define ATT_NETWORK_LOG 0
#define ATT_STORAGE_LOG 0
#define ATT_UI_SEARCH_LIST_LOG 0
#define ATT_UPDATER_LOG 1



#if (ATT_STORAGE_LOG && LOG_ENABLED)
    #define ATT_TRACE_SQLITE 1
#else //  (ATT_STORAGE_LOG && LOG_ENABLED)
    #define ATT_TRACE_SQLITE 0
#endif // (ATT_STORAGE_LOG && LOG_ENABLED)

#pragma mark - Log Implementation

#if LOG_ENABLED

    #define ATTLog(tag, ...) if (tag) { NSLog(@"%@", [@#tag ": " stringByAppendingString:[NSString stringWithFormat:__VA_ARGS__]]); }

    #define ATTLogMethod(tag, ...) if (tag) { NSLog(@"%@", [NSString stringWithFormat:@#tag ": %@ %@", NSStringFromSelector(_cmd), [NSString stringWithFormat:__VA_ARGS__]]); }

#else // LOG_ENABLED

    #define ATTLog(...)

#endif // LOG_ENABLED

#endif /* ATTLogger_h */
