/*
//  LMErrorKitExample_iOSViewController.m
//  LMErrorKitExample_iOS
//
//  Created by Jose Vazquez on 4/19/11.
//  Copyright 2011 Little Mustard LLC. All rights reserved.
*/

#import "LMErrorKitExample_iOSViewController.h"
#import "MATesting.h"

@implementation LMErrorKitExample_iOSViewController

- (void)dealloc {
    [_textView release], _textView=nil;

    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload {
    [super viewDidUnload];

    self.textView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - IBActions
- (IBAction)runTests:(id)sender {
    self.textView.text = [MATesting runTests];
}


#pragma mark - Accessors
@synthesize textView=_textView;

@end
