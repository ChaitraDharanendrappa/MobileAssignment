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
    
}

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *lastSubmittedTime;


-(IBAction)submit:(id)sender;
    

@end
