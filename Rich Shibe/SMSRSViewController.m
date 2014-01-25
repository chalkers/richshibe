//
//  SMSRSViewController.m
//  Rich Shibe
//
//  Created by Andrew Chalkley on 24/12/2013.
//  Copyright (c) 2013 Secret Monkey Science. All rights reserved.
//

#import "SMSRSViewController.h"
#import "NSUserDefaults+GroundControl.h"
#import "MHPrettyDate.h"

@interface SMSRSViewController ()
@property (nonatomic, strong) NSTimer * viewTimer;
@property (nonatomic, strong) NSTimer * serverTimer;

@end

@implementation SMSRSViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"amountOfDoge"] isKindOfClass:[NSString class]]) {
        _dogeAmount.text =[[NSUserDefaults standardUserDefaults] stringForKey:@"amountOfDoge"];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] isKindOfClass:[NSNumber class]]) {
        _currencySelector.selectedSegmentIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] integerValue];
    }
    _viewTimer = [NSTimer scheduledTimerWithTimeInterval:61.f target:self selector:@selector(updatePriceInView) userInfo:nil repeats:YES];
    _serverTimer = [NSTimer scheduledTimerWithTimeInterval:300.f target:self selector:@selector(getUpdateFromServer) userInfo:nil repeats:YES];

    _phraseLabel.userInteractionEnabled = NO;
    
    [self updatePriceInView];
    [self getUpdateFromServer];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) viewDidAppear:(BOOL)animated {
    if (!animated) {
        [self randomPhrase];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender {
    [_dogeAmount resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setObject:_dogeAmount.text forKey:@"amountOfDoge"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updatePriceInView];
}

- (IBAction)currencyChanged:(id)sender {
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        NSDictionary * doge_btc = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"doge_btc"];
        NSDictionary * btc_usd = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"btc_usd"];
        
        float btc_per_doge = [[[doge_btc objectForKey:@"average"] objectForKey:@"price" ] floatValue];
        float usd_per_btc = [[[btc_usd objectForKey:@"average"] objectForKey:@"price" ] floatValue];
        UISegmentedControl *seg = sender;
        NSNumber * selectedIndex = [NSNumber numberWithLong:seg.selectedSegmentIndex];
        [[NSUserDefaults standardUserDefaults] setObject:selectedIndex forKey:@"selectedIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if(seg.selectedSegmentIndex == 0) {
            _coversion.text = [NSString stringWithFormat:@"%.8f", [_dogeAmount.text intValue] * btc_per_doge * usd_per_btc
                               ];
        } else {
            _coversion.text = [NSString stringWithFormat:@"%.8f", [_dogeAmount.text intValue] * btc_per_doge];
        }
    }
}

-(void)updatePriceInView {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdated"] isKindOfClass:[NSDate class]]) {
        NSDate * d = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdated"];
        _lastUpdated.text = [NSString stringWithFormat:@"Last Updated : %@", [MHPrettyDate prettyDateFromDate:d withFormat:MHPrettyDateLongRelativeTime] ];
    }

    [self currencyChanged:_currencySelector];
}
-(void)randomPhrase {
    NSArray *phrases = @[@"such currency", @"wow", @"amaze", @"much coin", @"awesome", @"so crypto", @"how money", @"plz mine", @"v rich", @"many coins", @"such profit", @"WOW", @"so stable", @"to the moon", @"┗(°0°)┛", @"very scrypt"];
    
    int r = arc4random() % [phrases count];
    
    _phraseLabel.text = [phrases objectAtIndex:r];
    [_phraseLabel sizeToFit];
    float padding = 20;
    _phraseLabel.frame = CGRectMake(padding + arc4random_uniform(self.view.frame.size.width - padding - _phraseLabel.frame.size.width) , padding + arc4random_uniform(self.view.frame.size.height - padding - _phraseLabel.frame.size.height), _phraseLabel.frame.size.width, _phraseLabel.frame.size.height);
    
    [UIView animateWithDuration:0.5 animations:^{
        float red = arc4random_uniform(255) / 255.0;
        float green = arc4random_uniform(255) / 255.0;
        float blue = arc4random_uniform(255) / 255.0;
        _phraseLabel.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        _phraseLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hidePhrase) withObject:nil afterDelay:2];
    }];
}

-(void) hidePhrase {
    [UIView animateWithDuration:0.5 animations:^{
        _phraseLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(randomPhrase) withObject:nil afterDelay:1];
    }];
}

-(void)getUpdateFromServer {
    NSURL *URL = [NSURL URLWithString:@"http://api.richshibe.org/defaults.plist"];
    [[NSUserDefaults standardUserDefaults] registerDefaultsWithURL:URL success:^(NSDictionary *defaults) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastUpdated"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self updatePriceInView];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];

}
@end
