//
//  PlacePhotosTVC.m
//  FlickrFetcher
//
//  Created by DOUGLAS BUEDEL on 11/17/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "PlacePhotosTVC.h"
#import "FlickrFetcher.h"

@interface PlacePhotosTVC ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation PlacePhotosTVC

@synthesize place = _place;

- (void) loadPhotos
{
    dispatch_queue_t flickerQueue = dispatch_queue_create("Flicker Queue", NULL);
    
    [self.spinner startAnimating];
    dispatch_async(flickerQueue, ^{
        NSArray * photosForPlace = [FlickrFetcher photosInPlace:self.place maxResults:50];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTitle:[self.place valueForKeyPath:@"woe_name"]];
            self.photos = photosForPlace;
            [self.spinner stopAnimating];
        });
    });
    
}
- (void) setPlace:(NSDictionary *) place
{
    if (_place != place) {
        _place = place;
        [self loadPhotos];
    }
}

@end
