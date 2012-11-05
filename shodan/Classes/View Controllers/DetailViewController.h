//
//  DetailViewController.h
//  Shodan
//
//  Created by Erran Carey on 5/6/12.
//  Copyright (c) 2012 App2O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <iAD/iAD.h>

@interface DetailViewController : UIViewController<CLLocationManagerDelegate,MKAnnotation,MKMapViewDelegate,ADBannerViewDelegate,UISplitViewControllerDelegate>{
    BOOL _bannerIsVisible;
    ADBannerView* _adBannerView;
}

@property BOOL bannerIsVisible;
@property (strong, nonatomic) IBOutlet ADBannerView* adBannerView;

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@property (strong, nonatomic) NSString *ip;
@property (strong, nonatomic) NSString *country_code;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *searched;
@property (strong, nonatomic) NSString *updated;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *hostnames;
@property (strong, nonatomic) NSString *country_name;
@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *port;
@property (strong, nonatomic) NSString *latString;
@property (strong, nonatomic) NSString *longString;

@property (strong, nonatomic) NSArray *matches;
@property (strong, nonatomic) NSArray *locations;
@property (strong, nonatomic) NSArray *total;

@property (strong, nonatomic) NSDictionary *computerDictionary;

@property (strong, nonatomic) MKPointAnnotation *pin;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;


@property (strong, nonatomic) IBOutlet UIButton *ipLabel;
@property (strong, nonatomic) IBOutlet UIButton *longlat;
@property (strong, nonatomic) IBOutlet UIButton *tour;
@property (strong, nonatomic) IBOutlet UIButton *signup;

@property (strong, nonatomic) IBOutlet UIImageView *flag;
@property (strong, nonatomic) IBOutlet UIImageView *initial;

@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *updatedLabel;

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@property (strong, nonatomic) IBOutlet UITextView *dataLabel;

-(IBAction)openip;
-(IBAction)openlonglat;
-(IBAction)openShodan:(id)sender;
@end