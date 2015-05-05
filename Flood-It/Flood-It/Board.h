//
//  Board.h
//  Flood-It
//
//  Created by Jerry Zhao on 4/23/15.
//  Copyright (c) 2015 BAP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pixel.h"

@interface Board : NSObject

@property NSMutableArray *_board;

- (instancetype) initWithSize:(NSInteger) sideLength;
- (Pixel*) pixelAtX:(NSInteger) xCoordinate
                atY:(NSInteger) yCoordinate;
- (BOOL) floodBoardWithType:(NSInteger) replacementType;
- (BOOL) boardFlooded;
- (NSString*) toString;

@end
