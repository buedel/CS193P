//
//  CalculatorViewController.m
//  Calculator
//
//  Created by DOUGLAS BUEDEL on 10/13/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "CalculatorViewController.h"
#import "GraphViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController () 
@property BOOL userIsEnteringANumber;
@property BOOL varActive;
@property double result;
@property (nonatomic, strong) CalculatorBrain *brain;
 
@end

@implementation CalculatorViewController

@synthesize userIsEnteringANumber = _userIsEnteringANumber;
@synthesize display = _display;
@synthesize brain = _brain;
@synthesize varActive = _varActive;
@synthesize result = _result;

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
    
}

- (CalculatorBrain *) brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void) executeWithVariables:(NSDictionary *) variables
{
    self.result = [CalculatorBrain runProgram:self.brain.program
                          usingVariableValues:variables];
    [self updateDisplay];
}

- (GraphViewController *) splitViewGraphViewControler
{
    id svc = [self.splitViewController.viewControllers lastObject];
    if (![svc isKindOfClass:[GraphViewController class]]) {
        svc = nil;
    }
    return svc;
}


- (IBAction)graphPressed:(id)sender
{
    NSLog(@"graphPressed");
    if ([self splitViewGraphViewControler]){
        [self splitViewGraphViewControler].program = self.brain.program;
    } else {
        [self performSegueWithIdentifier:@"GraphProgram" sender:self];
    }
}

- (IBAction)undoPressed {
    if (self.userIsEnteringANumber) {
        int len;
        if ((len = self.display.text.length) == 1) {
            [self updateDisplay];
        } else {
            self.display.text = [self.display.text substringToIndex:(len - 1)];
        }
    } else {
        [self updateDisplay];
    }
    
}

- (IBAction)digitPressed:(UIButton *)sender
{
    if (self.userIsEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:sender.currentTitle];
    } else {
        self.display.text = sender.currentTitle;
        self.userIsEnteringANumber = YES;
    }
}
- (IBAction)dotPressed
{
    NSRange range = [self.display.text rangeOfString:@"."];
    if (range.location == NSNotFound) {
        if(!self.userIsEnteringANumber) {
            self.display.text = @"0";
        }
        self.userIsEnteringANumber=YES;
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
}

- (IBAction)variablePressed:(id)sender
{
    if (!self.userIsEnteringANumber) {
        self.display.text = [sender currentTitle];
        self.varActive = YES;
        [self enterPressed];
    }    
}

- (void) updateDisplay {
    self.display.text = [NSString stringWithFormat:@"%g", self.result];
    self.history.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    self.userIsEnteringANumber = NO;
}

- (IBAction)enterPressed
{
    if (self.userIsEnteringANumber) {
        [self.brain pushOperand:self.display.text.doubleValue];
    } else if (self.varActive) {
        [self.brain pushVariable:self.display.text];     
    }
    [self updateDisplay];
    self.userIsEnteringANumber=NO;
    self.varActive=NO;
}

- (IBAction)clearPressed
{
    self.result = 0;
    [self.brain clear];
    [self updateDisplay];
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsEnteringANumber) {
        [self enterPressed];
    }
    if ([self.brain canPerformOperation:sender.currentTitle]) {
        self.result = [self.brain performOperation:sender.currentTitle];
        [self updateDisplay];        
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GraphProgram"]) {
        [segue.destinationViewController setProgram:self.brain.program];
    }
}

//
// Split view delegate Methods
//

- (id <SplitViewBarButtonItemPresenter>) splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        detailVC = nil;
    }
    return detailVC;
}
- (BOOL) splitViewController:(UISplitViewController *)svc
    shouldHideViewController:(UIViewController *)vc
               inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void) splitViewController:(UISplitViewController *)svc
      willHideViewController:(UIViewController *)aViewController
           withBarButtonItem:(UIBarButtonItem *)barButtonItem
        forPopoverController:(UIPopoverController *)pc
{
    // Tell the detail view to put button up
    barButtonItem.title = @"Calculator";
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void) splitViewController:(UISplitViewController *)svc
      willShowViewController:(UIViewController *)aViewController
   invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // tell the detail view to take the button away
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;

}


@end
