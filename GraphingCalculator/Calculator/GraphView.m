//
//  GraphView.m
//  Calculator
//
//  Created by DOUGLAS BUEDEL on 10/20/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView ()
@property BOOL initilized;
@end

@implementation GraphView

@synthesize scale = _scale;
@synthesize origin = _origin;


- (void) setScale:(CGFloat)scale
{
    if (_scale != scale) {
        _scale = scale;
        [self setNeedsDisplay];
        NSLog(@"scale = %f", scale);
    }
}

- (void) setOrigin:(CGPoint)origin
{
    _origin = origin;
    [self setNeedsDisplay];
    NSLog(@"origin = (%f, %f)", origin.x, origin.y);
}

- (void) pinch:(UIPinchGestureRecognizer * )gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void) pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        
        CGPoint tranlation = [gesture translationInView:self];
        [gesture setTranslation:CGPointZero inView:self];

        CGPoint origin = self.origin;
        origin.x += tranlation.x;
        origin.y += tranlation.y;
        self.origin = origin;
        
        NSLog(@"Panned (%f, %f)", tranlation.x, tranlation.y);
    }
}

- (void) tap:(UITapGestureRecognizer *)gesture
{
    int touches = [gesture numberOfTouches];
    if (touches == 1) {
        CGPoint touchPoint = [gesture locationInView:self];
        self.origin = touchPoint;
    }
    NSLog(@"Tapped %d", touches);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();    
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];
    CGContextSetLineWidth(context, 1);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.bounds.origin.x, self.bounds.origin.y);
    
    for (int screenX = 0; screenX < self.bounds.size.width; screenX++) {
        CGFloat x = (screenX - self.origin.x) / self.scale;
        CGFloat y = [self.grapher yForX:x sender:self];
        int screenY = y * self.scale + self.origin.y;
        CGContextAddLineToPoint(context, screenX, screenY);
    }
    CGContextStrokePath(context);
}

@end
