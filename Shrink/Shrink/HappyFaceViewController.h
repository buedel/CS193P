//
//  HappyFaceViewController.h
//  HappyFace
//
//  Created by DOUGLAS BUEDEL on 10/20/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "SplitViewBarButtonItemPresenter.h"

@interface HappyFaceViewController : UIViewController <SplitViewBarButtonItemPresenter>

@property (weak, nonatomic) IBOutlet NSString *comment;
@property (nonatomic) int happiness; // 0 is sad, 100 is happy

@end
