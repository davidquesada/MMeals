//
//  MMDiningHall.m
//  MMeals
//
//  Created by David Quesada on 10/6/13.
//  Copyright (c) 2013 David Quesada. All rights reserved.
//

#import "MMDiningHall.h"
#import "MMDiningHallPrivate.h"
#import "MMNetworkInterface.h"

NSArray *diningHallTypes;
NSArray *diningHallInstances;

NSDictionary *diningHalls;

/// Helper Functions

NSInteger dateReference(NSDate *date)
{
    static NSCalendar *gregorianCalendar = nil;
    static NSDate *referenceDate = nil;
    
    if (!gregorianCalendar)
        gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    if (!referenceDate)
        referenceDate = [NSDate dateWithTimeIntervalSince1970:0];
    
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:referenceDate toDate:date options:0];
    
    return [components day];
}

@interface MMDiningHall ()

@property NSMutableDictionary *menuInformation;

@property (readwrite) NSString *name;
@property (readwrite) MMDiningHallType type;

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
#undef CREATE
    
    // By adding, removing, or reordering dining hall types from this list, you can essentially enable
    // or disable application access to dining halls without removing their definition. This may be
    // useful for removing dining halls that are closed for renovation so they don't appear in applications.
    
    diningHallTypes = @[
                        @(MMDiningHallBarbour),
                        @(MMDiningHallBursley),
                        @(MMDiningHallEastQuad),
                        @(MMDiningHallMarketplace),
                        @(MMDiningHallMarkley),
                        @(MMDiningHallNorthQuad),
                        @(MMDiningHallSouthQuad),
                        @(MMDiningHallTwigs),
                        @(MMDiningHallWestQuad),
                        ];
    
    diningHallInstances = [diningHalls objectsForKeys:diningHallTypes notFoundMarker:[NSNull null]];
}

-(instancetype)initWithType:(MMDiningHallType)type name:(NSString *)name location:(NSString *)location
{
    self = [super init];
    if (self)
    {
        self.menuInformation = [[NSMutableDictionary alloc] init];
        self.type = type;
        self.name = name.copy;
        self.locationParameter = location.copy;
    }
    return self;
}

- (id)init
{
    return nil;
}

+(NSArray *)allDiningHalls
{
    return diningHallInstances.copy;
}

+(instancetype)diningHallOfType:(MMDiningHallType)type
{
    return diningHalls[@(type)];
}

-(void)fetchMenuInformationForToday:(MMFetchCompletionBlock)completion
{
    [self fetchMenuInformationForDate:[NSDate date] completion:completion];
}

-(void)fetchMenuInformationForDate:(NSDate *)date completion:(MMFetchCompletionBlock)completion
{
    void (^obtainedInformation)(void) = ^{
        // TODO: Determine what type of completion handler should go here, then call it.
        if (completion)
            completion();
    };
    
    // First, check to see if we have already fetched data for the current date from
    // the server and cached it in self.menuInformation. If so, used the cached version.
    
    NSInteger ref = dateReference(date);
    id info = self.menuInformation[@(ref)];
    
    if (info)
    {
        obtainedInformation();
        return;
    }
    
    [MMNetworkInterface fetchMenuForDiningHall:self date:date completion:^(MMMenu *menu) {
        if (menu == nil)
            return; // TODO: Handle the case of errors.
        
        self.menuInformation[@(ref)] = menu;
        obtainedInformation();
    }];
}

-(MMMenu *)menuInformationForToday
{
    return [self menuInformationForDate:[NSDate date]];
}

-(MMMenu *)menuInformationForDate:(NSDate *)date
{
    NSInteger ref = dateReference(date);
    return self.menuInformation[@(ref)];
}

@end
