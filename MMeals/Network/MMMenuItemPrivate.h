//
//  MMMenuItemPrivate.h
//  MMeals
//
//  Created by David Quesada on 10/11/13.
//  Copyright (c) 2013 David Quesada. All rights reserved.
//

#import "MMMenuItem.h"

@interface MMMenuItem ()

@property (readwrite) NSString *name;

@property (readwrite) int calories;
@property (readwrite) int caloriesFromFat;

@property (readwrite) int fat;
@property (readwrite) int saturatedFat;
@property (readwrite) int transFat;

@property (readwrite) int cholesterol;
@property (readwrite) int sodium;

@property (readwrite) int carbohydrates;
@property (readwrite) int fiber;
@property (readwrite) int sugar;
@property (readwrite) int protein;

@property (readwrite) int portionSize;
@property (readwrite) NSString *servingSize;

@property (readwrite) NSDictionary *percentages;

@end