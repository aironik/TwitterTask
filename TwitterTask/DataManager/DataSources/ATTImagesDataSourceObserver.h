//
//  ATTImagesDataSourceObserver.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 04/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//


@protocol ATTImagesDataSourceObserver <NSObject>


@required

- (void)dataSource:(id<ATTImagesDataSource>)dataSource didLoadImage:(UIImage *)image atUrl:(NSString *)url;

@end
