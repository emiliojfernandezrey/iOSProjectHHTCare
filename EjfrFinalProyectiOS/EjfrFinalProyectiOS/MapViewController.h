//
//  ViewController.h
//  EjfrFinalProyectiOS
//
//  Created by Eve Moon on 18/7/17.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapViewController.h"

@protocol MapViewControllerDelegate <NSObject>

-(void)doneEdition:(CLLocation*) selectedLocation;

@end

@interface MapViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>
@property (strong,nonatomic) CLLocation *selectedLocation;
@property (nonatomic, weak) id<MapViewControllerDelegate> delegate;

@end

