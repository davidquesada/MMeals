//
//  MMNetworkInterface.h
//  MMeals
//
//  Created by David Quesada on 10/7/13.
//  Copyright (c) 2013 David Quesada. All rights reserved.
//

#import "MMealsBase.h"

@class MMMenu;
@class MMDiningHall;

typedef void (^MMNetworkCompletionBlock)(MMMenu *menu);

@interface MMNetworkInterface : NSObject

+(void)fetchMenuForDiningHall:(MMDiningHall *)hall date:(NSDate *)date completion:(MMNetworkCompletionBlock)completion;

@end
