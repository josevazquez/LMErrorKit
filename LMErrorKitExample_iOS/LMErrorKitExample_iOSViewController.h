/*
//  LMErrorKitExample_iOSViewController.h
//  LMErrorKitExample_iOS
//
//  Created by Jose Vazquez on 4/19/11.
//  Copyright 2011 Little Mustard LLC. All rights reserved.
*/

#import <UIKit/UIKit.h>

@interface LMErrorKitExample_iOSViewController : UIViewController {
    UITextView *_textView;
}

- (IBAction)runTests:(id)sender;


@property (nonatomic, retain) IBOutlet UITextView *textView;

@end
