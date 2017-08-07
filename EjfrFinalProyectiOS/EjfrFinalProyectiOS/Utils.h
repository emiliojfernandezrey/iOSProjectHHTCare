//
//  Utils.h
//  EjfrFinalProyectiOS
//
//  Created by cice on 21/7/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

//Defining Colors
+(UIColor*)defaultBackgroundColor;
+(UIColor*)defaultCellTableViewBackgroundColor;
+(UIColor*)defaultTableViewBackgroundColor;
+(UIColor*)defaultColorButton;
+(UIColor*)defaultColorSelectedButton;

//Bleeding fields and values
+(NSString*)getIntensityStringForIndex: (int) index;
+(int)getIntensityDefaultSelectedIndex;
+(NSArray*) getIntensityStringArray;
+(NSString*)getTypeStringForIndex: (int) index;
+(NSArray*) getTypeStringArray;
+(int)getTypeDefaultSelectedIndex;
+(NSDateFormatter*) getDateFormatterWithDefaultFormatFrom: (NSDate *) date;
+(NSString*) getDateFormatterStringWithDefaultFormatFrom: (NSDate *) date;
+(int) getMaxValueForBleedingMinutes;
+(NSArray*) getAreasStringArray;
+(NSString*) getStringAreaDefaultIndex;
+(NSString*) getStringAreaFrom: (int) index;
+(int) getIndexFromAreaString: (NSString*) area;
//+(NSDictionary*) getAreasDictionary;

+(int) getMonthFromDate: (NSDate *) date;
+(int) getYearFromDate: (NSDate *) date;
+(int) getDaysBetweenDate1: (NSDate*) startDate date2:(NSDate*) endDate;
@end
