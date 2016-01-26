//
//  Copyright (c) 2015 Fish Hook LLC. All rights reserved.
//

#import "SearchAndResultsTableViewController.h"
#import "DetailViewController.h"

//----------------------------------------------------------------------------//

@interface SearchAndResultsTableViewController () <UISearchBarDelegate, UISearchResultsUpdating,UISearchControllerDelegate>

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) UIImageView *maskView;
@property (strong, nonatomic) UITableView *tableView;
@end

//----------------------------------------------------------------------------//

static NSString * const CellIdentifier = @"Search Cell";
static NSString * const DetailSegue = @"Detail Segue";

//----------------------------------------------------------------------------//

@implementation SearchAndResultsTableViewController

- (BOOL)definesPresentationContext
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resetTableView];
    [self resetMaskView];
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController = searchController;
    
    
    
    UISearchBar *searchBar = searchController.searchBar;
    searchBar.showsBookmarkButton = YES;
    [searchBar setImage:[UIImage imageNamed:@"VoiceSearchIcon"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    [searchBar sizeToFit];
    searchBar.delegate = self;
    
    self.tableView.tableHeaderView = searchBar;
}


- (void)resetTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)resetMaskView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"IMG_2136"];
    [self.view insertSubview:imageView belowSubview:self.tableView];
    self.maskView = imageView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:DetailSegue]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSString *dataItem;
        if (self.searchController.isActive) {
            dataItem = self.results[indexPath.row];
        }
        else {
            dataItem = self.data[indexPath.row];
        }
        
        [segue.destinationViewController setDataItem:dataItem];
    }
}

#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.isActive) {
        return self.results.count;
    }
    else {
        return self.data.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *data;
    if (self.searchController.isActive) {
        data = self.results[indexPath.row];
    }
    else {
        data = self.data[indexPath.row];
    }
    
    cell.textLabel.text = data;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *layTopRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了置顶");
        [tableView setEditing:NO animated:YES];
    }];
    layTopRowAction.backgroundColor = [UIColor redColor];
    
    
    UITableViewRowAction *markRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"标记" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了置顶");
        [tableView setEditing:NO animated:YES];
    }];
    markRowAction.backgroundColor = [UIColor greenColor];
    
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"更多" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了置顶");
        [tableView setEditing:NO animated:YES];
    }];
    moreRowAction.backgroundColor = [UIColor darkGrayColor];
    
    return @[layTopRowAction,markRowAction,moreRowAction];
    
}

#pragma mark - Search Results Updating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchController.searchBar.text];
    self.results = [self.data filteredArrayUsingPredicate:searchPredicate];
    
    [self.tableView reloadData];
}


- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"bookMark");
}


@end
