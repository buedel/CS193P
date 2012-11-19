//
//  WebViewController.m
//  Shrink
//
//  Created by DOUGLAS BUEDEL on 11/4/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (nonatomic, weak) IBOutlet UIWebView * webView;
@end

@implementation WebViewController

@synthesize webView = _webView;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]]];
}

@end
