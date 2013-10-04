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
#import "Extension.h"

@interface TCJsonObjectTableViewController()<TCSegmentingManagerDataSource>

@property (nonatomic, strong) TCHorizontalTableView *headerView;
@property (nonatomic, strong) TCHorizontalViewListAdapter *headerViewAdapter;
@property (nonatomic, strong) NSArray *segmentedButtons;

@end

@implementation TCJsonObjectTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.segmentingManager = [[TCSegmentingManager alloc] init];
        [self.segmentingManager setDatasource:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setTableHeaderView:self.headerView];
    [self.segmentingManager setup];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.textLabel setText:@"halo"];
    }
    
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

- (TCHorizontalTableView *)headerView
{
    if (!_headerView) {
        _headerView = [[TCHorizontalTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        [_headerView setBackgroundColor:[UIColor greenColor]];
        [_headerView setScrollEnabled:YES];
        [self.headerViewAdapter handleTableView:_headerView];
    }
    return _headerView;
}

- (TCHorizontalViewListAdapter *)headerViewAdapter
{
    if (!_headerViewAdapter) {
        _headerViewAdapter = [[TCHorizontalViewListAdapter alloc] init];
        [_headerViewAdapter setItems:self.segmentedButtons];
        [_headerViewAdapter setNumberOfCellDisplay:3.5];
    }
    return _headerViewAdapter;
}

- (NSArray *)segmentedButtons
{
    if (!_segmentedButtons) {
        NSMutableArray *buttons = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < 5 ; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            [button setBackgroundColor:[UIColor redColor] forState:UIControlStateSelected];
            [button setBackgroundColor:[UIColor blueColor] forState:UIControlStateNormal];
            [button setTitle:@(i).stringValue forState:UIControlStateNormal];
            [buttons addObject:button];
        }
        _segmentedButtons = buttons;
    }
    return _segmentedButtons;
}

#pragma mark - segmenting manager delegate 
- (NSUInteger)segmentingManagerShouldHaveNumberOfSegments:(TCSegmentingManager *)segmentingManager
{
    return self.segmentedButtons.count;
}

- (UIButton *)segmentingManager:(TCSegmentingManager *)segmentingManager buttonAtIndex:(NSUInteger)index
{

    return self.segmentedButtons[index];
}

@end
