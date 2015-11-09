//
//  TOPHomeViewController.m
//  Topsies
//
//  Created by Felipe on 11/6/15.
//  Copyright © 2015 Felipe's Apps. All rights reserved.
//

#import "TOPHomeViewController.h"

#import "TOPDetailViewController.h"
#import "TOPItemsViewController.h"
#import "TOPItemStore.h"
#import "TOPDetailViewController.h"

@interface TOPHomeViewController ()

@end

@implementation TOPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showDetailView:(id)sender
{
    [self.view endEditing:YES];
        
        // Create a new TOPItem and add it to the store
        TOPItem *newItem = [[TOPItemStore sharedStore] createItem];
        
        TOPDetailViewController *detailViewController = [[TOPDetailViewController alloc] initForNewItem:YES];
        detailViewController.item = newItem;
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
        
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [self presentViewController:navController animated:YES completion:NULL];

}

- (IBAction)showItemsTableView:(id)sender
{
    [self.view endEditing:YES];
    
    TOPItemsViewController *itemsViewController = [[TOPItemsViewController alloc] init];
    
    [self.navigationController pushViewController:itemsViewController animated:YES];
}


@end
