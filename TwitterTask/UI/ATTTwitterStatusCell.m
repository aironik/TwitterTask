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
#import "ATTDataManager.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTTwitterStatusCell ()
@end


#pragma mark - Implementation

@implementation ATTTwitterStatusCell


- (void)prepareForReuse {
    [super prepareForReuse];
    self.twitTextLabel.text = nil;
    self.nameLabel.text = nil;
    self.avatarView.image = nil;
}

- (void)setStatus:(ATTStatusModel *)status {
    if (_status != status) {
        _status = status;
        self.twitTextLabel.text = _status.text;
        self.nameLabel.text = _status.user.name;
        self.avatarView.image = nil;
    }
}


@end
