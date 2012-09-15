//
//  RLHWeightInputViewController.m
//  RunLikeHell
//
//  Created by Kris Fields on 8/16/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import "RLHWeightInputViewController.h"
#import "RLHViewController.h"

@interface RLHWeightInputViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *weightInputField;

@end

@implementation RLHWeightInputViewController
@synthesize weightInputField;

- (IBAction)submitWeightInput:(id)sender {
    RLHViewController *rlh = [[RLHViewController alloc]init];
    rlh.userWeight = [weightInputField.text doubleValue];
//    [weightInputField resignFirstResponder];
    [self.navigationController pushViewController:rlh animated:YES];
}

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
    [weightInputField becomeFirstResponder];
    self.title = @"Enter weight";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setWeightInputField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
