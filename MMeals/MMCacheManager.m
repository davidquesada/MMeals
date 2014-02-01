//
//  MMCacheManager.m
//  MMeals
//
//  Created by David Quesada on 2/1/14.
//  Copyright (c) 2014 David Quesada. All rights reserved.
//

#import "MMCacheManager.h"
#import "MMCacheManagerPrivate.h"
#import "MMDiningHallPrivate.h"

@interface MMCacheManager ()

-(id)initAsDefaultManager;
-(void)configureDefaultCache;
-(NSString *)defaultCachePath;
-(NSString *)cacheFilePathForDiningHall:(MMDiningHall *)hall date:(NSDate *)date;

@end

@implementation MMCacheManager

+(instancetype)defaultManager
{
    static MMCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MMCacheManager alloc] initAsDefaultManager];
    });
    return manager;
}

-(id)init
{
    return nil;
}

-(id)initAsDefaultManager
{
    if ((self = [super init]))
        [self configureDefaultCache];
    return self;
}

-(void)configureDefaultCache
{
    self.cachingEnabled = YES;
    self.maximumLength = 10;
    self.cachePath = [self defaultCachePath];
}

-(NSString *)defaultCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"MMMenuCache"];
    return cacheDirectory;
}

-(void)clearMemoryCache
{
    for (MMDiningHall *hall in MMDiningHallList())
    {
        [hall clearCachedMenuInformation];
    }
}

-(NSString *)cacheFilePathForDiningHall:(MMDiningHall *)hall date:(NSDate *)date
{
    NSString *hallDirectory = [NSString stringWithFormat:@"%d", (int)hall.type];
    NSString *dateFile = [NSString stringWithFormat:@"%d", MMDiningHallDateReference(date)];
    
    NSString *path = [self cachePath];
    path = [path stringByAppendingPathComponent:hallDirectory];
    path = [path stringByAppendingPathComponent:dateFile];
    return path;
}

#pragma mark - Cache Implementation

-(void)addCacheData:(NSData *)data diningHall:(MMDiningHall *)hall date:(NSDate *)date
{
    NSString *path = [self cacheFilePathForDiningHall:hall date:date];
    BOOL result = [data writeToFile:path atomically:YES];
    if (!result)
        NSLog(@"Unable to write cache to %@", path);
}

-(NSData *)fetchCacheDataForDiningHall:(MMDiningHall *)hall date:(NSDate *)date
{
    NSString *path = [self cacheFilePathForDiningHall:hall date:date];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

@end
