//
//  Pixel.m
//  Flood-It
//
//  Created by Jerry Zhao on 4/23/15.
//  Copyright (c) 2015 BAP. All rights reserved.
//

#import "Pixel.h"

@implementation Pixel

@synthesize _typeIndex;
@synthesize _xCoordinate;
@synthesize _yCoordinate;

- (instancetype) initWithTypeIndex:(NSInteger)index
                               atX:(NSInteger)xCoordinate
                               atY:(NSInteger)yCoordinate {
    self = [super init];
    
    if (self) {
        _typeIndex = index;
        _xCoordinate = xCoordinate;
        _yCoordinate = yCoordinate;
    }
    
    return self;
}

- (void) floodPixel:(NSInteger)replacementType {
    if (self._typeIndex != replacementType) {
        self._typeIndex = replacementType;
    }
}

@end
