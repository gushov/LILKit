//
//  LILArrayDataSource.m
//  LILKit
//
//  Created by August Hovland on 12/09/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import "LILMutableArrayDataSource.h"

@interface LILDataSource ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LILMutableArrayDataSource

- (void)setMutableArray:(NSMutableArray *)mutableArray
{
    _mutableArray = mutableArray;
    [self.tableView reloadData];
}

- (id)selectedItem
{
    NSIndexPath* path = self.tableView.indexPathForSelectedRow;
    return path ? self.mutableArray[path.row] : nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mutableArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    id object = self.mutableArray[indexPath.row];
    return [self.delegate cellWithObject:object];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.delegate deleteObject:self.mutableArray[indexPath.row]];
    }
}

@end
