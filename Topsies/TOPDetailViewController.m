//
//  TOPDetailViewController.m
//  Topsies
//
//  Created by Felipe on 10/30/15.
//  Copyright © 2015 Felipe's Apps. All rights reserved.
//

#import "TOPDetailViewController.h"
#import "TOPItem.h"
#import "TOPImageStore.h"
#import "TOPItemStore.h"
#import "TOPScoreView.h"
#import "TOPFoodTypeViewController.h"

@interface TOPDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, TOPScoreViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *restaurantField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet TOPScoreView *scoreView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *itemTypeButton;

@end

@implementation TOPDetailViewController

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Creating image View programatically to practice adding constraints programtically
    UIImageView *iv = [[UIImageView alloc] initWithImage:NULL];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    // Do not produce a translated constraint for this view
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:iv];
    
    self.imageView = iv;
    
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
    
    NSDictionary *nameMap = @{@"imageView" : self.imageView,
                              @"dateLabel" : self.dateLabel,
                              @"toolbar" : self.toolbar};
    
    // imageView is 0 pts from superviewat left and right edges
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:nameMap];
    
    // imageview is 8 pts from dateLabel at its top edge... 8 pts from toolbar at bottom
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:nameMap];
    
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
    
    
    // Updating the Score View
    self.scoreView.notSelectedImage = [UIImage imageNamed:@"StarEmpty.png"];
    self.scoreView.halfSelectedImage = [UIImage imageNamed:@"StarFull.png"];
    self.scoreView.fullSelectedImage = [UIImage imageNamed:@"StarFull.png"];
    self.scoreView.rating = self.item.score;
    self.scoreView.editable = YES;
    self.scoreView.maxRating = 5;
    self.scoreView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    TOPItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.restaurantField.text = item.restaurantName;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    // Give the item a date
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    // Use filtered NSDate object to set dateLabel contents
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    NSString *itemKey = self.item.itemKey;
    
    // Get the image for its image key from the image store
    UIImage *imageToDisplay = [[TOPImageStore sharedStore] imageForKey:itemKey];
    
    // Use that image to put on the screen in the imageView
    self.imageView.image = imageToDisplay;
    
    NSString *typeLabel = [self.item.foodItemType valueForKey:@"label"];
    if (!typeLabel) {
        typeLabel = @"None";
    }
    
    self.navigationController.toolbar.barTintColor = [UIColor colorWithRed:0.119f green:0.161f blue:0.225f alpha:1.00f];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.119f green:0.161f blue:0.225f alpha:1.00f];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.851f green:0.369f blue:0.247f alpha:1.00f];
    self.navigationController.toolbar.tintColor = [UIColor colorWithRed:0.851f green:0.369f blue:0.247f alpha:1.00f];
    
    self.itemTypeButton.title = [NSString stringWithFormat:@"Type: %@", typeLabel];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    // "Save" changes to item
    TOPItem *item = self.item;
    item.itemName = self.nameField.text;
    item.restaurantName = self.restaurantField.text;
    item.valueInDollars = [self.valueField.text intValue];
    item.score = self.scoreView.rating;
    
    NSLog(@"%d", item.score);
}

#pragma mark - Initializers

- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                      target:self
                                                                                      action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
    }
    return self;
}

// Overriding designated initializer so no one can call it
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [NSException raise:@"Wrong initializer" format:@"Use initForNewItem"];
    return nil;
}

#pragma mark - Actions

- (void)setItem:(TOPItem *)item
{
    _item = item;
    self.navigationItem.title = item.itemName;
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    // If the user cancelled, then remove the TOPItem from the store
    [[TOPItemStore sharedStore] removeItem:self.item];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}


#pragma mark - Image Picker Controller Delegate

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If the device has a camera, take a picture, otherwise, just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    // Place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // Get picked image from info dictionary
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // Creates thumbnail when camera takes original image
    [self.item setThumbnail:image];
    
    // Put that image onto the screen in our image view
    self.imageView.image = image;
    
    // Take image picker off the screen
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    // Store the image in the TOPImageStore for this key
    [[TOPImageStore sharedStore] setImage:image forKey:self.item.itemKey];
}


#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Score View Delegate

- (void)scoreView:(TOPScoreView *)scoreView ratingDidChange:(float)rating
{
    self.item.score = rating;
}

#pragma mark - Item Type Picker 

- (IBAction)showItemTypePicker:(id)sender
{
    [self.view endEditing:YES];
    
    TOPFoodTypeViewController *fvc = [[TOPFoodTypeViewController alloc] init];
    fvc.item = self.item;
    
    [self.navigationController pushViewController:fvc animated:YES];
}


@end
