//
//  SMSRSViewController.h
//  Rich Shibe
//
//  Created by Andrew Chalkley on 24/12/2013.
//  Copyright (c) 2013 Secret Monkey Science. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSRSViewController : UIViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *dogeAmount;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecogniser;
- (IBAction)currencyChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *coversion;
@property (weak, nonatomic) IBOutlet UISegmentedControl *currencySelector;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdated;
@property (weak, nonatomic) IBOutlet UILabel *phraseLabel;

@end
