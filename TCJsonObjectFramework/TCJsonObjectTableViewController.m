//
//  TCJsonObjectTableViewController.m
//  bokku
//
//  Created by Ted Cheng on 3/10/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCJsonObjectTableViewController.h"
#import "TCHorizontalTableView.h"
#import "TCHorizontalViewListAdapter.h"
#import "TCJsonObject.h"
#import "TCJsonObjectTableViewCell.h"
#import "Extension.h"

@interface TCJsonObjectTableViewController()<TCSegmentedControlButtonManagerDelegate>

@property (nonatomic, strong) TCHorizontalTableView *headerView;
@property (nonatomic, strong) TCHorizontalViewListAdapter *headerViewAdapter;
@property (nonatomic, strong) NSArray *segmentedButtons;

@end

@implementation TCJsonObjectTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.segmentingManager = [[TCSegmentingManager alloc] initWithButtons:self.segmentedButtons];
        [self.segmentingManager.controlButtonManager setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self segmentedControlButtonsShouldShow]) [self.tableView setTableHeaderView:self.headerView];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.segmentingManager.currentItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TCJsonObject *object = self.segmentingManager.currentItems[indexPath.row];
    NSString *cellClassString = [self cellClassStringForJsonObjectClassString:NSStringFromClass([object class])];
    Class cellClass = NSClassFromString(cellClassString);
    
    NSString *CellIdentifier = cellClassString;
    TCJsonObjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setToDefaultView];
    [cell updateWithJsonObject:object];
    if (self.tableView.dragging == NO && self.tableView.decelerating == NO) [ImageCache loadImageForView:cell localOnly:YES];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - standard flow
- (TCHorizontalTableView *)headerView
{
    if (!_headerView) {
        _headerView = [[TCHorizontalTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50 )];
        [_headerView setScrollEnabled:YES];
        [self.headerViewAdapter handleTableView:_headerView];
    }
    return _headerView;
}

- (TCHorizontalViewListAdapter *)headerViewAdapter
{
    if (!_headerViewAdapter) {
        _headerViewAdapter = [[TCHorizontalViewListAdapter alloc] init];
        [_headerViewAdapter setNumberOfCellDisplay:[self numberOfButtonDisplay]];
        [_headerViewAdapter setItems:self.segmentedButtons];
    }
    return _headerViewAdapter;
}

- (NSArray *)segmentedButtons
{
    if (!_segmentedButtons) {
        _segmentedButtons = [self segmentedControlButtons];
    }
    return _segmentedButtons;
}

#pragma mark - lazy Loading 

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateImageDownLoadRequest];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self updateImageDownLoadRequest];
    }
}

- (void)updateImageDownLoadRequest
{
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    NSMutableArray *mutablePaths = [NSMutableArray arrayWithArray:visiblePaths];
    
    for (NSIndexPath *indexPath in mutablePaths)
    {
        TCJsonObjectTableViewCell *cell = (TCJsonObjectTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [ImageCache loadImageForView:cell localOnly:NO];
    }
}


#pragma mark - To Be Override

- (BOOL)segmentedControlButtonsShouldShow
{
    return YES;
}

- (CGFloat)numberOfButtonDisplay
{
    return 1;
}

- (NSArray *)segmentedControlButtons
{
    return nil;
}

- (NSString *)cellClassStringForJsonObjectClassString:(NSString *)classString
{
    return @"TCJsonObjectTableViewCell";
}

#pragma mark - segmented control Button Delegate
- (void)segmentedControlButtonManager:(TCSegmentedControlButtonManager *)manager DidChangeCurrentIndexToButton:(UIButton *)button
{
    [self.tableView reloadData];
}

@end
