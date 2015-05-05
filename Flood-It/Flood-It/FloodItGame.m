//
//  FloodItGame.m
//  Flood-It
//
//  Created by Jerry Zhao on 4/25/15.
//  Copyright (c) 2015 BAP. All rights reserved.
//

#import "FloodItGame.h"

@implementation FloodItGame

@synthesize _gameBoard;
@synthesize _movesRemaining;

- (instancetype) initWithDifficulty:(NSInteger)difficulty {
    self = [super init];
    if (self) {
        NSInteger lengthsByDifficulty[3];
        NSInteger movesByDifficulty[3];
        for (int i = 0; i < 3; i += 1) {
            lengthsByDifficulty[i] = 14 + 7 * i;
        }
        for (int j = 0; j < 3; j += 1) {
            movesByDifficulty[j] = 20 + 5 * (2 * j + 1);
        }
        _movesRemaining = movesByDifficulty[difficulty];
        NSInteger length = lengthsByDifficulty[difficulty];
        _gameBoard = [[Board alloc] initWithSize:length];
    }
    return self;
}

- (void) selectTypeOfIndex:(NSInteger)typeIndex {
    if ([self._gameBoard floodBoardWithType:typeIndex]) {
        _movesRemaining -= 1;
    }
    [self endGame];
}

- (void) endGame {
    if ([_gameBoard boardFlooded]) {
        [self winGame];
    }
    if (_movesRemaining == 0) {
        [self lostGame];
    }
}

- (void) winGame {
    
}

- (void) lostGame {
    
}

@end
