//
//  MMMenu.m
//  MMeals
//
//  Created by David Quesada on 10/6/13.
//  Copyright (c) 2013 David Quesada. All rights reserved.
//

#import "MMMenuPrivate.h"
#import "MMCourse.h"

@interface MMMenu ()

@property (readwrite) NSArray *breakfastCourses;
@property (readwrite) NSArray *lunchCourses;
@property (readwrite) NSArray *dinnerCourses;

-(NSArray *)mergeCourseArrays:(NSArray *)array1 other:(NSArray *)array2;

-(instancetype)initWithCourseArrays:(NSArray *)arrays;

@end

@implementation MMMenu

-(instancetype)initWithCourseArrays:(NSArray *)arrays
{
    self = [super init];
    if (self)
    {
        self.breakfastCourses = [arrays[0] copy];
        self.lunchCourses = [arrays[1] copy];
        self.dinnerCourses = [arrays[2] copy];
    }
    return self;
}

-(NSArray *)coursesForMeal:(MMMealType)mealType
{
    if ((int)mealType == 0)
        return nil;
    if (mealType == MMMealTypeBreakfast)
        return self.breakfastCourses;
    if (mealType == MMMealTypeLunch)
        return self.lunchCourses;
    if (mealType == MMMealTypeDinner)
        return self.dinnerCourses;
    
    // Otherwise, we have either a garbage value or a combination of meal types.
    
    NSArray *array = [[NSArray alloc] init];
    
    if (mealType & MMMealTypeBreakfast)
        array = self.breakfastCourses;
    if (mealType & MMMealTypeLunch)
        array = [self mergeCourseArrays:array other:self.lunchCourses];
    if (mealType & MMMealTypeDinner)
        array = [self mergeCourseArrays:array other:self.dinnerCourses];
    
    return array;
}

-(void)setCourses:(NSArray *)courses forMeal:(MMMealType)meal
{
    if (meal == MMMealTypeBreakfast)
        self.breakfastCourses = courses.copy;
    else if (meal == MMMealTypeLunch)
        self.lunchCourses = courses.copy;
    else if (meal == MMMealTypeDinner)
        self.dinnerCourses = courses.copy;
}

-(NSArray *)mergeCourseArrays:(NSArray *)array1 other:(NSArray *)array2
{
    NSMutableArray *courseNames = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *courses = [[NSMutableDictionary alloc] init];
    
    for (MMCourse *course in array1)
    {
        courses[course.name] = course;
        [courseNames addObject:course.name];
    }
    
    for (MMCourse *course in array2)
    {
        if ([courseNames containsObject:course.name])
        {
            // If both array1 and array2 contain a course with the same name, we need to merge the menu items of the two courses.
            courses[course.name] = [courses[course.name] courseByMergingItems:course.items];
        }
        else
        {
            // Otherwise, array2 contains a course whose name is not in array1, so we can add the course to the results without conflict.
            courses[course.name] = course;
            [courseNames addObject:course.name];
        }
    }
    
    return [courses objectsForKeys:courseNames notFoundMarker:[NSNull null]];
}

@end
