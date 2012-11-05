//
//  DetailViewController.m
//  Shodan
//
//  Created by Erran Carey on 5/6/12.
//  Copyright (c) 2012 App2O. All rights reserved.
//

#import "AppSpecificValues.h"
#import "BannerViewController.h"
#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController
@synthesize bannerIsVisible = _bannerIsVisible;
@synthesize adBannerView = _adBannerView;
@synthesize ip;
@synthesize country_code;
@synthesize searched;
@synthesize longlat;
@synthesize total;
@synthesize locations;
@synthesize city;
@synthesize initial;
@synthesize updated;
@synthesize longitude;
@synthesize dataLabel;
@synthesize pin;
@synthesize latitude;
@synthesize hostnames;
@synthesize country_name;
@synthesize data;
@synthesize port;
@synthesize ipLabel;
@synthesize coordinate;
@synthesize computerDictionary;
@synthesize matches;
@synthesize cityLabel;
@synthesize flag;
@synthesize updatedLabel;
@synthesize detailItem = _detailItem;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize latString;
@synthesize longString;
@synthesize mapView;
@synthesize scroll;
@synthesize signup;
@synthesize tour;

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willBeginBannerViewActionNotification:) name:BannerViewActionWillBegin object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishBannerViewActionNotification:) name:BannerViewActionDidFinish object:nil];
    }
    return self;
}
- (void)dealloc{
    [_detailItem release];
    [_adBannerView release];
    [super dealloc];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    if(!self.bannerIsVisible){
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        self.adBannerView.frame = CGRectOffset(self.adBannerView.frame, 0.0, 50.0);
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    if (self.bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        self.adBannerView.frame = CGRectOffset(self.adBannerView.frame, 0.0, -50.0);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    else if(toInterfaceOrientation!=UIInterfaceOrientationPortraitUpsideDown){
        self.adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    }
}
-(IBAction)openip{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",ip]]];
}

-(IBAction)openlonglat{
    NSString *link = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@,%@",latitude,longitude];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}
-(IBAction)openShodan:(id)sender{
    UIButton* button = sender;
    if (button.tag == 1) {
        NSString *link = @"http://www.shodanhq.com/help/tour";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
    }
    else if (button.tag == 2) {
        NSString *link = @"http://www.shodanhq.com/account/register";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
    }
}
-(void)hide{
    [ipLabel setHidden:YES];
    [longlat setHidden:YES];
    [flag setHidden:YES];
    [dataLabel setHidden:YES];
    [updatedLabel setHidden:YES];
}
-(void)show{
    [ipLabel setHidden:NO];
    [longlat setHidden:NO];
    [flag setHidden:NO];
    [dataLabel setHidden:NO];
    [updatedLabel setHidden:NO];
}
- (void)configureView{
    NSString* model = [NSString stringWithFormat:@"%@",[UIDevice currentDevice].model];
    if ([model isEqualToString:@"iPad"]){
        [ipLabel setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [ipLabel setTitleColor:[UIColor redColor]forState:UIControlStateHighlighted];
        [longlat setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [longlat setTitleColor:[UIColor redColor]forState:UIControlStateHighlighted];
    }
    else {
        [ipLabel setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        [ipLabel setTitleColor:[UIColor blueColor]forState:UIControlStateHighlighted];
        [longlat setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        [longlat setTitleColor:[UIColor blueColor]forState:UIControlStateHighlighted];

    }
    if (self.detailItem) {
        [self show];
        self.navigationItem.title = [NSString stringWithFormat:@"%@",ip];
        [ipLabel setTitle:[NSString stringWithFormat:@"%@",ip] forState:UIControlStateNormal];        
        [ipLabel setTitle:[NSString stringWithFormat:@"%@",ip] forState:UIControlStateHighlighted];
        longlat.titleLabel.adjustsFontSizeToFitWidth = YES;
        if (longitude && latitude) {
            [longlat setEnabled:YES];
        }
        else {
            [longlat setEnabled:NO];
        }
        dataLabel.text = data;
        updatedLabel.text = [NSString stringWithFormat:@"Added on %@",updated];
    
        [self changeLocation];
        flag.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",country_code]];
    }
    else {
        [self hide];
    }
}        
-(void)changeLocation{
    @try{
        /*
         if ((city && country_name) && (![city isEqual:[NSNull null]] && ![country_name isEqual:[NSNull null]])) {
         cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",city,country_name];
         }
         else if ((city && country_code) && (![city isEqual:[NSNull null]] && ![country_code isEqual:[NSNull null]])) {
         cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",city,country_code];
         }
         else if (country_name && ![country_name isEqual:[NSNull null]]) {
         cell.detailTextLabel.text = country_name;
         }
         else if (country_code && ![country_code isEqual:[NSNull null]]) {
         cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",country_code];
         }
         else if (city && ![city isEqual:[NSNull null]]) {
         cell.detailTextLabel.text = city;
         }
         if (city != NULL && [country_name isEqual:@"Korea, Republic of"]) {
         cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, South Korea",city];
         }
         else if (city != NULL && [country_name isEqual:@"Tanzania, United Republic of"]) {
         cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, Tanzania",city];        
         }
         else if (city != NULL && [country_name isEqual:@"Iran, Islamic Republic of"]) {
         cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, Iran",city];        
         }
         else if ([country_name isEqual:@"Korea, Republic of"]) {
         cell.detailTextLabel.text = @"South Korea";
         }
         else if ([country_name isEqual:@"Tanzania, United Republic of"]) {
         cell.detailTextLabel.text = @"Tanzania";        
         }
         else if ([country_name isEqual:@"Iran, Islamic Republic of"]) {
         cell.detailTextLabel.text = @"Iran";        
         }
         if (!cell.detailTextLabel.text || cell.detailTextLabel.text == @""){
         cell.detailTextLabel.text = @"Unknown";
         }
         */
        if ((city && country_name) && (![city isEqual:[NSNull null]] && ![country_name isEqual:[NSNull null]])) {
            [longlat setTitle:[NSString stringWithFormat:@"%@, %@",city,country_name] forState:UIControlStateNormal];        
            [longlat setTitle:[NSString stringWithFormat:@"%@, %@",city,country_name] forState:UIControlStateHighlighted];        
        }
        else if ((city && country_code) && (![city isEqual:[NSNull null]] && ![country_code isEqual:[NSNull null]])) {
            [longlat setTitle:[NSString stringWithFormat:@"%@,%@",city,country_code] forState:UIControlStateNormal];        
            [longlat setTitle:[NSString stringWithFormat:@"%@,%@",city,country_code] forState:UIControlStateHighlighted];        
        }
        else if (country_name && ![country_name isEqual:[NSNull null]]) {
            [longlat setTitle:[NSString stringWithFormat:@"%@",country_name] forState:UIControlStateNormal];
            [longlat setTitle:[NSString stringWithFormat:@"%@",country_name] forState:UIControlStateHighlighted];        
        }
        else if (country_code && ![country_code isEqual:[NSNull null]]) {
            [longlat setTitle:[NSString stringWithFormat:@"%@",country_code] forState:UIControlStateNormal];        
            [longlat setTitle:[NSString stringWithFormat:@"%@",country_code] forState:UIControlStateHighlighted];        
        }
        else if (city && ![city isEqual:[NSNull null]]) {
            [longlat setTitle:[NSString stringWithFormat:@"%@",city] forState:UIControlStateNormal];        
            [longlat setTitle:[NSString stringWithFormat:@"%@",city] forState:UIControlStateHighlighted];        
        }
        else {
            [longlat setTitle:@"Unknown" forState:UIControlStateNormal];
            [longlat setTitle:@"Unknown" forState:UIControlStateHighlighted];
        }
        if (city != NULL && [country_name isEqual:@"Korea, Republic of"]) {
            [longlat setTitle:[NSString stringWithFormat:@"%@, South Korea",city] forState:UIControlStateNormal];
            [longlat setTitle:[NSString stringWithFormat:@"%@, South Korea",city] forState:UIControlStateHighlighted];        
        }
        else if (city != NULL && [country_name isEqual:@"Tanzania, United Republic of"]) {
            [longlat setTitle:[NSString stringWithFormat:@"%@, Tanzania",city] forState:UIControlStateNormal];        
            [longlat setTitle:[NSString stringWithFormat:@"%@, Tanzania",city] forState:UIControlStateHighlighted];        
        }
        else if (city != NULL && [country_name isEqual:@"Iran, Islamic Republic of"]) {
            [longlat setTitle:[NSString stringWithFormat:@"%@, Iran",city] forState:UIControlStateNormal];        
            [longlat setTitle:[NSString stringWithFormat:@"%@, Iran",city] forState:UIControlStateHighlighted];        
        }
        else if ([country_name isEqual:@"Korea, Republic of"]) {
            [longlat setTitle:@"South Korea" forState:UIControlStateNormal];        
            [longlat setTitle:@"South Korea" forState:UIControlStateHighlighted];        
        }
        else if ([country_name isEqual:@"Tanzania, United Republic of"]) {
            [longlat setTitle:@"Tanzania" forState:UIControlStateNormal];        
            [longlat setTitle:@"Tanzania" forState:UIControlStateHighlighted];        
        }
        else if ([country_name isEqual:@"Iran, Islamic Republic of"]) {
            [longlat setTitle:[NSString stringWithFormat:@"Iran"] forState:UIControlStateNormal];        
            [longlat setTitle:[NSString stringWithFormat:@"Iran"] forState:UIControlStateHighlighted];        
        }
    }
    @catch (NSException* e) {
        NSLog(@"%@",e);
    }
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.bannerIsVisible = YES;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];    
    UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        if (interfaceOrientation!=UIInterfaceOrientationPortraitUpsideDown) {
            [scroll setScrollEnabled:NO];
        }
        [scroll setContentSize:CGSizeMake(320,480)];
        self.adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    }
    else if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        [scroll setScrollEnabled:YES];
        [scroll setContentSize:CGSizeMake(480,398)];
        self.adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    [self configureView];
}

-(void)receivedRotate:(NSNotification*)notification{
    NSString* model = [NSString stringWithFormat:@"%@",[UIDevice currentDevice].model];
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation) && ![model isEqualToString:@"iPad"]){
        [scroll setContentOffset:CGPointMake(0.0,0.0) animated:NO];
        [scroll setContentSize:CGSizeMake(320, 480)];
        if (self.interfaceOrientation!=UIInterfaceOrientationPortraitUpsideDown){
            [scroll setScrollEnabled:NO];
        }
 	}
    else if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && ![model isEqualToString:@"iPad"]) {
        [scroll setContentSize:CGSizeMake(480, 398)];
        [scroll setScrollEnabled:YES];
 	}
}

- (void)setDetailItem:(id)newDetailItem{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController{
    barButtonItem.title = @"Search Shodan";
    UIBarButtonItem* barb = [[[UIBarButtonItem alloc]initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(showSettingsPush)]autorelease];
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    [self.navigationItem setRightBarButtonItem:barb animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    NSString* model = [NSString stringWithFormat:@"%@",[UIDevice currentDevice].model];
    if ([model isEqualToString:@"iPad"]){
        return (UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationPortrait|UIInterfaceOrientationPortraitUpsideDown);
    }
    else {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
}

@end