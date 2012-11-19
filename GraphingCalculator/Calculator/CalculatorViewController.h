//
//  CalculatorViewController.h
//  Calculator
//
//  Created by DOUGLAS BUEDEL on 10/13/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface CalculatorViewController : UIViewController <UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *history;
@property (weak, nonatomic) IBOutlet UILabel *display;

@end
