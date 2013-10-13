//
//  MMealsBase.h
//  MMeals
//
//  Created by David Quesada on 10/6/13.
//  Copyright (c) 2013 David Quesada. All rights reserved.
//

typedef NS_ENUM(NSInteger, MMDiningHallType)
{
    MMDiningHallBarbour,
    MMDiningHallBursley,
    MMDiningHallEastQuad,
    MMDiningHallMarketplace,
    MMDiningHallMarkley,
    MMDiningHallNorthQuad,
    MMDiningHallSouthQuad,
    MMDiningHallTwigs,
    MMDiningHallWestQuad,
};

typedef NS_ENUM(NSInteger, MMMealType)
{
    MMMealTypeNone = 0,
    MMMealTypeBreakfast = 1 << 0,
    MMMealTypeLunch = 1 << 1,
    MMMealTypeDinner = 1 << 2,
};

typedef void (^MMFetchCompletionBlock)(void);