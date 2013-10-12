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
        XCTAssertTrue(dinner.count == 6, @"Dinner is missing courses.");
        
        id expectedResult = @[
                              @"Soup",
                              @"Salad",
                              @"Homestyles",
                              @"Olive Branch",
                              @"Salsa",
                              @"Dessert",
                              ];
        
        // Transform the array of courses into an array of course names.
        dinner = [dinner valueForKey:@"name"];
        
        XCTAssertTrue([dinner isEqualToArray:expectedResult], @"Unexpected courses: %@", [dinner debugDescription]);
        
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
