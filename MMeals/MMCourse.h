//
//  MMCourse.h
//  MMeals
//
//  Created by David Quesada on 10/6/13.
//  Copyright (c) 2013 David Quesada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMCourse : NSObject

@property (readonly) NSString *name;
@property (readonly) NSArray *items;

// This should be moved to somewhere more private.
-(instancetype)courseByMergingItems:(NSArray *)items;

@end
