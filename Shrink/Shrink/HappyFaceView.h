//
//  HappyFaceView.h
//  HappyFace
//
//  Created by DOUGLAS BUEDEL on 10/20/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HappyFaceView;


@protocol FaceViewDataSource

- (float)smileForFaceVeiew:(HappyFaceView *)sender; // -1 is sad, 1 is happy

@end



@interface HappyFaceView : UIView

@property (nonatomic) CGFloat scale;

@property (nonatomic, weak) IBOutlet id <FaceViewDataSource> dataSource;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
