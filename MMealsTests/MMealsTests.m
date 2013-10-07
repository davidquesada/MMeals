//
//  MMealsTests.m
//  MMealsTests
//
//  Created by David Quesada on 10/6/13.
//  Copyright (c) 2013 David Quesada. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMeals.h"

@interface MMealsTests : XCTestCase

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

- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testClassesDisallowInit
{
    MMCourse *course = [[MMCourse alloc] init];
    MMDiningHall *hall = [[MMDiningHall alloc] init];
    MMMenu *menu = [[MMMenu alloc] init];
    MMMenuItem *item = [[MMMenuItem alloc] init];
    
    XCTAssertNil(course, @"MMCourse allows init.");
    XCTAssertNil(hall, @"MMDiningHall allows init.");
    XCTAssertNil(menu, @"MMMenu allows init.");
    XCTAssertNil(item, @"MMMenuItem allows init.");
}

@end
