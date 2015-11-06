//
//  TOPFoodTypeViewController.m
//  Topsies
//
//  Created by Felipe on 11/6/15.
//  Copyright © 2015 Felipe's Apps. All rights reserved.
//

#import "TOPFoodTypeViewController.h"

#import "TOPItemStore.h"
#import "TOPItem.h"

@implementation TOPFoodTypeViewController

- (instancetype)init
{
    return [super initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tableView.backgroundColor = [UIColor colorWithRed:0.129f green:0.129f blue:0.129f alpha:1.00f];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[TOPItemStore sharedStore] allItemTypes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSArray *allItems = [[TOPItemStore sharedStore] allItemTypes];
    NSManagedObject *itemType = allItems[indexPath.row];
    
    // Use key-value coding to get the item type's label
    NSString *itemLabel = [itemType valueForKey:@"label"];
    cell.textLabel.text = itemLabel;
    
    // Checkmark the one that is currently selected
    if (itemType == self.item.foodItemType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSArray *allItems = [[TOPItemStore sharedStore] allItemTypes];
    NSManagedObject *itemType = allItems[indexPath.row];
    self.item.foodItemType = itemType;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:0.138f green:0.138f blue:0.138f alpha:1.00f];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    [cell.contentView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [cell.contentView.layer setBorderWidth:0.01f];
}



@end
