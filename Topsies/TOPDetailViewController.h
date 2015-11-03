//
//  TOPDetailViewController.h
//  Topsies
//
//  Created by Felipe on 10/30/15.
//  Copyright © 2015 Felipe's Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TOPItem;

@interface TOPDetailViewController : UIViewController

@property (nonatomic, strong) TOPItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (instancetype)initForNewItem:(BOOL)isNew;


@end
