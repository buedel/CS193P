//
//  PhotosTVC.h
//  FlickrFetcher
//
//  Created by DOUGLAS BUEDEL on 11/12/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import <UIKit/UIKit.h>


#define PHOTOS_RECENT_KEY @"PhotosTVC.RecentPhotos"
#define PHOTOS_TIME_VIEWED_KEY @"PhotosTVCLastTimeViewed"
#define PHOTOS_TITLE @"PhotosTVCPhotoTitle"

@interface PhotosTVC : UITableViewController

@property (nonatomic, strong) NSArray * photos;

- (void) setCellLabels:(UITableViewCell *)cell fromPhotoInfo:(NSDictionary *) photoInfo;

- (void) addToRecent:(NSDictionary *) photoInfo;

- (NSString *) titleFromPhotoInfo:(NSDictionary *) photoInfo;

@end
