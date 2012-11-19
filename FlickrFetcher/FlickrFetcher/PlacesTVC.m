//
//  PlacesTVC.m
//  FlickrFetcher
//
//  Created by DOUGLAS BUEDEL on 11/11/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "PlacesTVC.h"
#import "FlickrFetcher.h"
#import "PlacePhotosTVC.h"

@interface PlacesTVC ()

// Model
@property (nonatomic, strong) NSArray * places;
@end

@implementation PlacesTVC

@synthesize places = _places;


#pragma mark - Property Methods

- (NSArray *) places
{
    if (! _places) {
        _places = [FlickrFetcher topPlaces]; // Returns the top 100 places
        
        //_places = [_photos subarrayWithRange:NSMakeRange(0,50)]; // just use the top 50
        // sort by the country name
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"woe_name" ascending:YES];
        _places = [_places sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
    return _places;
}

- (void) setPlaces:(NSArray *)places
{
    _places = places;
}


#pragma mark - UITableViewDataSorce

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Have a section for each country (or something like that).
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlaceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSDictionary * placeInfo = [self.places objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.textLabel.text = [placeInfo valueForKeyPath:@"woe_name"];
    cell.detailTextLabel.text = [placeInfo valueForKeyPath:@"_content"];
    
    return cell;
}

#pragma mark - UITableViewControler

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue identifier: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"ShowPhotosForPlace"]) {
        NSDictionary * selectedPlace = [self.places objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        [segue.destinationViewController setPlace:selectedPlace];
    }
}

#pragma mark - local methods

@end
