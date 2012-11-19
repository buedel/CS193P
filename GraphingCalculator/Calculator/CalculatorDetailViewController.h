//
//  CalculatorDetailViewController.h
//  Calculator
//
//  Created by DOUGLAS BUEDEL on 10/23/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
