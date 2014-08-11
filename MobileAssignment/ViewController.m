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
    
    double timeStamp;
    
    NSTimer *timer;
    
}

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
    
    [self resetTime];
    

    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(timerController)
                                           userInfo:nil
                                            repeats:YES];
    

    
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
    [self resetTime];
   
    NSString *info  = [NSString stringWithFormat:@"%@ is now at %@/%@", name.text, latitude,longitude];
    
   // NSString *URLString = @"http://gentle-tor-1851.herokuapp.com/events";
   
    NSDictionary *parameters = @{@"data": info};
    
   /* NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.credential = [NSURLCredential credentialWithUser:@"chaitra" password:@"lumbergh21" persistence:NSURLCredentialPersistencePermanent];
   // operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    operation.responseStringEncoding = @"application/x-www-form-urlencoded";
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Status code is %ld", (long)operation.response.statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
    
    [[NSUserDefaults standardUserDefaults] setObject:name.text forKey:@"kUserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    */
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://gentle-tor-1851.herokuapp.com/events"]]];
    
    operation.credential = [NSURLCredential credentialWithUser:@"chaitra" password:@"lumbergh21" persistence:NSURLCredentialPersistencePermanent];

    [manager POST:@"http://gentle-tor-1851.herokuapp.com/events" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Status code is %ld", (long)operation.response.statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
 }



-(NSTimeInterval)getCurrentTime
{
    
    NSTimeInterval currentSecond = [[NSDate date]timeIntervalSince1970];
    
    return currentSecond;
}


-(void)resetTime
{
    
    timeStamp = [self getCurrentTime];
}


- (void)timerController {
    
    double tempTime = [self getCurrentTime] - timeStamp;
    
    lastSubmittedTime.text = [NSString stringWithFormat:@"%.0f sec ago", tempTime];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [timer invalidate];
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
