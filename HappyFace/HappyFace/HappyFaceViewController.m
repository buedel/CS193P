//
//  HappyFaceViewController.m
//  HappyFace
//
//  Created by DOUGLAS BUEDEL on 10/20/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "HappyFaceViewController.h"
#import "HappyFaceView.h"

@interface HappyFaceViewController() <FaceViewDataSource>
@property (nonatomic, weak) IBOutlet HappyFaceView * faceView;
@end

@implementation HappyFaceViewController

@synthesize happiness = _happiness;
@synthesize faceView = _faceView;

- (void) setFaceView:(HappyFaceView *)faceView
{
    _faceView = faceView;
    [self.faceView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]
                                         initWithTarget:self.faceView
                                         action:@selector(pinch:)]];
    [self.faceView addGestureRecognizer:[[UIPanGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(handleHappinessGesture:)]];
    self.faceView.dataSource = self;
}

- (void) handleHappinessGesture:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint tranlation = [gesture translationInView:self.faceView];
        self.happiness -= tranlation.y / 2;
        [gesture setTranslation:CGPointZero inView:self.faceView];
    }
}
- (float) smileForFaceVeiew:(HappyFaceView *)sender
{
    return (self.happiness - 50) / 50.0;
}

- (void)setHappiness:(int)happiness
{
    _happiness = happiness;
    [self.faceView setNeedsDisplay];
}


@end
