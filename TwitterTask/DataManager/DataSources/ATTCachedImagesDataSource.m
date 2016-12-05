//
//  ATTCachedImagesDataSource.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 05/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTCachedImagesDataSource.h"

#import "ATTImagesDataSource.h"
#import "ATTImagesDataSourceObserver.h"
#import "ATTNetworkManager.h"
#import "ATTPersistenceStorage.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTCachedImagesDataSource ()

@property (nonatomic, strong, readonly) NSMapTable<NSString *, id<ATTImagesDataSourceObserver>> *observers;
@property (nonatomic, strong) ATTPersistenceStorage *storage;
@property (nonatomic, strong) ATTNetworkManager *networkManager;
@property (nonatomic, strong, readonly) NSCache *memoryCache;

@end


#pragma mark - Implementation

@implementation ATTCachedImagesDataSource


@synthesize observers = _observers;
@synthesize memoryCache = _memoryCache;


- (instancetype)initWithPersistenceStorage:(ATTPersistenceStorage *)storage  networkManager:(ATTNetworkManager *)networkManager {
    if (storage == nil || networkManager == nil) {
        self = nil;
    }
    else if (self = [super init]) {
        _storage = storage;
        _networkManager = networkManager;
        // TODO: т.к. слушить один и тот же URL могут несколько объектов, то нужно использовать
        // что-нибудь а-ля std::list<std::pair<__strong NSString, __weak id<ATTImagesDataSourceObserver> > >
        _observers = [NSMapTable<NSString *, id<ATTImagesDataSourceObserver>> mapTableWithKeyOptions:NSPointerFunctionsCopyIn
                                                                                        valueOptions:NSPointerFunctionsWeakMemory];

        _memoryCache = [[NSCache alloc] init];
        _memoryCache.totalCostLimit = 50;       // < в ОЗУ храним до 50 картинок. Каждая картинка стоимостью 1.
    }
    return self;
}

- (UIImage *)imageAtUrl:(NSString *)url {
    UIImage *result = [self.memoryCache objectForKey:url];
    if (result == nil) {
        result = [UIImage imageNamed:@"avatar_placeholder"];
        [self startLoadImageAtUrl:url];
    }
    return result;
}

- (void)startLoadImageAtUrl:(NSString *)url {
    WEAK_SELF
    [self.queue addOperationWithBlock:^{
        STRONG_SELF
        UIImage *image = [UIImage imageWithData:[self.storage dataForUrl:url]];
        if (image != nil) {
            [self notifyImageLoaded:image url:url];
        }
        else {
            [strongSelf.networkManager loadDataAtUrl:url completionHandler:^(NSData *data, NSError *error) {
                STRONG_SELF
                [strongSelf handleLoadData:data atUrl:url error:error];
            }];
        }
    }];
}

- (void)handleLoadData:(NSData *)data atUrl:(NSString *)url error:(NSError *)error {
    UIImage *image = nil;
    if ([data length] > 0) {
        [self didLoadImageData:data fromUrl:url];
    }

}

- (void)didLoadImageData:(NSData *)data fromUrl:(NSString *)url {
    UIImage *image = [UIImage imageWithData:data];
    if (image != nil) {
        [self.memoryCache setObject:image forKey:url cost:1];
        [self.storage addImageData:data forUrl:url];

        [self notifyImageLoaded:image url:url];
    }
}

- (void)notifyImageLoaded:(UIImage *)image url:(NSString *)url {
    WEAK_SELF
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        STRONG_SELF
        id<ATTImagesDataSourceObserver> observer = [self observerForUrl:url];
        [observer dataSource:self didLoadImage:image atUrl:url];
    }];
}

- (void)addObserver:(id<ATTImagesDataSourceObserver>)observer forImageAtUrl:(NSString *)url {
    // Слушатели weak в соответствии с флагами NSMapTable
    [self.observers setObject:observer forKey:url];
}

- (void)removeObserver:(id<ATTImagesDataSourceObserver>)observer forImageAtUrl:(NSString *)url {
    id<ATTImagesDataSourceObserver> obs = [self.observers objectForKey:url];
    if (obs == observer || obs == nil) {
        [self.observers removeObjectForKey:url];
    }
}

- (id<ATTImagesDataSourceObserver>)observerForUrl:(NSString *)url {
    id<ATTImagesDataSourceObserver> observer = [self.observers objectForKey:url];
    return observer;
}


@end
