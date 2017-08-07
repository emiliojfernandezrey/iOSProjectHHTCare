//
//  Bleed+CoreDataProperties.m
//  EjfrFinalProyectiOS
//
//  Created by cice on 20/7/17.
//
//

#import "Bleed+CoreDataProperties.h"

@implementation Bleed (CoreDataProperties)

+ (NSFetchRequest<Bleed *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Bleed"];
}

@dynamic area;
@dynamic date;
@dynamic intensity;
@dynamic length;
@dynamic type;
@dynamic stop;
@dynamic stress;
@dynamic locationLatitude;
@dynamic locationLongitude;

@end
