//
//  MMCacheManager.h
//  MMeals
//
//  Created by David Quesada on 2/1/14.
//  Copyright (c) 2014 David Quesada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMCacheManager : NSObject
+(instancetype)defaultManager;

@property BOOL cachingEnabled;
@property int maximumLength;
@property NSString *cachePath;
-(void)clearMemoryCache;

@end
