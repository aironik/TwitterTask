//
//  ATTCachedImagesDataSource.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 05/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTCachedImagesDataSource.h"

#import "ATTImagesDataSource.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTCachedImagesDataSource ()

@property (nonatomic, copy) NSString *cachePath;
@property (nonatomic, strong, readonly) NSMapTable<NSString *, id<ATTImagesDataSourceObserver>> *observers;

@end


#pragma mark - Implementation

@implementation ATTCachedImagesDataSource


@synthesize cachePath = _cachePath;
@synthesize observers = _observers;


- (instancetype)initWithCachePath:(NSString *)cachePath {
    if (self = [super init]) {
        _observers = [NSMapTable<NSString *, id <ATTImagesDataSourceObserver>> mapTableWithKeyOptions:NSPointerFunctionsCopyIn
                                                                                         valueOptions:NSPointerFunctionsWeakMemory];
        _cachePath = [cachePath copy];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_cachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_cachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        }
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
