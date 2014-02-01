//
//  MMCacheManagerPrivate.h
//  MMeals
//
//  Created by David Quesada on 2/1/14.
//  Copyright (c) 2014 David Quesada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMCacheManager.h"

@class MMDiningHall;

typedef void (^MMCacheFetchBlock)(NSData *data);

@interface MMCacheManager ()
-(void)addCacheData:(NSData *)data diningHall:(MMDiningHall *)hall date:(NSDate *)date;
-(NSData *)fetchCacheDataForDiningHall:(MMDiningHall *)hall date:(NSDate *)date;
@end