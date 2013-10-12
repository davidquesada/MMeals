//
//  NSDate+SimpleFormatting.m
//  MMeals
//
//  Created by David Quesada on 10/11/13.
//  Copyright (c) 2013 David Quesada. All rights reserved.
//

#import "NSDate+SimpleFormatting.h"

@implementation NSDate (SimpleFormatting)

+(NSDate *)dateWithSimpleFormat:(NSString *)f
{
    static NSDateFormatter *formatter = nil;
    if (!formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
    }
    return [formatter dateFromString:f];
}

@end
