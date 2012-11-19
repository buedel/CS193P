//
//  HappyFaceView.m
//  HappyFace
//
//  Created by DOUGLAS BUEDEL on 10/20/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "HappyFaceView.h"

#define DEBUG_VIEW = NO;

@implementation HappyFaceView

@synthesize scale = _scale;
@synthesize dataSource = _dataSource;

#define DEFAULT_SCALE 0.90

- (CGFloat) scale
{
    if (!_scale) {
        return DEFAULT_SCALE;
    } else {
        return _scale;
    }
}

- (void) setScale:(CGFloat)scale
{
    if (_scale != scale) {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

- (void) pinch:(UIPinchGestureRecognizer * )gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void) setup
{
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void) drawCircleAtPoint:(CGPoint)p
                withRadius:(CGFloat)radius
                inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    CGContextBeginPath(context);

    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
    CGContextFillPath(context);
    
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
    CGContextStrokePath(context);

    UIGraphicsPopContext();
    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    // draw face (circle)
    CGPoint midpoint;
    midpoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midpoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat size = self.bounds.size.width / 2;
    if (self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height / 2;
    size *= self.scale;
    
    CGContextSetLineWidth(context, 10);
    CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
    [[UIColor blackColor] setStroke];
    [self drawCircleAtPoint:midpoint withRadius:size inContext:context];
     
    // draw eyes (2 x circle)
#define EYE_H 0.35
#define EYE_V 0.35
#define EYE_RADIUS 0.10
    
    CGPoint eyePoint;

    CGContextSetLineWidth(context, 5);

    eyePoint.y = midpoint.y - size * EYE_V;

    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    // Left Eye
    eyePoint.x = midpoint.x - size * EYE_H;
    [self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context];
    // Right Eye
    eyePoint.x += size * EYE_H * 2;
    [self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context];
    
    // no nose
    
    // draw mouth (Curve)
#define MOUTH_H 0.45
#define MOUTH_V 0.40
#define MOUTH_SMILE 0.25
    
    CGPoint mouthStart;
    mouthStart.x = midpoint.x - MOUTH_H * size;
    mouthStart.y = midpoint.y + MOUTH_V * size;
    
    CGPoint mouthEnd = mouthStart;
    mouthEnd.x += MOUTH_H * size * 2;
    CGPoint mouthCP1 = mouthStart;
    mouthCP1.x += MOUTH_H * size * 2/3;
    CGPoint mouthCP2 = mouthEnd;
    mouthCP2.x -= MOUTH_H * size * 2/3;
    
    float smile = [self.dataSource smileForFaceVeiew:self];
    if (smile < -1) smile = -1;
    if (smile > 1) smile = 1;
    
    CGFloat smileOffset = MOUTH_SMILE * size * smile;
    mouthCP1.y += smileOffset;
    mouthCP2.y += smileOffset;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);

    [[UIColor blueColor] setStroke];
    CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y);
    CGContextStrokePath(context);
    
/*
 if (DEBUG) {
        // draw the control points
        [[UIColor redColor] setStroke];
        [self drawCircleAtPoint:mouthCP1 withRadius:2 inContext:context];
        [self drawCircleAtPoint:mouthCP2 withRadius:2 inContext:context];
    }
 */   
    // Drawing code
}

@end
