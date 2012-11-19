//
//  PictureViewController.h
//  FlickrFetcher
//
//  Created by DOUGLAS BUEDEL on 11/13/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureViewControllerDelegate
@optional
@end

@interface PictureViewController : UIViewController

@property (nonatomic, strong) NSURL * url;

@property (nonatomic, weak) id <PictureViewControllerDelegate> delegate;

@end
