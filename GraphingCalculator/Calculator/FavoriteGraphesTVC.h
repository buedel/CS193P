//
//  FavorateGraphesTVC.h
//  Calculator
//
//  Created by DOUGLAS BUEDEL on 11/10/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FavoriteGraphesTVC;

@protocol FavoriteGraphesTVCDelegate
@optional
- (void)favoriteGraphesTVC:(FavoriteGraphesTVC *)sender
              choseProgram:(id)program;

@end

@interface FavoriteGraphesTVC : UITableViewController

@property (nonatomic, strong) NSArray * programs;

@property (nonatomic, weak) id <FavoriteGraphesTVCDelegate> delegate;

@end
