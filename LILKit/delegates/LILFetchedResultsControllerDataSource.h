//
//  LILFetchedResultsControllerDataSource.h
//  LILKit
//
//  Created by August Hovland on 15/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LILDataSource.h"

/**
 *  NSFetchedResultsControllerDelegate/UITableViewDataSource
 */
@interface LILFetchedResultsControllerDataSource : LILDataSource
<NSFetchedResultsControllerDelegate>

/**
 *  The NSFetchedResultsController to use as the data source for the UITableView
 */
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
