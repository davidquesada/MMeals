//
//  MMNetworkInterface.m
//  MMeals
//
//  Created by David Quesada on 10/7/13.
//  Copyright (c) 2013 David Quesada. All rights reserved.
//

#import "MMNetworkInterface.h"
#import "MMDiningHallPrivate.h"
#import "MMMenuPrivate.h"
#import "MMCoursePrivate.h"
#import "MMMenuItem.h"
#import "XMLDictionary.h"

NSDateFormatter *dateFormatter;

MMMenu *menuFromXMLDictionary(NSDictionary *dict);

@interface MMNetworkInterface ()

@end

@implementation MMNetworkInterface

+(void)load
{
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
}

+(void)fetchMenuForDiningHall:(MMDiningHall *)hall date:(NSDate *)date completion:(MMNetworkCompletionBlock)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        
        NSURL *url = [NSURL URLWithString:[self generateURLForRequestForDiningHall:hall date:date]];
        NSLog(@"%@", [url description]);
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
        
        NSDictionary *dict = [[[XMLDictionaryParser sharedInstance] copy] dictionaryWithData:data];

        MMMenu *menu = menuFromXMLDictionary(dict);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            completion(menu);
        });
    });
}

+(NSString *)generateURLForRequestForDiningHall:(MMDiningHall *)hall date:(NSDate *)menuDate
{
    NSString *format = @"http://www.housing.umich.edu/files/helper_files/js/menu2xml.php?location=%@&date=%@";
    NSString *location = [hall.locationParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *date = [dateFormatter stringFromDate:menuDate];
    
    return [NSString stringWithFormat:format, location, date];
}

@end

MMMealType mealTypeFromString(NSString *string);


// This function contains XML parsing specific to the schema that UMich uses to represent their menu data.
MMMenu *menuFromXMLDictionary(NSDictionary *dict)
{
    MMMenu *menu = [[MMMenu alloc] init];
    dict = dict[@"menu"];

    id meals = dict[@"meal"];
    
    for (id meal in meals)
    {
        NSString *mealName = meal[@"name"];
        MMMealType mealType = mealTypeFromString(mealName);
        
        if (mealType == MMMealTypeNone)
            continue;
        
        id courses = meal[@"course"];
        
        // In the event where a meal only has one course (Typically, this is the case on
        // weekend breakfasts, where there is one course that contains a notice indicating
        // that the dining hall isn't serving breafast.), turn the dictionary representing
        // the course into an array containing the dictionary.
        if (![courses isKindOfClass:[NSArray class]] && courses)
            courses = @[ courses ];
        
        NSMutableArray *mealCourses = [[NSMutableArray alloc] init];
        
        for (id course in courses)
        {
            NSString *courseName = course[@"name"];
            NSMutableArray *courseItems = [[NSMutableArray alloc] init];
            
            id menuitems = course[@"menuitem"];
            
            // In the event where a course only has one menu item, convert the dictionary
            // describing that item into an array containing that dictionary, so it can be
            // fast enumerated over.
            if (![menuitems isKindOfClass:[NSArray class]])
                menuitems = @[ menuitems ];
            
            for (id item in menuitems)
            {
                MMMenuItem *menuItem = [[MMMenuItem alloc] init];
                [menuItem setValue:item[@"name"] forKey:@"name"];
                
                //TODO: Also grab the nutrition info.
                
                [courseItems addObject:menuItem];
            }
            
            MMCourse *c = [[MMCourse alloc] initWithName:courseName items:courseItems];
            [mealCourses addObject:c];
        }
        
        [menu setCourses:mealCourses forMeal:mealType];
    }
    
    return menu;
}

MMMealType mealTypeFromString(NSString *string)
{
    if ([string isEqualToString:@"BREAKFAST"])
        return MMMealTypeBreakfast;
    if ([string isEqualToString:@"LUNCH"])
        return MMMealTypeLunch;
    if ([string isEqualToString:@"DINNER"])
        return MMMealTypeDinner;
    return MMMealTypeNone;
}
