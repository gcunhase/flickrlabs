//
//  CollectionCell.m
//  flickrlabs
//
//  Created by csjones on 12/7/12.
//  Copyright (c) 2012 csjones. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
     
    // Set the border width
    CGContextSetLineWidth(contextRef, 5.0);
     
    // Set the border color to BLACK
    CGContextSetRGBStrokeColor(contextRef, 0.0, 0.0, 0.0, .5);
     
    CGFloat pattern[] = {5, 5};
     
    // Drawing code
    CGContextSetLineDash(contextRef, .0, pattern, 2);
     
    // Draw the border along the view edge
    CGContextStrokeRect(contextRef, rect);
}


@end
