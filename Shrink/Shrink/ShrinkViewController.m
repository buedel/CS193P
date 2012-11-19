//
//  ShrinkViewController.m
//  Shrink
//
//  Created by DOUGLAS BUEDEL on 10/20/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "ShrinkViewController.h"
#import "HappyFaceViewController.h"

@interface ShrinkViewController ()
@property (nonatomic) int diagnosis;
@end

@implementation ShrinkViewController

@synthesize diagnosis = _diagnosis;

- (HappyFaceViewController *) splitViewHappinessViewController
{
    id hvc = [self.splitViewController.viewControllers lastObject];
    if (![hvc isKindOfClass:[HappyFaceViewController class]]) {
        hvc = nil;
    }
    return hvc;
}
- (void) setAndShowDiagnosis:(int)diagnosis
{
    self.diagnosis = diagnosis;

    if ([self splitViewHappinessViewController]){
        [self splitViewHappinessViewController].happiness = diagnosis;
    } else {
        [self performSegueWithIdentifier:@"ShowDiagnosis" sender:self];
    }
}

- (IBAction)food:(id)sender {
    [self setAndShowDiagnosis:80];
}
- (IBAction)sleep:(id)sender {
    [self setAndShowDiagnosis:50];
}
- (IBAction)work:(id)sender {
    [self setAndShowDiagnosis:10];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDiagnosis"]) {
        [segue.destinationViewController setHappiness:self.diagnosis];
    } else if ([segue.identifier isEqualToString:@"Happy"]) {
        [segue.destinationViewController setHappiness:100];
    } else if ([segue.identifier isEqualToString:@"OK"]) {
        [segue.destinationViewController setHappiness:50];
        [segue.destinationViewController setComment:@"ZZZZ"];
    } else if ([segue.identifier isEqualToString:@"Sad"]) {
        [segue.destinationViewController setHappiness:0];
    }
}

@end
