//
//  Utils.m
//  EjfrFinalProyectiOS
//
//  Created by cice on 21/7/17.
//
//

#import "Utils.h"

@implementation Utils

+(UIColor*) defaultBackgroundColor{
    return [UIColor colorWithRed:1 green:0.6 blue:0.6 alpha:0.6];//[UIColor redColor];
}

+(UIColor*) defaultTableViewBackgroundColor{
    return [UIColor colorWithRed:1 green:0.7 blue:0.7 alpha:0.6];//[UIColor redColor];
}

+(UIColor*) defaultCellTableViewBackgroundColor{
    return [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:3];
}

+(UIColor*)defaultColorButton
{
    return [UIColor blueColor];
}

+(UIColor*)defaultColorSelectedButton
{
    return [UIColor blueColor];
}

+(NSArray*) getIntensityStringArray{
    static NSArray *intensityStringArray;
    intensityStringArray = @[@"Intermittent", @"Normal",@"Gushing"];
    return intensityStringArray;
}

+(NSString*) getIntensityStringForIndex: (int) index{
    return [self getIntensityStringArray][index];
}

+(int) getIntensityDefaultSelectedIndex{
    return 1;
}

+(NSArray*) getTypeStringArray{
    static NSArray *typeStringArray;
    typeStringArray = @[@"Diluted", @"Normal",@"Thick"];
    return typeStringArray;
}

+(NSString*) getTypeStringForIndex: (int) index{
    return [self getTypeStringArray][index];
}

+(int) getTypeDefaultSelectedIndex{
    return 1;
}

+(NSDateFormatter*) getDateFormatterWithDefaultFormatFrom: (NSDate *) date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm";
    return dateFormatter;
}

+(NSString*) getDateFormatterStringWithDefaultFormatFrom: (NSDate *) date{
    NSDateFormatter *dateFormatter= [self getDateFormatterWithDefaultFormatFrom: date];
    return [dateFormatter stringFromDate:date];
}

+(int) getMaxValueForBleedingMinutes{
    return 300;
}

+(NSArray*) getAreasStringArray{
    static NSArray* areas;
    areas = @[@"Nouse", @"Mouth", @"Recturm", @"Other"];
    //areas = [[self getAreasDictionary] allValues];
    return areas;
}

+(NSString*) getStringAreaDefaultIndex{
    return [Utils getAreasStringArray][0];
    //return [self getStringAreaFrom:0];
}

+(NSString*) getStringAreaFrom: (int) index{
    return  [self getAreasStringArray][index];
    //return [[self getAreasDictionary] objectForKey:[NSString stringWithFormat:@"%d",index]];
}

+(int) getIndexFromAreaString: (NSString*) area{
    //NSString * value = [[self getAreasDictionary] valueForKey:area];
    //return [value intValue];
    for(int i=0;i<[self getAreasStringArray].count;i++){
        NSString * value = [self getAreasStringArray][i];
        if([value isEqualToString:area]){
            return i;
        }
    }
    return 0;
}

+(NSDictionary*) getAreasDictionary{
    NSDictionary* areas = [[NSDictionary alloc] initWithObjectsAndKeys:@"Nouse", @"0", @"Mouth", @"1", @"Recturn",@"2", @"Regla", @"3", @"Other",@"4",nil];
    return areas;
}

+(int) getMonthFromDate: (NSDate *) date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM";
    NSString * month = [dateFormatter stringFromDate:date];
    return [month intValue];
}

+(int) getYearFromDate: (NSDate *) date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy";
    NSString * year = [dateFormatter stringFromDate:date];
    return [year intValue];
}

+(int) getDaysBetweenDate1: (NSDate*) startDate date2:(NSDate*) endDate{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    return (int)[components day];
}

@end
