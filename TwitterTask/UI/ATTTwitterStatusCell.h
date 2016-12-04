//
//  ATTTwitterStatusCell.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 04/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//


@class ATTStatusModel;
@class ATTDataManager;
@protocol ATTImagesDataSource;


/**
 * @brief Ячейка таблицы, отображающая один твит.
 */
@interface ATTTwitterStatusCell : UITableViewCell


@property (nonatomic, strong) ATTStatusModel *status;
@property (nonatomic, strong) id<ATTImagesDataSource> imageSource;


@property (nonatomic, weak) IBOutlet UIImageView *avatarView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *twitTextLabel;


@end
