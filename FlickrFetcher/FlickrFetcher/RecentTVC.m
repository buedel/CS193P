//
//  RecentTVC.m
//  FlickrFetcher
//
//  Created by DOUGLAS BUEDEL on 11/17/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "RecentTVC.h"
#import "FlickrFetcher.h"

@interface RecentTVC ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation RecentTVC


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.spinner startAnimating];
    dispatch_queue_t flickerQueue = dispatch_queue_create("Flicker Queue", NULL);
    dispatch_async(flickerQueue, ^{
        NSArray * recentPhotos = [FlickrFetcher recentGeoreferencedPhotos];
        NSLog(@"Loaded %d photos", recentPhotos.count);
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PHOTO_OWNER ascending:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = [recentPhotos  sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            [self.spinner stopAnimating];
        });
    });
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    cell.detailTextLabel.text = [[self.photos objectAtIndex:indexPath.row] valueForKeyPath:FLICKR_PHOTO_OWNER];
    return cell;
}


@end
