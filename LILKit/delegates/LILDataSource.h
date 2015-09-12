//
//  LILDataSource.h
//  LILKit
//
//  Created by August Hovland on 11/09/15.
//  Copyright (c) 2015 August Hovland. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  LILDataSourceDelegate protocol
 */
@protocol LILDataSourceDelegate

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
 *  DatasSource delegate
 */
@interface LILDataSource : NSObject <UITableViewDataSource>

/**
 *  LILFetchedResultsControllerDataSourceDelegate
 */
@property (nonatomic, weak) id<LILDataSourceDelegate> delegate;

/**
 *  Default initializer
 *
 *  @param tableView UITableView that we are the data source of
 *
 *  @return LILFetchedResultsControllerDataSource instance
 */
- (id)initWithTableView:(UITableView*)tableView;

/**
 *  Object associated with currently selected cell in the UITableView
 *
 *  @return Object associated with selected cell or nil if nothing is selected
 */
- (id)selectedItem;

@end
