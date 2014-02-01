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
-(NSString *)cacheDirectoryForDiningHall:(MMDiningHall *)hall;
-(NSString *)cacheFilePathForDiningHall:(MMDiningHall *)hall date:(NSDate *)date;
-(void)limitCacheSizeInDirectory:(NSString *)path;
-(void)ensurePathExists:(NSString *)path;

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

-(NSString *)cacheDirectoryForDiningHall:(MMDiningHall *)hall
{
    NSString *hallComponent = [NSString stringWithFormat:@"%d", (int)hall.type];
    NSString *path = [self cachePath];
    path = [path stringByAppendingPathComponent:hallComponent];
    [self ensurePathExists:path];
    return path;
}

-(NSString *)cacheFilePathForDiningHall:(MMDiningHall *)hall date:(NSDate *)date
{
    NSString *dateFile = [NSString stringWithFormat:@"%d", MMDiningHallDateReference(date)];
    
    NSString *path = [self cacheDirectoryForDiningHall:hall];
    path = [path stringByAppendingPathComponent:dateFile];
    return path;
}

-(void)ensurePathExists:(NSString *)path
{
    NSError * error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    if (error)
    {
        NSLog(@"error creating directory: %@", error);
    }
}

-(void)limitCacheSizeInDirectory:(NSString *)path
{
    if (self.maximumLength < 0)
        return;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *filenames = [fm contentsOfDirectoryAtPath:path error:nil];
    if (filenames.count <= self.maximumLength)
        return;
    
    // This next part (the part that eliminates extra cachefiles) makes the assumption
    // that older menus are less important.
    filenames = [filenames sortedArrayUsingSelector:@selector(compare:)];
    
    int deleteCount = (filenames.count - self.maximumLength);
    NSLog(@"Removing %d items from disk cache", deleteCount);
    for (int i = 0; i < deleteCount; ++i)
    {
        NSString *filename = [path stringByAppendingPathComponent:filenames[i]];
        BOOL result = [fm removeItemAtPath:filename error:nil];
        NSLog(@"Result: %d", result);
    }
}

#pragma mark - Cache Implementation

-(void)addCacheData:(NSData *)data diningHall:(MMDiningHall *)hall date:(NSDate *)date
{
    if (!_cachingEnabled)
        return;
    NSString *path = [self cacheFilePathForDiningHall:hall date:date];
    BOOL result = [data writeToFile:path atomically:YES];
    if (!result)
    {
        NSLog(@"Unable to write cache to %@", path);
        return;
    }
    [self limitCacheSizeInDirectory:[self cacheDirectoryForDiningHall:hall]];
}

-(NSData *)fetchCacheDataForDiningHall:(MMDiningHall *)hall date:(NSDate *)date
{
    if (!_cachingEnabled)
        return nil;
    NSString *path = [self cacheFilePathForDiningHall:hall date:date];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

@end
