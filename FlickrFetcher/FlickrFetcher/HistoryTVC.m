//
//  RecentPhotosTVC.m
//  FlickrFetcher
//
//  Created by DOUGLAS BUEDEL on 11/14/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "HistoryTVC.h"
#import "PhotosTVC.h"
#import "FlickrFetcher.h"

@interface HistoryTVC ()

@end

@implementation HistoryTVC


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * recentPhotos = [defaults dictionaryForKey:PHOTOS_RECENT_KEY];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:PHOTOS_TIME_VIEWED_KEY ascending:NO];
    NSArray * sortedPhotos = [recentPhotos allValues];
    sortedPhotos = [sortedPhotos  sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    self.photos = sortedPhotos;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell;
}

@end
