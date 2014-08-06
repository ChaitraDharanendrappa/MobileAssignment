//
//  ViewController.h
//  MobileAssignment
//
//  Created by cdharane on 05/08/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate, UITextFieldDelegate>
{
    CLLocationManager *locationManager;
    NSString *longitude, *latitude;
    
    
}

@property (weak, nonatomic) IBOutlet UITextField *name;   // attribute to display user name
@property (weak, nonatomic) IBOutlet UILabel *location;     // attribute to display location coordinates
@property (weak, nonatomic) IBOutlet UILabel *lastSubmittedTime;  // attribute to display last submitted time


-(IBAction)submit:(id)sender;
    

@end
