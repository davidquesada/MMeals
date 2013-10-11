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
