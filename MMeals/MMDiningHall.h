//
//  MMDiningHall.h
//  MMeals
//
//  Created by David Quesada on 10/6/13.
//  Copyright (c) 2013 David Quesada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMealsBase.h"

@class MMMenu;
@class CLLocation;

@interface MMDiningHall : NSObject

@property (readonly) NSString *name;
@property (readonly) MMDiningHallType type;
@property (readonly) CLLocation *location;

+(NSArray *)allDiningHalls;
+(instancetype)diningHallOfType:(MMDiningHallType)type;
+(instancetype)diningHallClosestToLocation:(CLLocation *)location;

-(void)fetchMenuInformationForToday:(MMFetchCompletionBlock)completion;
-(void)fetchMenuInformationForDate:(NSDate *)date completion:(MMFetchCompletionBlock)completion;

-(MMMenu *)menuInformationForToday;
-(MMMenu *)menuInformationForDate:(NSDate *)date;

@end
