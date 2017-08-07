//
//  NewBledTableViewController.h
//  EjfrFinalProyectiOS
//
//  Created by Eve Moon on 19/7/17.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Bleed+CoreDataClass.h"
#import "MapViewController.h"

@interface NewBledTableViewController : UITableViewController <UIPickerViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, MapViewControllerDelegate>

@property (nonatomic,strong) Bleed *bled;


@end
