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
#import "MMMenuItemPrivate.h"
#import "MMCacheManagerPrivate.h"
#import "XMLDictionary.h"

NSDateFormatter *dateFormatter;

MMMenu *menuFromXMLDictionary(NSDictionary *dict);

@interface MMNetworkInterface ()

+(NSData *)fetchDataForDiningHall:(MMDiningHall *)hall date:(NSDate *)date;

@end

@implementation MMNetworkInterface

+(void)load
{
    @autoreleasepool {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
}

+(void)fetchMenuForDiningHall:(MMDiningHall *)hall date:(NSDate *)date completion:(MMNetworkCompletionBlock)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        
        NSData *data = [self fetchDataForDiningHall:hall date:date];
        NSDictionary *dict = [[[XMLDictionaryParser sharedInstance] copy] dictionaryWithData:data];

        MMMenu *menu = menuFromXMLDictionary(dict);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            completion(menu);
        });
    });
}

+(NSData *)fetchDataForDiningHall:(MMDiningHall *)hall date:(NSDate *)date
{
    // Attempt to get data from the disk cache if possible.
    MMCacheManager *cache = [MMCacheManager defaultManager];
    
    NSData *data = [cache fetchCacheDataForDiningHall:hall date:date];
    if (data)
    {
        NSLog(@"Found cached menu data.");
        return data;
    }
    NSLog(@"Unable to find data in cache, going to the network.");
    
    NSURL *url = [NSURL URLWithString:[self generateURLForRequestForDiningHall:hall date:date]];
    NSLog(@"%@", [url description]);
    data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    NSLog(@"Menu download complete.");
    
    [cache addCacheData:data diningHall:hall date:date];
    
    return data;
}

+(NSString *)generateURLForRequestForDiningHall:(MMDiningHall *)hall date:(NSDate *)menuDate
{
    // Adding the "display=WebMenu" slightly changes the courses returned.
    /*
        E.g. West Quad Dinner on October 11, 2013
        - with WebMenu: Soup, Salad, Homestyles, Olive Branch, Salsa, Dessert
        - w/o  WebMenu: Soup, Salad, Homestyles, Olive Branch, Olive Branch Accompaniments, Salsa, Salsa Accompaniments, Dessert
     */
    NSString *format = @"http://www.housing.umich.edu/files/helper_files/js/menu2xml.php?location=%@&date=%@";//&display=WebMenu";
    NSString *location = [hall.locationParameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *date = [dateFormatter stringFromDate:menuDate];
    
    return [NSString stringWithFormat:format, location, date];
}

@end

MMMealType mealTypeFromString(NSString *string);

MMMenuItem *menuItemFromDictionary(NSDictionary *dict)
{
    MMMenuItem *menuItem = [[MMMenuItem alloc] init];
    [menuItem setValue:dict[@"name"] forKey:@"name"];

    menuItem.servingSize = dict[@"serving_size"];
    menuItem.portionSize = [dict[@"portion_size"] intValue];
    
    NSDictionary *nutrition = dict[@"nutrition"];
    
    NSDictionary *mapping = @{
                              @"kcal" : @"calories",
                              @"kj" : @"caloriesFromFat",
                              @"fat": @"fat",
                              @"sfa": @"saturatedFat",
                              @"fatrn": @"transFat",
                              @"chol" : @"cholesterol",
                              @"na" : @"sodium",
                              @"cho" : @"carbohydrates",
                              @"tdfb" : @"fiber",
                              @"sugar" : @"sugar",
                              @"pro" : @"protein",    
    };
    
    id percentages = [NSMutableDictionary new];
    
    [mapping enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        id tmp;
        // Copy the amount of the nutrient into this MenuItem.
        if ((tmp = nutrition[key]))
            [menuItem setValue:tmp forKey:obj];
        
        // Copy the percentage of this nutrient into this MenuItem.
        if ((tmp = nutrition[[key stringByAppendingString:@"_p"]]))
            percentages[obj] = tmp;
        
    }];
    
    menuItem.percentages = percentages;

    return menuItem;
}


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
                MMMenuItem *menuItem = menuItemFromDictionary(item);
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
