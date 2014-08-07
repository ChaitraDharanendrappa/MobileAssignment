//
//  ViewController.m
//  MobileAssignment
//
//  Created by cdharane on 05/08/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"


@interface ViewController ()
{
    NSString *longitude, *latitude;
}

-(void)showSubmitTime;

@end

@implementation ViewController

@synthesize name;
@synthesize location;
@synthesize lastSubmittedTime;


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submit:) name:@"DidSubmitDataNotification" object:nil];
        
    }
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    /* retrieving name and location on load */
    
    if([standardDefaults stringForKey:@"kUserName"]==nil)
    {
        name.text=@"John Doe";
    }
    else
    {
        name.text = [standardDefaults stringForKey:@"kUserName"];
    }
    
    name.delegate=self;
    
    /* rerieve last submitted time on load */
    
    lastSubmittedTime.text = [NSString stringWithFormat:@"%d sec ago",[standardDefaults integerForKey:@"kLastAccessedTime"]];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /* initializing location manager */
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
}





-(IBAction)submit:(id)sender
{
    
    NSString *info  = [NSString stringWithFormat:@"%@ is now at %@/%@", name.text, latitude,longitude];
    
    NSString *URLString = @"http://gentle-tor-1851.herokuapp.com/events";
    NSDictionary *parameters = @{@"data": info};
    
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.credential = [NSURLCredential credentialWithUser:@"chaitra" password:@"lumbergh21" persistence:NSURLCredentialPersistencePermanent];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Status code is %d", operation.response.statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
    
    [self showSubmitTime];
    
    /* saving user name on submit */
    
    [[NSUserDefaults standardUserDefaults] setObject:name.text forKey:@"kUserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


-(void)showSubmitTime
{
    
    int submitCount, tempTime, tempTime1=0;
    
    tempTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"kLastAccessedTime"];
    
    /* Set up the properties for the integer and default */
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    submitCount = [defaults integerForKey:@"hasSubmitted"] + 1;
    [defaults setInteger:submitCount forKey:@"hasSubmitted"];
    [defaults synchronize];
    
    NSLog(@"This application has been submitted %d amount of times", submitCount);
    
    /* getting current time in seconds */
    
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components =
    [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:today];
    
    NSInteger currentSecond = [components second];
    
    tempTime1 = currentSecond + tempTime;
    
    if(submitCount == 1)
    {
        lastSubmittedTime.text = [NSString stringWithFormat:@"%d sec ago", tempTime1];
    }
    
    if(submitCount >= 2) {
        
        if(tempTime1 > 60)
        {
            lastSubmittedTime.text = [NSString stringWithFormat:@"%d min ago",((tempTime1 / 60) % 60)];
        }
        else{
            lastSubmittedTime.text = [NSString stringWithFormat:@"%d sec ago",tempTime1];
        }
        
    }
    [defaults setInteger:tempTime1 forKey:@"kLastAccessedTime"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma - mark CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        location.text = [NSString stringWithFormat:@"%@, %@",latitude,longitude];
        
        NSLog(@"location is %@", location.text);
        
        [locationManager stopUpdatingLocation];
        [locationManager setDelegate:nil];
        
    }
    
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    location.text = @"Error";
    
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
}




#pragma - mark TextField Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [name resignFirstResponder];
    return YES;
}






@end
