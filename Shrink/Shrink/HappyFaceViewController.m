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
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet HappyFaceView *faceView;
@end

@implementation HappyFaceViewController

@synthesize happiness = _happiness;
@synthesize faceView = _faceView;
@synthesize comment = _comment;
@synthesize commentLabel = _commentLabel;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;

- (void) setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}
- (void) setComment:(NSString *)comment
{
    _comment = comment;
    self.commentLabel.text = comment;
    
}
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.commentLabel.text = self.comment;
}
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

- (IBAction)cheerUp {
    self.happiness = 100;
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
