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
#import <CoreLocation/CoreLocation.h>

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
@property (readwrite) CLLocation *location;

-(instancetype)initWithType:(MMDiningHallType)type name:(NSString *)name urlParam:(NSString *)urlParam location:(CLLocation *)location;

@end


@implementation MMDiningHall

+(void)load
{
#define CREATE(Type,Name,Location,Latitude,Longitude) [[MMDiningHall alloc] initWithType:Type name:Name urlParam:Location location:[[CLLocation alloc] initWithLatitude:Latitude longitude:Longitude]]
    diningHalls = @{
                    @(MMDiningHallBarbour)      : CREATE(MMDiningHallBarbour, @"Barbour", @"BARBOUR DINING HALL", 42.277136, -83.741623),
                    @(MMDiningHallBursley)      : CREATE(MMDiningHallBursley, @"Bursley", @"BURSLEY DINING HALL", 42.293764, -83.720925),
                    @(MMDiningHallEastQuad)     : CREATE(MMDiningHallEastQuad, @"East Quad", @"EAST QUAD DINING HALL", 42.27294, -83.735178),
                    @(MMDiningHallMarketplace)  : CREATE(MMDiningHallMarketplace, @"Mosher-Jordan", @"Mosher Jordan Dining Hall", 42.280109, -83.731632),
                    @(MMDiningHallMarkley)      : CREATE(MMDiningHallMarkley, @"Markley", @"MARKLEY DINING HALL", 42.280875, -83.728864),
                    @(MMDiningHallNorthQuad)    : CREATE(MMDiningHallNorthQuad, @"North Quad", @"North Quad Dining Hall", 42.2807, -83.740295),
                    @(MMDiningHallSouthQuad)    : CREATE(MMDiningHallSouthQuad, @"South Quad", @"SOUTH QUAD DINING HALL", 42.273718, -83.742109),
                    @(MMDiningHallTwigs)        : CREATE(MMDiningHallTwigs, @"Twigs", @"Twigs at Oxford", 42.274667, -83.725302),
                    @(MMDiningHallWestQuad)     : CREATE(MMDiningHallWestQuad, @"West Quad", @"WEST QUAD DINING HALL", 42.274881, -83.742565),
                    };
#undef CREATE
    
    // By adding, removing, or reordering dining hall types from this list, you can essentially enable
    // or disable application access to dining halls without removing their definition. This may be
    // useful for removing dining halls that are closed for renovation so they don't appear in applications.
    
    diningHallTypes = @[
                        //@(MMDiningHallBarbour),
                        @(MMDiningHallBursley),
                        @(MMDiningHallEastQuad),
                        @(MMDiningHallMarkley),
                        @(MMDiningHallMarketplace),
                        @(MMDiningHallNorthQuad),
                        @(MMDiningHallSouthQuad),
                        @(MMDiningHallTwigs),
                        //@(MMDiningHallWestQuad),
                        ];
    
    diningHallInstances = [diningHalls objectsForKeys:diningHallTypes notFoundMarker:[NSNull null]];
}

-(instancetype)initWithType:(MMDiningHallType)type name:(NSString *)name urlParam:(NSString *)urlParam location:(CLLocation *)location
{
    self = [super init];
    if (self)
    {
        self.menuInformation = [[NSMutableDictionary alloc] init];
        self.type = type;
        self.name = name.copy;
        self.locationParameter = urlParam.copy;
        self.location = location;
    }
    return self;
}

+(NSArray *)allDiningHalls
{
    return diningHallInstances.copy;
}

+(instancetype)diningHallOfType:(MMDiningHallType)type
{
    return diningHalls[@(type)];
}

+(instancetype)diningHallClosestToLocation:(CLLocation *)location
{
    double min_distance = DBL_MAX;
    MMDiningHall *hall = nil;
    
    for (MMDiningHall *h in diningHallInstances)
    {
        double dist = [location distanceFromLocation:h.location];
        if (dist < min_distance)
        {
            min_distance = dist;
            hall = h;
        }
    }
    
    return hall;
}

-(void)clearCachedMenuInformation
{
    [self.menuInformation removeAllObjects];
}

-(void)clearCachedMenuInformationForDate:(NSDate *)date
{
    [self.menuInformation removeObjectForKey:@(dateReference(date))];
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
        {
            obtainedInformation();
            return; // TODO: Handle the case of errors.
        }
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
