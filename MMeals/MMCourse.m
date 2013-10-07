//
//  MMCourse.m
//  MMeals
//
//  Created by David Quesada on 10/6/13.
//  Copyright (c) 2013 David Quesada. All rights reserved.
//

#import "MMCourse.h"

@interface MMCourse ()

@property (readwrite) NSString *name;
@property (readwrite) NSArray *items;

-(instancetype)initWithName:(NSString *)name items:(NSArray *)items;

@end

@implementation MMCourse

- (id)init
{
    return nil;
}

-(instancetype)initWithName:(NSString *)name items:(NSArray *)items
{
    self = [super init];
    if (self)
    {
        self.name = name.copy;
        self.items = items.copy;
    }
    return self;
}

-(instancetype)courseByMergingItems:(NSArray *)items
{
#warning "Implement this."
    return self;
}

@end
