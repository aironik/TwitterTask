//
//  ATTCachedImagesDataSource.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 05/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTCachedImagesDataSource.h"

#import "ATTImagesDataSource.h"
#import "ATTNetworkManager.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTCachedImagesDataSource ()

@property (nonatomic, strong, readonly) NSMapTable<NSString *, id<ATTImagesDataSourceObserver>> *observers;
@property (nonatomic, strong) ATTPersistenceStorage *storage;
@property (nonatomic, strong) ATTNetworkManager *networkManager;

@end


#pragma mark - Implementation

@implementation ATTCachedImagesDataSource


@synthesize observers = _observers;


- (instancetype)initWithPersistenceStorage:(ATTPersistenceStorage *)storage  networkManager:(ATTNetworkManager *)networkManager {
    if (storage == nil || networkManager == nil) {
        self = nil;
    }
    else if (self = [super init]) {
        _storage = storage;
        _networkManager = networkManager;
        _observers = [NSMapTable<NSString *, id <ATTImagesDataSourceObserver>> mapTableWithKeyOptions:NSPointerFunctionsCopyIn
                                                                                         valueOptions:NSPointerFunctionsWeakMemory];
    }
    return self;
}

- (UIImage *)imageAtUrl:(NSString *)url {
    return [UIImage imageNamed:@"avatar_placeholder"];
}

- (id <ATTImagesDataSourceObserver>)observer {
    return nil;
}

- (void)setObserver:(id <ATTImagesDataSourceObserver>)observer {

}

- (void)addObserver:(id <ATTImagesDataSourceObserver>)observer forImageAtUrl:(NSString *)url {

}

- (void)removeObserver:(id <ATTImagesDataSourceObserver>)observer forImageAtUrl:(NSString *)url {

}

@end
