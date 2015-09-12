//
//  LILArrayDataSource.h
//  LILKit
//
//  Created by August Hovland on 12/09/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import "LILDataSource.h"

@interface LILMutableArrayDataSource : LILDataSource

/**
 *  The NSFetchedResultsController to use as the data source for the UITableView
 */
@property (nonatomic, strong) NSMutableArray *mutableArray;

@end
