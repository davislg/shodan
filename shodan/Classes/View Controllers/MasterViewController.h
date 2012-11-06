//
//  MasterViewController.h
//  Shodan
//
//  Created by Erran Carey on 5/6/12.
//  Copyright (c) 2012 App2O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"

@class DetailViewController;
@interface MasterViewController : UITableViewController<UIAlertViewDelegate, UISearchBarDelegate, CMPopTipViewDelegate>{
	DetailViewController* _detailViewController;
}

@property (strong, nonatomic) DetailViewController* detailViewController;

@property (strong, nonatomic) NSString *apiKey;
@property (strong, nonatomic) NSString *substApiKey;
@property (strong, nonatomic) NSString *func;
@property (strong, nonatomic) NSString *args;
@property (strong, nonatomic) NSString *ip;
@property (strong, nonatomic) NSString *country_code;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *updated;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *hostnames;
@property (strong, nonatomic) NSString *country_name;
@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *locationType;
@property (strong, nonatomic) NSString *port;
@property (strong, nonatomic) NSString *errorMsg;
@property (strong, nonatomic) NSString *searched;

@property (nonatomic, retain) NSArray	*colorSchemes;
@property (nonatomic, retain) NSDictionary *contents;

@property (strong, nonatomic) NSMutableArray *matches;
@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) NSMutableArray *scopeTitles;

@property (strong, nonatomic) NSNumber *total;

@property (strong, nonatomic) NSString *credits;
@property (strong, nonatomic) NSString *telnet;
@property (strong, nonatomic) NSString *plan;
@property (strong, nonatomic) NSString *https;
@property (strong, nonatomic) NSString *unlocked;

@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSURL *baseUrl;

@property (strong, nonatomic) NSDictionary *computerDictionary;

@property int index;
@property int page;

@property (strong, nonatomic) IBOutlet UIView *infoView;

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *visiblePopTipViews;
@property (nonatomic, retain) id currentPopTipViewTarget;

-(void)callAlert;
-(void)queryAPI;
-(void)searchShodan;
- (void)showInfo:(id)sender;

@end