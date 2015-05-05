//
//  Pixel.h
//  Flood-It
//
//  Created by Jerry Zhao on 4/23/15.
//  Copyright (c) 2015 BAP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pixel : NSObject

@property NSInteger _typeIndex;
@property NSInteger _xCoordinate;
@property NSInteger _yCoordinate;

- (instancetype) initWithTypeIndex:(NSInteger) index
                               atX:(NSInteger) xCoordinate
                               atY:(NSInteger) yCoordinate;

- (void) floodPixel:(NSInteger) replacementType;


@end
