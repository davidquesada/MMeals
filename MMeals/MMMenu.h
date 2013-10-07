//
//  MMMenu.h
//  MMeals
//
//  Created by David Quesada on 10/6/13.
//  Copyright (c) 2013 David Quesada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMealsBase.h"

@interface MMMenu : NSObject

// MMMealType is also a bitmask that allows you to select courses for multiple meals at once.
-(NSArray *)coursesForMeal:(MMMealType)mealType;

@property (readonly) NSArray *breakfastCourses;
@property (readonly) NSArray *lunchCourses;
@property (readonly) NSArray *dinnerCourses;

@end
