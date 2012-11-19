//
//  PictureViewController.m
//  FlickrFetcher
//
//  Created by DOUGLAS BUEDEL on 11/13/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "PictureViewController.h"
#import "FlickrFetcher.h"

@interface PictureViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PictureViewController

@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize delegate = _delegate;

@synthesize url = _url;

- (void) loadImage
{
    [self.spinner startAnimating];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("Flicker Photo Download Queue", NULL);
    dispatch_async(downloadQueue, ^{
        NSLog(@"URL = %@", self.url);
        NSData * imageData = [NSData dataWithContentsOfURL:self.url];
        UIImage* image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            
            // set the size of the scroll view's content area
            self.scrollView.contentSize = self.imageView.image.size;
            
            self.scrollView.delegate = self;
            CGRect scrollViewFrame = self.scrollView.frame;
            CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
            CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
            CGFloat minScale = MIN(scaleWidth, scaleHeight);
            
            NSLog(@"scaleWidth = %f, scaleHeight = %f, minScale = %f", scaleWidth, scaleHeight, minScale);
            
            self.scrollView.zoomScale = minScale;
            
            self.scrollView.contentSize = self.imageView.image.size;


            [self.spinner stopAnimating];
        });
    });
}

- (void) setUrl:(NSURL *)url
{
    if (_url != url) {
        _url = url;
        if (self.view.window) {
            [self loadImage];
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    NSLog(@"Current Zoom: %f", self.scrollView.zoomScale);
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadImage];
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


@end
