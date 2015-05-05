//
//  FloodItGame.h
//  Flood-It
//
//  Created by Jerry Zhao on 4/25/15.
//  Copyright (c) 2015 BAP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Board.h"

@interface FloodItGame : NSObject

@property Board* _gameBoard;
@property NSInteger _movesRemaining;

//0 - easy: 14*14, 25 moves
//1 - medium: 21*21, 35 moves
//2 - hard; 28*28, 45 moves
- (instancetype) initWithDifficulty:(NSInteger) difficulty;

- (void) selectTypeOfIndex:(NSInteger) typeIndex;

- (void) endGame;

@end
