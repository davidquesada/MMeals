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

-(NSArray *)coursesForMeal:(MMMealType)mealType;

-(NSArray *)breakfast;
-(NSArray *)lunch;
-(NSArray *)dinner;

@end
