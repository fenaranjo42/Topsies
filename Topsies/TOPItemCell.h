//
//  TOPItemCell.h
//  Topsies
//
//  Created by Felipe on 10/31/15.
//  Copyright © 2015 Felipe's Apps. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TOPItemCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *scoreImage;

@end
