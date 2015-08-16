//
//  LILFetchedResultsControllerDataSource.h
//  LILKit
//
//  Created by August Hovland on 15/08/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

/**
 *  LILFetchedResultsControllerDataSourceDelegate protocol
 */
@protocol LILFetchedResultsControllerDataSourceDelegate

/**
 *  Configure cell for given object
 *
 *  @param object Object to configure the cell with
 *
 *  @return UITableViewCell configured with object data
 */
- (UITableViewCell *)cellWithObject:(id)object;

/**
 *  Delete the given object
 *
 *  @param object Object to delete
 */
- (void)deleteObject:(id)object;

@end

/**
 *  NSFetchedResultsControllerDelegate/UITableViewDataSource
 */
@interface LILFetchedResultsControllerDataSource : NSObject
<UITableViewDataSource, NSFetchedResultsControllerDelegate>

/**
 *  The NSFetchedResultsController to use as the data source for the UITableView
 */
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

/**
 *  LILFetchedResultsControllerDataSourceDelegate
 */
@property (nonatomic, weak) id<LILFetchedResultsControllerDataSourceDelegate> delegate;

/**
 *  Pause updates
 */
@property (nonatomic) BOOL paused;

/**
 *  Default initializer
 *
 *  @param tableView UITableView that we are the data source of
 *
 *  @return LILFetchedResultsControllerDataSource instance
 */
- (id) initWithTableView:(UITableView*)tableView;

/**
 *  Object associated with currently selected cell in the UITableView
 *
 *  @return Object associated with selected cell or nil if nothing is selected
 */
- (id) selectedItem;

@end
