//
//  GraphViewController.m
//  Calculator
//
//  Created by DOUGLAS BUEDEL on 10/20/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"
#import "GraphView.h"
#import "FavoriteGraphesTVC.h"

@interface GraphViewController () <FavoriteGraphesTVCDelegate, Grapher>

@property (nonatomic, weak) IBOutlet GraphView * graphView;
@property (weak, nonatomic) IBOutlet UILabel * formula;
@property (nonatomic, weak) IBOutlet UIToolbar * toolbar;
@property (nonatomic, strong) NSDictionary * favorites;

@property (nonatomic)  NSString * plistPath;


@end


@implementation GraphViewController

#define FAVORITES_KEY @"GraphViewController.Favorites"

@synthesize graphView = _graphView;
@synthesize program = _program;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;
@synthesize favorites = _favorites;

- (void) setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (IBAction)addFavorite:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favorites = [[defaults objectForKey:FAVORITES_KEY] mutableCopy];
    if (!favorites) favorites = [NSMutableArray array];
    
    id program = self.program;
    if (![favorites containsObject:program]) {
        [favorites addObject:program];
        [defaults setObject:favorites forKey:FAVORITES_KEY];
        [defaults synchronize];
    }
}


- (NSString *) plistPath
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                          NSUserDomainMask, YES) objectAtIndex:0];
    return [rootPath stringByAppendingPathComponent:@"graphsettings.plist"];
}

- (id) program
{
    return _program;
}

- (void)setProgram:(id)program
{
    if (_program != program) {
        _program = program;
        self.formula.text = [@"y = " stringByAppendingString:[CalculatorBrain descriptionOfProgram:program]];
        [self.graphView setNeedsDisplay];
    }
}

- (void) setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]
                                         initWithTarget:self.graphView
                                         action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc]
                                         initWithTarget:self.graphView
                                         action:@selector(pan:)]];
     UITapGestureRecognizer * tapgr =[[UITapGestureRecognizer alloc]
                                      initWithTarget:self.graphView
                                      action:@selector(tap:)];
    tapgr.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tapgr];
    self.graphView.grapher = self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    if (self.program) {
        self.formula.text = [@"y = " stringByAppendingString:[CalculatorBrain descriptionOfProgram:self.program]];

    }
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
     
    // Load the default scale and origin
    NSDictionary * plist = [NSDictionary dictionaryWithContentsOfFile:self.plistPath];
    
    if (plist) {
        self.graphView.scale = [[plist valueForKey:@"scale"] floatValue];
        CGPoint origin;
        origin.x = [[plist valueForKey:@"originX"] intValue];
        origin.y = [[plist valueForKey:@"originX"] intValue];
        self.graphView.origin = origin;
    } else {
        self.graphView.scale  = 50;
        
        // Initialize the origin to the center
        CGPoint midpoint;
        midpoint.x = self.graphView.bounds.origin.x + self.graphView.bounds.size.width/2;
        midpoint.y = self.graphView.bounds.origin.y + self.graphView.bounds.size.height/2;
        
        self.graphView.origin = midpoint;
    }
}

- (void) updateUserProperties
{
    // save settings
    NSLog(@"View scale was %f", self.graphView.scale);
    
    NSDictionary * plist =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithFloat:self.graphView.scale], @"scale",
     [NSNumber numberWithInt:self.graphView.origin.x], @"originX",
     [NSNumber numberWithInt:self.graphView.origin.y], @"originY",
     nil];

    [plist writeToFile:self.plistPath atomically:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self updateUserProperties];
}

- (CGFloat) yForX:(CGFloat)x sender:(GraphView *)sender
{
    NSDictionary * vars = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:x], @"x", nil];
    CGFloat y = [CalculatorBrain runProgram:self.program usingVariableValues:vars];
    return y;
}

- (void) favoriteGraphesTVC:(FavoriteGraphesTVC *)sender choseProgram:(id)program
{
    self.program = program;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowFavorites"]) {
        NSArray * programs = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY];
        [segue.destinationViewController setPrograms:programs];
        [segue.destinationViewController setDelegate:self];
    }
}

@end
