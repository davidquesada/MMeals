//
//  MMDiningHall.m
//  MMeals
//
//  Created by David Quesada on 10/6/13.
//  Copyright (c) 2013 David Quesada. All rights reserved.
//

#import "MMDiningHall.h"

NSDictionary *diningHalls;


@interface MMDiningHall ()

@property NSString *locationParameter;

-(instancetype)initWithType:(MMDiningHallType)type name:(NSString *)name location:(NSString *)location;

@end

@implementation MMDiningHall

+(void)load
{
#define CREATE(Type,Name,Location) [[MMDiningHall alloc] initWithType:Type name:Name location:Location]
    diningHalls = @{
                    @(MMDiningHallBarbour)      : CREATE(MMDiningHallBarbour, @"Barbour", @""),
                    @(MMDiningHallBursley)      : CREATE(MMDiningHallBursley, @"Bursley", @"BURSLEY DINING HALL"),
                    @(MMDiningHallEastQuad)     : CREATE(MMDiningHallEastQuad, @"East Quad", @""),
                    @(MMDiningHallMarketplace)  : CREATE(MMDiningHallMarketplace, @"Marketplace at Hill", @""),
                    @(MMDiningHallMarkley)      : CREATE(MMDiningHallMarkley, @"Markley", @""),
                    @(MMDiningHallNorthQuad)    : CREATE(MMDiningHallNorthQuad, @"North Quad", @""),
                    @(MMDiningHallSouthQuad)    : CREATE(MMDiningHallSouthQuad, @"South Quad", @""),
                    @(MMDiningHallTwigs)        : CREATE(MMDiningHallTwigs, @"Twigs", @""),
                    @(MMDiningHallWestQuad)     : CREATE(MMDiningHallWestQuad, @"West Quad", @""),
                    };
}

@end
