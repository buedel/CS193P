//
//  FavorateGraphesTVC.m
//  Calculator
//
//  Created by DOUGLAS BUEDEL on 11/10/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "FavoriteGraphesTVC.h"
#import "CalculatorBrain.h"

@interface FavoriteGraphesTVC ()

@end

#define FAVORITE_KEY @"CalculatorFavorites"

@implementation FavoriteGraphesTVC

@synthesize programs = _programs;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.programs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Program Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    id program = [self.programs objectAtIndex:indexPath.row];
    cell.textLabel.text = [@"y = " stringByAppendingString:[CalculatorBrain descriptionOfProgram:program]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id program = [self.programs objectAtIndex:indexPath.row];
    [self.delegate favoriteGraphesTVC:self choseProgram:program];
}

@end
