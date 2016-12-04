//
//  ATTTwitterListViewController.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 04/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTTwitterListViewController.h"

#import "ATTImagesDataSource.h"
#import "ATTStatusesDataSource.h"
#import "ATTStatusesDataSourceObserver.h"
#import "ATTTwitterStatusCell.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTTwitterListViewController ()<ATTStatusesDataSourceObserver>
@end


#pragma mark - Implementation

@implementation ATTTwitterListViewController


@synthesize dataSource = _dataSource;


#pragma mark - UITableView implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    ATTLogMethod(ATT_UI_SEARCH_LIST_LOG, @"%@", @1);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ATTLogMethod(ATT_UI_SEARCH_LIST_LOG, @"%@", @(self.dataSource.statuses.count));
    return self.dataSource.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATTLogMethod(ATT_UI_SEARCH_LIST_LOG, @"(%@, %@)", @(indexPath.section), @(indexPath.row));
    NSAssert(indexPath.section == 0, @"Unknown section. This table view is designed for single section only.");
    ATTTwitterStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ATTTwitterStatusCell"
                                                                      forIndexPath:indexPath];
    cell.imageSource = self.imageSource;
    cell.status = self.dataSource.statuses[indexPath.row];
    return cell;
}

#pragma mark - ATTStatusesDataSourceObserver implementation

- (void)dataSourceWillChangeStatuses:(id<ATTStatusesDataSource>)dataSource {
    ATTLogMethod(ATT_UI_SEARCH_LIST_LOG, @"");
    [self.tableView beginUpdates];
}

- (void)dataSource:(id<ATTStatusesDataSource>)dataSource didAddStatusesAtIndexPaths:(NSMutableArray<NSIndexPath *> *)indexPaths {
    ATTLogMethod(ATT_UI_SEARCH_LIST_LOG, @"");
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)dataSourceDidChangeStatuses:(id<ATTStatusesDataSource>)dataSource {
    ATTLogMethod(ATT_UI_SEARCH_LIST_LOG, @"");
    [self.tableView endUpdates];
}


#pragma mark -

- (void)setDataSource:(id<ATTStatusesDataSource>)dataSource {
    _dataSource = dataSource;
    _dataSource.observer = self;
    if ([self isViewLoaded]) {
        [self.tableView reloadData];
    }
}


@end
