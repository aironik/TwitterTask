//
//  ATTTwitterListViewController.m
//  TwitterTask
//
//  Created by Oleg Lobachev aironik@gmail.com on 04/12/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "ATTTwitterListViewController.h"

#import "ATTPersistenceStorage.h"
#import "ATTPersistenceStorageObserver.h"
#import "ATTTwitterStatusCell.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface ATTTwitterListViewController ()<ATTPersistenceStorageObserver>
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
    ATTLogMethod(ATT_UI_SEARCH_LIST_LOG, @"%@", @(self.dataSource.searchStatuses.count));
    return self.dataSource.searchStatuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATTLogMethod(ATT_UI_SEARCH_LIST_LOG, @"(%@, %@)", @(indexPath.section), @(indexPath.row));
    ATTTwitterStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ATTTwitterStatusCell"
                                                                      forIndexPath:indexPath];
    cell.nameLabel.text = [@(indexPath.row) description];
    return cell;
}

#pragma mark - ATTPersistenceStorageObserver implementation

- (void)storageWillChangeSearchStatuses:(ATTPersistenceStorage *)storage {
    ATTLogMethod(ATT_UI_SEARCH_LIST_LOG, @"");
    [self.tableView beginUpdates];
}

- (void)storage:(ATTPersistenceStorage *)storage didAddSearchStatusesAtIndexPaths:(NSMutableArray<NSIndexPath *> *)indexPaths {
    ATTLogMethod(ATT_UI_SEARCH_LIST_LOG, @"");
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)storageDidChangeSearchStatuses:(ATTPersistenceStorage *)storage {
    ATTLogMethod(ATT_UI_SEARCH_LIST_LOG, @"");
    [self.tableView endUpdates];
}


#pragma mark -

- (void)setDataSource:(ATTPersistenceStorage *)dataSource {
    _dataSource = dataSource;
    _dataSource.observer = self;
    if ([self isViewLoaded]) {
        [self.tableView reloadData];
    }
}


@end
