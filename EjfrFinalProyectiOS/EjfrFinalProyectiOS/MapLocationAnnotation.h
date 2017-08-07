//
//  MapLocation.h
//  EjfrFinalProyectiOS
//
//  Created by cice on 24/7/17.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapLocationAnnotation : NSObject <MKAnnotation>

@property (strong,nonatomic) CLLocation *location;
@property (nonatomic,assign) double locationLatitude;
@property (nonatomic,assign) double locationLongitude;

-(id)initWithLocation:(CLLocation*) location;

@end
