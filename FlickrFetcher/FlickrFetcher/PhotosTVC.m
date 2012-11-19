//
//  PhotosTVC.m
//  FlickrFetcher
//
//  Created by DOUGLAS BUEDEL on 11/12/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "PhotosTVC.h"
#import "FlickrFetcher.h"
#import "PictureViewController.h"

@interface PhotosTVC () <PictureViewControllerDelegate>

@end

@implementation PhotosTVC

@synthesize photos = _photos;

- (void) setPhotos:(NSArray *)photos
{
    if (_photos != photos) {
        _photos = photos;
        [self.tableView reloadData];
    }
}

- (void) setCellLabels:(UITableViewCell *)cell fromPhotoInfo:(NSDictionary *) photoInfo
{
    cell.textLabel.text = [photoInfo valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photoInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    // ensure title isn't blank
    if ([cell.textLabel.text isEqualToString:@""]) {
        cell.textLabel.text = [photoInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        cell.detailTextLabel.text = @"";
    }
    if ([cell.textLabel.text isEqualToString:@""]) {
        cell.textLabel.text = @"Unknown";
    }
}

- (NSString *) titleFromPhotoInfo:(NSDictionary *) photoInfo
{
    NSString * title = [photoInfo valueForKeyPath:FLICKR_PHOTO_TITLE];
    if ([title isEqualToString:@""]) {
        title = [photoInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    }
    return title;
}

- (void) setCellImage:(UITableViewCell * )cell fromPhotoInfo:(NSDictionary *) photoInfo
{
    dispatch_queue_t thumbQueue = dispatch_queue_create("Thumb Queue", NULL);
    dispatch_async(thumbQueue, ^{
        NSURL * url = [FlickrFetcher urlForPhoto:photoInfo format:FlickrPhotoFormatSquare];
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        UIImage* image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (cell.window) {
                cell.imageView.image = image;
                [cell setNeedsLayout];
            }
        });
    });
}

- (void) addToRecent:(NSDictionary *) photoInfo
{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * recentPhotos = [[defaults dictionaryForKey:PHOTOS_RECENT_KEY] mutableCopy];
    
    if (!recentPhotos) {
        recentPhotos = [NSMutableDictionary dictionary];
    }
    
    // Add the current time to the photo info for sorting later
    NSMutableDictionary * recentPhotoInfo = [photoInfo mutableCopy];
    NSDate * now = [NSDate date];
    [recentPhotoInfo setObject:now forKey:PHOTOS_TIME_VIEWED_KEY];
    
    // Add the recent photo to the list of recent photosce]
    NSString * key = [recentPhotoInfo objectForKey:FLICKR_PHOTO_ID];
    NSLog(@"Saving Recent Photo:%@, key:%@", recentPhotoInfo, key);
    [recentPhotos setObject:recentPhotoInfo forKey:key];

    // Sort and clamp to the last 20 photos (drop off old phos)
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:PHOTOS_TIME_VIEWED_KEY ascending:NO];
    NSArray * sortedPhotos = [recentPhotos allValues];
    sortedPhotos = [sortedPhotos  sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    // drop off the old photos
    for (int i = 20; i< sortedPhotos.count; i++) {
        [recentPhotos removeObjectForKey:[[sortedPhotos objectAtIndex:i] objectForKey:FLICKR_PHOTO_ID]];
    }
    
    NSLog(@"Saving %d favorite photos", sortedPhotos.count);
    [defaults setObject:recentPhotos forKey:PHOTOS_RECENT_KEY];
    [defaults synchronize];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count = %d", self.photos.count);
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = nil;
    
    NSDictionary * photoInfo = [self.photos objectAtIndex:indexPath.row];
    
    // Set the title and description.
    [self setCellLabels:cell fromPhotoInfo:photoInfo];
    [self setCellImage:cell fromPhotoInfo:photoInfo];
    return cell;
}

#pragma mark - UIViewControler
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowPhoto"]) {
        NSDictionary * selectedPhoto = [self.photos objectAtIndex: self.tableView.indexPathForSelectedRow.row];
        [self addToRecent:selectedPhoto];
        [segue.destinationViewController setTitle:[self titleFromPhotoInfo:selectedPhoto]];
        [segue.destinationViewController setUrl:[FlickrFetcher urlForPhoto:selectedPhoto
                                                                    format:FlickrPhotoFormatLarge]];
        [segue.destinationViewController setDelegate:self];
    }

}

@end
