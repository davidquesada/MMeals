//
//  MMMenuItem.h
//  MMeals
//
//  Created by David Quesada on 10/6/13.
//  Copyright (c) 2013 David Quesada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMMenuItem : NSObject

@property (readonly) NSString *name;

@property (readonly) int calories;
@property (readonly) int caloriesFromFat;

@property (readonly) int fat;
@property (readonly) int saturatedFat;
@property (readonly) int transFat;

@property (readonly) int cholesterol;
@property (readonly) int sodium;

@property (readonly) int carbohydrates;
@property (readonly) int fiber;
@property (readonly) int sugar;
@property (readonly) int protein;

@property (readonly) int portionSize;
@property (readonly) NSString *servingSize;

@property (readonly) NSDictionary *percentages;

@end
