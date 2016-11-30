//
//  ATTPersistenceStorageTestsHelper.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 29/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTPersistenceStorageTestsHelper.h"

#import <XCTest/XCTest.h>

#import "ATTPersistenceStorage.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTPersistenceStorageTestsHelper ()
@end


#pragma mark - Implementation

@implementation ATTPersistenceStorageTestsHelper

+ (NSString *)temporraryStoragePath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"test_storage/data/storage.db"];
}

+ (ATTPersistenceStorage *)createWithMemoryStorage {
    ATTPersistenceStorage *storage = [[ATTPersistenceStorage alloc] initWithStoragePath:nil];
    [storage start];
    return storage;
}

+ (ATTPersistenceStorage *)createWithExistingsTemporaryStorage {
    NSString *path = [self temporraryStoragePath];
    ATTPersistenceStorage *storage = [[ATTPersistenceStorage alloc] initWithStoragePath:path];
    [storage start];
    return storage;
}

+ (ATTPersistenceStorage *)createWithNewTemporaryStorage {
    NSString *path = [self temporraryStoragePath];
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path] && (![fileManager removeItemAtPath:path error:&error] || error != nil)) {
        XCTFail(@"Cannot remove file.");
    }
    ATTPersistenceStorage *storage = [[ATTPersistenceStorage alloc] initWithStoragePath:path];
    [storage start];
    return storage;
}


@end
