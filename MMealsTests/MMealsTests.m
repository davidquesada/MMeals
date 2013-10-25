//
//  MMealsTests.m
//  MMealsTests
//
//  Created by David Quesada on 10/6/13.
//  Copyright (c) 2013 David Quesada. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMeals.h"
#import "NSDate+SimpleFormatting.h"

@interface MMealsTests : XCTestCase

@property BOOL done;

@end

@implementation MMealsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSimpleCoursesExample
{
    MMDiningHall *hall = [MMDiningHall diningHallOfType:MMDiningHallWestQuad];
    
    NSDate *date = [NSDate dateWithSimpleFormat:@"2013-10-11"];
    [hall fetchMenuInformationForDate:date completion:^{
        self.done = YES;
        
        MMMenu *menu = [hall menuInformationForDate:date];
        XCTAssertNotNil(menu, @"Network call returned nil menu.");
        
        NSArray *dinner = [menu dinnerCourses];
        
        XCTAssertNotNil(dinner, @"The list of dinner courses is null.");
        XCTAssertTrue(dinner.count == 8, @"Dinner is missing courses.");
        
        id expectedResult = @[
                              @"Soup",
                              @"Salad",
                              @"Homestyles",
                              @"Olive Branch",
                              @"Olive Branch Accompaniments",
                              @"Salsa",
                              @"Salsa Accompaniments",
                              @"Dessert",
                              ];
        
        // Transform the array of courses into an array of course names.
        dinner = [dinner valueForKey:@"name"];
        
        XCTAssertTrue([dinner isEqualToArray:expectedResult], @"Unexpected courses: %@", [dinner debugDescription]);
        
    }];
    
    [self waitForDone];
}

-(void)testSimpleNutritionExample
{
    MMDiningHall *bursley = [MMDiningHall diningHallOfType:MMDiningHallBursley];
    NSDate *date = [NSDate dateWithSimpleFormat:@"2013-10-8"];
    
    [bursley fetchMenuInformationForDate:date completion:^{
        self.done = YES;
        
        MMMenu *menu = [bursley menuInformationForDate:date];
        NSArray *lunch = menu.lunchCourses;
        MMCourse *salads = lunch[2];
        MMMenuItem *item = salads.items[0];
        
        XCTAssertEqualObjects(salads.name, @"Salad", @"Wrong course name!");
        XCTAssertEqualObjects(item.name, @"Buffalo Chicken Salad", @"Wrong menu item name!");
        
        XCTAssertTrue(item.calories == 240, @"Wrong calorie count!");
        XCTAssertTrue(item.caloriesFromFat == 79, @"Wrong fat calorie count!");
        XCTAssertTrue(item.fat == 9, @"Wrong fat count!");
        XCTAssertTrue(item.saturatedFat == 2, @"Wrong saturated fat count!");
        XCTAssertTrue(item.transFat == 0, @"Wrong trans fat count!");
        XCTAssertTrue(item.cholesterol == 88, @"Wrong cholesterol count!");
        XCTAssertTrue(item.sodium == 654, @"Wrong sodium count!");
        XCTAssertTrue(item.carbohydrates == 5, @"Wrong carbohydrate count!");
        XCTAssertTrue(item.fiber == 2, @"Wrong fiber count!");
        XCTAssertTrue(item.sugar == 3, @"Wrong sugar count!");
        XCTAssertTrue(item.protein == 32, @"Wrong protein count!");
        XCTAssertTrue(item.portionSize == 271, @"Wrong portion size (grams)!");
        XCTAssertTrue([item.servingSize isEqualToString:@"Salad"], @"Wrong serving size (description)!");
        
    }];
    [self waitForDone];
}

-(void)waitForDone
{
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:4.0f];
    do
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if ([timeoutDate timeIntervalSinceNow] < 0.0)
        {
            break;
        }
    }
    while (!self.done);
    
    if (!self.done)
        XCTFail(@"Timed out.");
}

@end
