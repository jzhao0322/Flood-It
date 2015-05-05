//
//  Board.m
//  Flood-It
//
//  Created by Jerry Zhao on 4/23/15.
//  Copyright (c) 2015 BAP. All rights reserved.
//

#import "Board.h"

@implementation Board

@synthesize _board;

static const int NUMBER_TYPES = 6;

- (instancetype) initWithSize:(NSInteger)sideLength {
    self = [super init];
    
    if (self) {
        _board = [[NSMutableArray alloc] initWithCapacity:sideLength];
        for (int i = 0; i < sideLength; i += 1) {
            NSMutableArray *row = [[NSMutableArray alloc] initWithCapacity:sideLength];
            for (int j = 0; j < sideLength; j += 1) {
                NSInteger randomType = arc4random_uniform(NUMBER_TYPES);
                Pixel *pixel = [[Pixel alloc] initWithTypeIndex: randomType
                                                            atX:i
                                                            atY:j];
                [row addObject:pixel];
            }
            [_board addObject:row];
        }
    }
    
    return self;
}

- (Pixel *) pixelAtX:(NSInteger)xCoordinate
                 atY:(NSInteger)yCoordinate {
    return [[self._board objectAtIndex:xCoordinate] objectAtIndex:yCoordinate];
}

- (BOOL) floodBoardWithType:(NSInteger) replacementType {
    Pixel *topLeft = [self pixelAtX:0 atY:0];
    NSInteger targetType = topLeft._typeIndex;
    if (replacementType == targetType) {
        return NO;
    }
    [self floodFill:topLeft ofType:targetType withType:replacementType];
    return YES;
}
- (void) floodFill:(Pixel *)pixel
            ofType:(NSInteger)targetType
          withType:(NSInteger)replacementType {
    if (targetType != pixel._typeIndex) {
        return;
    } else {
        [pixel floodPixel:replacementType];
    }
    Pixel *right = [self pixelAtX:pixel._xCoordinate + 1 atY:pixel._yCoordinate];
    Pixel *down = [self pixelAtX:pixel._xCoordinate atY:pixel._yCoordinate + 1];
    [self floodFill:right ofType:targetType withType:replacementType];
    [self floodFill:down ofType:targetType withType:replacementType];
}

- (BOOL) boardFlooded {
    NSInteger typeToMatch = [self pixelAtX:0 atY:0]._typeIndex;
    for (NSMutableArray *row in self._board) {
        for (Pixel *pixel in row) {
            if (pixel._typeIndex != typeToMatch) {
                return NO;
            }
        }
    }
    return YES;
}

- (NSString *) toString {
    NSString *result = @"";
    for (NSMutableArray *row in self._board) {
        for (Pixel *pixel in row) {
            result = [result stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)pixel._typeIndex]];
        }
        result = [result stringByAppendingString:@"\r"];
    }
    return result;
}

@end
