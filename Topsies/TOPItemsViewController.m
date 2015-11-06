//
//  ItemsViewController.m
//  Topsies
//
//  Created by Felipe on 10/28/15.
//  Copyright © 2015 Felipe's Apps. All rights reserved.
//

#import "TOPItemsViewController.h"

#import "TOPItemStore.h"
#import "TOPItem.h"
#import "TOPDetailViewController.h"
#import "TOPItemCell.h"
#import "TOPScoreView.h"

@interface TOPItemsViewController ()


@end

@implementation TOPItemsViewController

#pragma mark - Controller Life Cycle

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Topsies";
        
        // Bar button item that will send addNewItem: to items view controller. Place it on the right
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                     target:self
                                                     action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = bbi;
        
        // "Edit" Bar button item
        navItem.leftBarButtonItem = self.editButtonItem;
        
    }
    
    return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"TOPItemCell" bundle:nil];
    
    // Register this NIB, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TOPItemCell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.129f green:0.129f blue:0.129f alpha:1.00f];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)addNewItem:(id)sender
{
    
    // Create a new TOPItem and add it to the store
    TOPItem *newItem = [[TOPItemStore sharedStore] createItem];
    
    TOPDetailViewController *detailViewController = [[TOPDetailViewController alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:NULL];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[TOPItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a new or recycled cell
    TOPItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TOPItemCell" forIndexPath:indexPath];
    
    NSArray *items = [[TOPItemStore sharedStore] allItems];
    TOPItem *item = items[indexPath.row];
    
    // Configure the cell with the TOPItem
    cell.nameLabel.text = item.itemName;
    cell.restaurantLabel.text = item.restaurantName;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    cell.thumbnailView.image = item.thumbnail;
    cell.scoreImage.image = [item scoreImageForKey:[NSString stringWithFormat:@"%d", item.score]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[TOPItemStore sharedStore] allItems];
        TOPItem *item = items[indexPath.row];
        
        [[TOPItemStore sharedStore] removeItem:item];
        
        // Also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableview moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    [[TOPItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TOPDetailViewController *detailViewController = [[TOPDetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[TOPItemStore sharedStore] allItems];
    TOPItem *selectedItem = items[indexPath.row];
    
    // Give detail view controller a pointer to the item object in row
    detailViewController.item = selectedItem;
    
    // Push new instance of TOPDetailViewcontroller onto the top of the nav controller's stack
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Need to figure out another method instead of hard coding it
    return 160.0;
}

@end
