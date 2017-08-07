//
//  Bleed+CoreDataProperties.h
//  EjfrFinalProyectiOS
//
//  Created by cice on 20/7/17.
//
//

#import "Bleed+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Bleed (CoreDataProperties)

+ (NSFetchRequest<Bleed *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *area;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic) int16_t intensity;
@property (nonatomic) int64_t length;
@property (nonatomic) int16_t type;
@property (nonatomic) BOOL stop;
@property (nonatomic) BOOL stress;
@property (nonatomic) double locationLatitude;
@property (nonatomic) double locationLongitude;

@end

NS_ASSUME_NONNULL_END
