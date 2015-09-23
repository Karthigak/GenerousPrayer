//
//  MapViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 14/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "MapViewController.h"
#import "Constants.h"
@interface MapViewController ()
{
    
    UIImageView *searchIcon;
    UITextField *textField;
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBox;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController
@synthesize mapView,searchBox;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
   // [searchBox setBackgroundImage:[UIImage new]];
    [UITextField appearanceWhenContainedIn:[UISearchBar class], nil].leftView = nil;

       [self preLoad];
    
    [self setSearchIconToFavicon];

}
-(void)setSearchIconToFavicon
{
    searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbaricon.png"]];
    searchBox.backgroundImage = [UIImage new];
    textField = [searchBox valueForKey: @"_searchField"];
    if(textField){
        textField.frame = CGRectMake(textField.frame.origin.x,textField.frame.origin.y, textField.frame.size.width, 70);
        [textField setLeftViewMode:UITextFieldViewModeNever];
        [textField setRightViewMode:UITextFieldViewModeNever];
        
        UIInterfaceOrientation orientation = self.interfaceOrientation;
        if(orientation == UIInterfaceOrientationPortrait){
            if (isiPad) {
                // searchIcon.frame = CGRectMake(950, 4, 19, 19);
                searchIcon.frame = CGRectMake(680, 4, 19, 19);
                
            }else{
                if(IS_IPHONE_5){
                    searchIcon.frame = CGRectMake(245, 4, 19, 19);
                }else if (IS_IPHONE_6){
                    searchIcon.frame = CGRectMake(300, 4, 19, 19);
                }else if (IS_IPHONE_6_PLUS){
                    searchIcon.frame = CGRectMake(340, 4, 19, 19);
                }
            }
            
        }
        else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
            if (isiPad) {
                // searchIcon.frame = CGRectMake(950, 4, 19, 19);
                searchIcon.frame = CGRectMake(950, 4, 19, 19);
                
            }else{
                if(IS_IPHONE_5){
                    searchIcon.frame = CGRectMake(245, 4, 19, 19);
                }else if (IS_IPHONE_6){
                    searchIcon.frame = CGRectMake(300, 4, 19, 19);
                }else if (IS_IPHONE_6_PLUS){
                    searchIcon.frame = CGRectMake(340, 4, 19, 19);
                }
            }
            
        }
        
        textField.clearButtonMode=UITextFieldViewModeNever;
        [textField addSubview:searchIcon];
        [textField setFont:[UIFont fontWithName:@"Myriad Pro" size:15.0]];
        
    }
    
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
    {
        NSLog(@"Lanscapse");
        searchIcon.frame = CGRectMake(950, 4, 19, 19);
        
        [textField addSubview:searchIcon];
        
    }
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
    {
        NSLog(@"UIDeviceOrientationPortrait");
        //            searchIcon.frame = CGRectMake(600, 4, 19, 19);
        //            [textField addSubview:searchIcon];
        searchIcon.frame = CGRectMake(680, 4, 19, 19);
        
        [textField addSubview:searchIcon];
        
    }
    
    
    
}


-(void)preLoad
{
    self.mapView.delegate=self;
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
     self.mapView.showsUserLocation=YES;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }

    

}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
        
        
    }
    CLLocation *newLocations = [[CLLocation alloc] initWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
    MKPointAnnotation *provider = [[MKPointAnnotation alloc] init];
    provider.coordinate = CLLocationCoordinate2DMake(newLocations.coordinate.latitude, newLocations.coordinate.longitude);
    provider.title = @"Sharon AG Chruch";
    [self.mapView addAnnotation:provider];
    [locationManager stopUpdatingLocation];
    
    // Stop Location Manager
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:  (CLAuthorizationStatus)status
{
    //[self gotoCurrenLocation];
    [locationManager startUpdatingLocation];
}
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    [self zoomToFitMapAnnotations:self.mapView];
}
- (void)zoomToFitMapAnnotations:(MKMapView *)mapViews {
    
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,1500,1500);
    region = [mapViews regionThatFits:region];
    [mapViews setRegion:region animated:YES];
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    //Get the east and west points on the map so we calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set our current distance instance variable.
    int distance = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    NSLog(@"%d",distance);
    //Set our current centre point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *pinView = nil;
    
    static NSString *defaultPinID = @"com.invasivecode.pin";
    pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil )
        pinView = [[MKAnnotationView alloc]
                   initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    
    pinView.canShowCallout = YES;

    pinView.canShowCallout = YES;
    //pinView.animatesDrop = YES;
    pinView.image = [UIImage imageNamed:@"location.png"];
  //  pinView.leftCalloutAccessoryView = lblTitolo;
    return pinView;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view  endEditing:YES];
}

@end
