//
//  EditBledTableViewController.h
//  EjfrFinalProyectiOS
//
//  Created by Eve Moon on 22/7/17.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Bleed+CoreDataClass.h"

@protocol EditBledTableViewControllerDelegate <NSObject>

-(void)doneEdition:(Bleed*) bleed;
-(void)cancelEdition;

@end

@interface EditBledTableViewController : UITableViewController <UIPickerViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, CLLocationManagerDelegate>

@property(nonatomic,strong) Bleed* bleed;

@property (nonatomic, weak) id<EditBledTableViewControllerDelegate> delegate;

@end
