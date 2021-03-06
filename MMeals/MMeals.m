//
//  MMeals.m
//  MMeals
//
//  Created by David Quesada on 10/11/13.
//  Copyright (c) 2013 David Quesada. All rights reserved.
//

#import "MMealsBase.h"

NSString *MMMealTypeToString(MMMealType type)
{
    if (type == MMMealTypeBreakfast)
        return @"Breakfast";
    if (type == MMMealTypeLunch)
        return @"Lunch";
    if (type == MMMealTypeDinner)
        return @"Dinner";
    return nil;
}

MMMealType MMMealTypeFromTime(NSDate *date)
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    
    double time = (double)components.hour + (double)components.minute / 60.0;
    
    if (time < 10.5)
        return MMMealTypeBreakfast;
    if (time < (12.0 + 4.5))
        return MMMealTypeLunch;
    return MMMealTypeDinner;
}