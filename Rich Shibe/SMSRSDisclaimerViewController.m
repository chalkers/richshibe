//
//  SMSRSDisclaimerViewController.m
//  Rich Shibe
//
//  Created by Andrew Chalkley on 23/01/2014.
//  Copyright (c) 2014 Secret Monkey Science. All rights reserved.
//

#import "SMSRSDisclaimerViewController.h"

@interface SMSRSDisclaimerViewController ()

@end

@implementation SMSRSDisclaimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
