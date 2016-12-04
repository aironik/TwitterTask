//
//  ATTImagesDataSource.h
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 04/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//


@protocol ATTImagesDataSourceObserver;

/**
 * @brief Кеш/хранилище картинок.
 */
@protocol ATTImagesDataSource <NSObject>


@required


/**
 * @brief Получить картинку по URI.
 * @details Если картинка есть в кеше, то возвращается она. Если нет,
 *      то возвращается заглушка и картинка ставится в очередь.
 */
- (UIImage *)imageAtUrl:(NSString *)url;

- (void)addObserver:(id<ATTImagesDataSourceObserver>)observer forImageAtUrl:(NSString *)url;
- (void)removeObserver:(id<ATTImagesDataSourceObserver>)observer forImageAtUrl:(NSString *)url;


@end
