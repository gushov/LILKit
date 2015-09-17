//
//  LILDataSource.m
//  LILKit
//
//  Created by August Hovland on 11/09/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import "LILDataSource.h"

@interface LILDataSource ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL sectionsUpdated;
@end

@implementation LILDataSource

- (instancetype)initWithTableView:(UITableView*)tableView
{
    self = [super init];
    if (!self) return nil;
    
    _tableView = tableView;
    _tableView.dataSource = self;
    
    return self;
}

- (id)selectedItem
{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}

@end
