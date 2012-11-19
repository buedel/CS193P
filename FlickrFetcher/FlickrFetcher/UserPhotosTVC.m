//
//  UserPhotosTVC.m
//  FlickrFetcher
//
//  Created by DOUGLAS BUEDEL on 11/17/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "UserPhotosTVC.h"
#import "FlickrFetcher.h"

@interface UserPhotosTVC ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation UserPhotosTVC


- (void) loadPhotos
{
    // I used http://idgettr.com to find my flickr ID
    dispatch_queue_t flickerQueue = dispatch_queue_create("Flicker Queue", NULL);
    [self.spinner startAnimating];
    dispatch_async(flickerQueue, ^{
        NSArray * photos = [FlickrFetcher photosForId:@"30748390@N05"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = photos;
            [self.spinner stopAnimating];
        });
    });
    NSLog(@"Loaded %d photos", self.photos.count);
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadPhotos];
}




@end
