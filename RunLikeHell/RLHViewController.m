//
//  RLHViewController.m
//  RunLikeHell
//
//  Created by Kris Fields on 8/16/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import "RLHViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface RLHViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIView *rlhView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *totCalOutlet;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (nonatomic) double totalCalories;
@property (nonatomic) int safetyCounter;
@property (weak, nonatomic) IBOutlet UILabel *minuteMile;
@property (nonatomic) BOOL isUpdating;
@end

@implementation RLHViewController
@synthesize startStopButton;
@synthesize minuteMile;
@synthesize rlhView;
@synthesize totCalOutlet;

- (IBAction)startStopAction:(id)sender {
    if (self.isUpdating) {
        [self.locationManager stopUpdatingLocation];
        [startStopButton setBackgroundColor:[UIColor colorWithHue:.5 saturation:1 brightness:1 alpha:1]];
        [startStopButton setHighlighted:YES];
        [startStopButton setTitle:@"|| Pause" forState:UIControlStateNormal];
        self.isUpdating = NO;
    }
    else {
        [self.locationManager startUpdatingLocation];
        [startStopButton setBackgroundColor:[UIColor colorWithHue:1 saturation:1 brightness:1 alpha:1]];
        [startStopButton setHighlighted:YES];
        [startStopButton setTitle:@"> Start" forState:UIControlStateNormal];
        self.isUpdating = YES;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;

    self.totalCalories = 0.0;
    self.safetyCounter = 0;
    NSLog(@"Total Calories is %f", self.totalCalories);
    [startStopButton setTitle:@"> Start" forState:UIControlStateNormal];
  //  [self.locationManager startUpdatingLocation];

//    self.currentLocation = locationManager.location.coordinate;
//    self.altitude = locationManager.location.altitude;
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation.horizontalAccuracy > 10 || newLocation.horizontalAccuracy <= 0) {
        return;
    }
    
    double oldAltitude = oldLocation.altitude;
    double currentAltitude = newLocation.altitude;    
    double metersTraveled = [newLocation distanceFromLocation:oldLocation]; 

    double grade = (fabs((currentAltitude - oldAltitude)) / metersTraveled);
    if (isnan(grade) || isinf(grade)) {
        grade = 0;
    }
    if  (isnan(metersTraveled)){
        metersTraveled = 0;
    }
    double timeDifference = [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
    if (timeDifference <= 0 || isnan(timeDifference) || isinf(timeDifference)) {
        return;
    }
    
    double metersPerMinute = (metersTraveled / timeDifference) * 60;
    double milesPerHour = (1/26.8224) * metersPerMinute;
    double milesPerMinute = milesPerHour / 60;
    double minutesPerMile = 1/milesPerMinute;
    if (isnan(minutesPerMile) || isinf(minutesPerMile)) {
        minutesPerMile = 0;
    }
    

    double VO = (3.5 + ((metersPerMinute * 0.2) + (metersPerMinute * grade * 0.9)));
    double METS = VO / 3.5;
    
    double caloriesPerHour = METS *(_userWeight * 0.453592);
    
    double caloriesPerSecond = ((caloriesPerHour / 60) / 60);
    
    
    self.totalCalories += (timeDifference * caloriesPerSecond);
    self.totCalOutlet.text = [NSString stringWithFormat:@"%d", (int) self.totalCalories];
    self.minuteMile.text = [NSString stringWithFormat:@"%0.1f", minutesPerMile];
    
   
    
    NSLog(@"oldAltitude is %f", oldAltitude);
    NSLog(@"currentAltitude is %f", currentAltitude);
    NSLog(@"meters Traveled is %f", metersTraveled);
    NSLog(@"grade is %f",grade);
    NSLog(@"time difference is %f", timeDifference);
    NSLog(@"meters per minute is %f", metersPerMinute);

    NSLog(@"Cals per second is %f", caloriesPerSecond);
    NSLog(@"Total Calories is %f", _totalCalories);
    NSLog(@"timeDifference * calroiesPerSecond = %f", timeDifference * caloriesPerSecond);
    NSLog(@"ENDING THIS ROUND");

    
}

- (void)viewDidUnload
{
    [self setTotCalOutlet:nil];
    [self setRlhView:nil];
    [self setMinuteMile:nil];
    [self setStartStopButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
