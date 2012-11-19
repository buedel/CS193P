//
//  ViewController.m
//  Imaginarium
//
//  Created by CS193p Instructor on 4/26/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ViewController

@synthesize imageView;
@synthesize scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set the size of the scroll view's content area
    self.scrollView.contentSize = self.imageView.image.size;
    
    // set the position and size of the image view
    //  in the scroll view's content area
    CGRect imageViewFrame;
    imageViewFrame.origin = CGPointZero;
    imageViewFrame.size = self.imageView.image.size;
    self.imageView.frame = imageViewFrame;
    
    // set the scroll view's delegate (so zooming will work)
    self.scrollView.delegate = self;
}

// make zooming in the scroll view operate on the image view

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


@end
