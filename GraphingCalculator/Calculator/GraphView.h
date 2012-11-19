//
//  GraphView.h
//  Calculator
//
//  Created by DOUGLAS BUEDEL on 10/20/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;


@protocol Grapher

// return a y value for the given x value.
// the controler will have access to the views scale and origin
- (CGFloat)yForX:(CGFloat)x sender:(GraphView *)sender;

@end

@interface GraphView : UIView
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;

@property (nonatomic, weak) IBOutlet id <Grapher> grapher;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;  // set the scale
- (void)pan:(UIPanGestureRecognizer *)gesture; // move the origin
- (void)tap:(UITapGestureRecognizer *)gesture; // Tripple Tap to set the origin

@end
