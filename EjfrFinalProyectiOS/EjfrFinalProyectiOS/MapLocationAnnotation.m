//
//  MapLocation.m
//  EjfrFinalProyectiOS
//
//  Created by cice on 24/7/17.
//
//

#import "MapLocationAnnotation.h"

@implementation MapLocationAnnotation

-(id)initWithLocation:(CLLocation*) location
{
    self = [super init];
    if(self){
        self.location = location;
    }
    return self;
}

-(CLLocationCoordinate2D)coordinate{
    
    return self.location.coordinate;
}

@end
