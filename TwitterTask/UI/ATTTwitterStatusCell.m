//
//  ATTTwitterStatusCell.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 04/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTTwitterStatusCell.h"

#import "ATTStatusModel.h"
#import "ATTUserModel.h"
#import "ATTImagesDataSource.h"
#import "ATTImagesDataSourceObserver.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTTwitterStatusCell ()<ATTImagesDataSourceObserver>
@end


#pragma mark - Implementation

@implementation ATTTwitterStatusCell


#pragma mark - ATTImagesDataSourceObserver

- (void)dataSource:(id <ATTImagesDataSource>)dataSource didLoadImage:(UIImage *)image atUrl:(NSString *)url {
    NSAssert([NSThread isMainThread], @"Update have to execute on main thread.");
    if ([url isEqualToString:self.status.user.profileImageUrlHttps]) {
        self.avatarView.image = [self.imageSource imageAtUrl:url];
    }
}


#pragma mark -

- (void)prepareForReuse {
    if (self.status != nil) {
        [self.imageSource removeObserver:self forImageAtUrl:self.status.user.profileImageUrlHttps];
        self.twitTextLabel.text = nil;
        self.nameLabel.text = nil;
        self.avatarView.image = nil;
    }
    [super prepareForReuse];
}

- (void)setStatus:(ATTStatusModel *)status {
    if (_status != status) {
        if (_status != nil) {
            [self.imageSource removeObserver:self forImageAtUrl:_status.user.profileImageUrlHttps];
        }
        _status = status;
        self.twitTextLabel.text = _status.text;
        self.nameLabel.text = _status.user.name;
        NSString *url = self.status.user.profileImageUrlHttps;
        [self.imageSource addObserver:self forImageAtUrl:url];
        self.avatarView.image = [self.imageSource imageAtUrl:url];
    }
}


@end
