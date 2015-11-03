//
//  TOPScoreView.h
//  Topsies
//
//  Created by Felipe on 10/31/15.
//  Copyright © 2015 Felipe's Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TOPScoreView;

@protocol TOPScoreViewDelegate

// Set delegate so we can notify our VC when the rating changes
- (void)scoreView:(TOPScoreView *)scoreView ratingDidChange:(float)rating;

@end

@interface TOPScoreView : UIView

@property (nonatomic, strong) UIImage *notSelectedImage;
@property (nonatomic, strong) UIImage *halfSelectedImage;
@property (nonatomic, strong) UIImage *fullSelectedImage;
@property (assign, nonatomic) float rating;
@property (assign) BOOL editable;
@property (strong) NSMutableArray *imageViews;
@property (assign, nonatomic) int maxRating;
@property (assign) int midMargin;
@property (assign) int leftMargin;
@property (assign) CGSize minImageSize;
@property (assign) id <TOPScoreViewDelegate> delegate;

@end
