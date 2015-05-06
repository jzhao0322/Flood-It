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
@property BOOL _gameWon;
@property BOOL _gameOver;

//0 - easy: 8*8, 20 moves
//1 - medium: 11*11, 25 moves
//2 - hard; 14*14, 35 moves
- (instancetype) initWithDifficulty:(NSInteger) difficulty;

- (void) selectTypeOfIndex:(NSInteger) typeIndex;

- (void) endGame;

@end
