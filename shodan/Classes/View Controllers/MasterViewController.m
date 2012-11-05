//
//  MasterViewController.m
//  Shodan
//
//  Created by Erran Carey on 5/6/12.
//  Copyright (c) 2012 App2O. All rights reserved.
//

#import "api.h"
#import "AppSpecificValues.h"
#import "DetailViewController.h"
#import "MasterViewController.h"

@implementation MasterViewController
@synthesize credits;
@synthesize telnet;
@synthesize plan;
@synthesize https;
@synthesize unlocked;
@synthesize page;
@synthesize colorSchemes;
@synthesize contents;
@synthesize baseUrl;
@synthesize detailViewController = _detailViewController;
@synthesize apiKey;
@synthesize currentPopTipViewTarget;
@synthesize locationType;
@synthesize urlString;
@synthesize url;
@synthesize func;
@synthesize errorMsg;
@synthesize visiblePopTipViews; 
@synthesize args;
@synthesize searchBar;
@synthesize backButton;
@synthesize locations;
@synthesize infoView;
@synthesize total;
@synthesize forwardButton;
@synthesize index;
@synthesize computerDictionary;
@synthesize ip;
@synthesize searched;
@synthesize country_code;
@synthesize city;
@synthesize updated;
@synthesize longitude;
@synthesize latitude;
@synthesize hostnames;
@synthesize country_name;
@synthesize data;
@synthesize port;
@synthesize matches;
@synthesize scopeTitles;

-(void)loadAPIURL{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.apiKey = [[defaults objectForKey:kapiKey]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!apiKey){
        self.apiKey = @"ueZLMDjY4xBU5DbhR76ROvOEQP7Vj8FO";
    	[defaults setObject:apiKey forKey:kapiKey];
        [defaults synchronize];
	}
    self.baseUrl = [NSURL URLWithString:@"http://www.shodanhq.com/api/"];
	self.func = @"info";
}
-(void)loadURL{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.apiKey = [[defaults objectForKey:kapiKey]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!apiKey){
        self.apiKey = @"ueZLMDjY4xBU5DbhR76ROvOEQP7Vj8FO";
    	[defaults setObject:apiKey forKey:kapiKey];
        [defaults synchronize];
	}
    self.baseUrl = [NSURL URLWithString:@"http://www.shodanhq.com/api/"];
	self.func = @"search";
}

-(void)searchShodan{
    [self loadURL];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    WebAPI* api = [[[WebAPI alloc]init_with_api_key:apiKey]autorelease];
    [api search:args];
    NSDictionary *json = api.result;
    self.matches = [json objectForKey:@"matches"];
    
    if ([args rangeOfString:@"country:"].location == NSNotFound && !([[[json objectForKey:@"countries"]objectAtIndex:0]objectForKey:@"count"] == [json objectForKey:@"total"])){
        self.locations = [json objectForKey:@"countries"];
        self.locationType = NSLocalizedString(@"Top Countries:\n", @"The top countries found.");
    }
    else {
        self.locations = [json objectForKey:@"cities"];
        self.locationType = NSLocalizedString(@"Top Cities:\n", @"The top cities found.");
    }
    self.total = [json objectForKey:@"total"];
    self.errorMsg = [json objectForKey:@"error"];
    [self callAlert];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
-(void)queryAPI{
    [self loadAPIURL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    WebAPI* api = [[[WebAPI alloc]init_with_api_key:apiKey]autorelease];
    [api info];
    NSDictionary *json = api.result;
    self.credits = [json objectForKey:@"unlocked_left"];
    self.telnet = [json objectForKey:@"telnet"];
    self.plan = [json objectForKey:@"plan"];
    self.https = [json objectForKey:@"https"];
    self.unlocked = [json objectForKey:@"unlocked"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    switch ([telnet intValue]) {
        case 0:
            self.telnet = NSLocalizedString(@"False", @"Translation of false");
            [defaults setObject:telnet forKey:kTelnet];
            break;
        case 1:
            self.telnet = NSLocalizedString(@"True", @"Translation of true");
            [defaults setObject:telnet forKey:kTelnet];
            break;
    }
    switch ([https intValue]) {
        case 0:
            self.https = NSLocalizedString(@"False", @"Translation of false");
            [defaults setObject:https forKey:kHttps];
            break;
        case 1:
            self.https = NSLocalizedString(@"True", @"Translation of true");
            [defaults setObject:https forKey:kHttps];
            break;
        }
    switch ([unlocked intValue]) {
        case 0:
            self.unlocked = NSLocalizedString(@"False", @"Translation of false");
            [defaults setObject:unlocked forKey:kUnlocked];
            break;
        case 1:
            self.unlocked = NSLocalizedString(@"True", @"Translation of true");
            [defaults setObject:unlocked forKey:kUnlocked];
            break;
    }
    if (plan) {
        self.plan = NSLocalizedString(plan, @"The plan");
    }
    else {
        self.plan = NSLocalizedString(@"Invalid API", @"The plan");
    }
    [defaults setObject:plan forKey:kPlan];
    self.credits = [NSString stringWithFormat:@"%d",[credits intValue]];
    [defaults setObject:credits forKey:kCredits];
    [defaults synchronize];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
-(void)promptForNewAPI{
	UIAlertView* alert = [[[UIAlertView alloc]initWithTitle:@"Quick API Change" message:@"To see more API info go to SHODAN in the Settings app." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Change", nil]autorelease];
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
	alert.tag = 0;
	[alert show];
}
- (void)viewDidLoad{
	[super viewDidLoad];
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.longitude = nil;
    self.latitude = nil;
    self.page = 1;
	self.scopeTitles = [NSArray arrayWithObjects:@"HTTP",@"FTP",@"SSH",@"SNMP",@"SIP",nil];
	self.searchBar.scopeButtonTitles = scopeTitles;
    self.searchBar.selectedScopeButtonIndex = -1;
    
	index = 0;
    UIButton *info = [UIButton buttonWithType:UIButtonTypeInfoLight];
    NSString* model = [NSString stringWithFormat:@"%@",[UIDevice currentDevice].model];
    UIImage* logo = [UIImage imageNamed:@"logo"];
    UIImageView* logoView =[[[UIImageView alloc] initWithImage:logo]autorelease];
    if ([model isEqualToString:@"iPad"]){
        self.navigationItem.titleView = logoView;
    }
    else {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleButton setImage:logo forState:UIControlStateNormal];
        [titleButton setFrame:CGRectMake(0, 0, 84, 20)];
        [titleButton addTarget:self action:@selector(promptForNewAPI) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = titleButton;
    }
    [info addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* infoB = [[[UIBarButtonItem alloc] initWithCustomView:info]autorelease];
    info.tag = 0;
    UIButton *filler = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem* fillerB = [[[UIBarButtonItem alloc] initWithCustomView:filler]autorelease];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:fillerB,infoB,nil];
    
    UIBarButtonItem *stats = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stats"] style:UIBarButtonItemStyleBordered target:self action:@selector(showInfo:)]autorelease];
    self.navigationItem.rightBarButtonItem = stats;
    self.navigationItem.rightBarButtonItem.tag = 1;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];

    [self.tableView setScrollEnabled:NO];

	self.visiblePopTipViews = [NSMutableArray array];
	
	self.contents = [NSDictionary dictionaryWithObjectsAndKeys:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide"]] autorelease], [NSNumber numberWithInt:0], @"", [NSNumber numberWithInt:1],nil];
}

-(void)callAlert{
	if (matches){
		[self matchesFound];
	}
    else if(errorMsg != NULL){
		[self errorMessage];;
	}
	else{
		[self genericErr];
	}
    [self.tableView reloadData];
}
-(void)matchesFound{

    NSString *messagept1 = NSLocalizedString(@"Results ", @"Section 1 of the message");
    NSString *messagept2 = NSLocalizedString(@" of about ", @"Section 2 of the message");
    NSString *messagept3 = NSLocalizedString(@"\nfor \"", @"Section 3 of the message");
    NSString *title = NSLocalizedString(@"Search Results", @"The title of the alert");
    NSString *buttonTitle = NSLocalizedString(@"Dismiss", @"The button title of the alert");
    
    int start = (((page-1)*100)+1);
    int end = (((page-1)*100)+100);
    
    NSString *message = nil;
    
    if([total intValue] >= end)
        message = [NSString stringWithFormat:@"%@%i - %i%@%i%@%@%@",messagept1,start,end,messagept2,[total intValue],messagept3,args,@"\""];
    else
        message = [NSString stringWithFormat:@"%@%i - %i%@%i%@%@%@",messagept1,start,[total intValue],messagept2,[total intValue],messagept3,args,@"\""];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil]autorelease];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.tableView setScrollEnabled:YES];
    [self.tableView reloadData];
    [alert show];
}

-(void)errorMessage{
    NSString *title = NSLocalizedString(@"API Error", @"The title of the alert");
    NSString *message = [NSString stringWithFormat:@"%@",errorMsg];
    NSString *buttonTitle = NSLocalizedString(@"Dismiss", @"The button title of the alert");
    NSString *buttonTitle2 = NSLocalizedString(@"Reset", @"The button title of the alert");

    [self.detailViewController setDetailItem:nil];

    if ([message isEqual:@"API access denied"]) {
        message = NSLocalizedString(@"The API key entered was invalid. Reset your key by pressing \"Reset\".", @"reset api?");
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:buttonTitle2,nil]autorelease];
        alert.tag = 1;
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [self.tableView setScrollEnabled:NO];
        [self.tableView reloadData];
        [alert show];
    }
    else {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil]autorelease];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [self.tableView setScrollEnabled:NO];
        [self.tableView reloadData];
        [alert show];
    }
}
-(void)genericErr{
    NSString *title = NSLocalizedString(@"Error", @"The title of the alert");
    NSString* string = [NSString stringWithFormat:@"No results found for %@",searched];
    NSString *message = NSLocalizedString(string, @"Used to tell that the request was bad.");
    NSString *buttonTitle = NSLocalizedString(@"Dismiss", @"The button title of the alert");
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttonTitle otherButtonTitles:nil]autorelease];
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.tableView setScrollEnabled:NO];
    [self.tableView reloadData];
    
    [self.detailViewController setDetailItem:nil];
    
    [alert show];
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

#pragma mark - Search Bar
- (void)searchBarCancelButtonClicked:(UISearchBar *)search_Bar{
	[searchBar resignFirstResponder];
	self.searchBar.selectedScopeButtonIndex = -1;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)search_Bar{
    [self dismissAllPopTipViews];
	[searchBar setShowsCancelButton:YES animated:YES];
    [searchBar setShowsScopeBar:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [searchBar sizeToFit];
    self.searchBar.selectedScopeButtonIndex = -1;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)search_Bar{
	[searchBar setShowsCancelButton:NO animated:YES];
    [searchBar setShowsScopeBar:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar sizeToFit];
    self.searchBar.selectedScopeButtonIndex = -1;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)search_Bar{
	self.args = searchBar.text;
	self.searched = args;
	[self performSelectorInBackground:@selector(searchShodan) withObject:self];
    self.searchBar.selectedScopeButtonIndex = -1;
	[searchBar resignFirstResponder];
}

-(void)replaceSearchBarText{
    self.searchBar.text = [searchBar.text stringByReplacingOccurrencesOfString:@"+port:80" withString:@""];
    self.searchBar.text = [searchBar.text stringByReplacingOccurrencesOfString:@"+port:21" withString:@""];
    self.searchBar.text = [searchBar.text stringByReplacingOccurrencesOfString:@"+port:22" withString:@""];
    self.searchBar.text = [searchBar.text stringByReplacingOccurrencesOfString:@"+port:161" withString:@""];
    self.searchBar.text = [searchBar.text stringByReplacingOccurrencesOfString:@"+port:5060" withString:@""];
}

-(void)searchBar:(UISearchBar *)search_Bar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    if (selectedScope == 0 && ![searchBar.text isEqual:@""] && searchBar.text && searchBar.showsScopeBar == YES) {
        [self replaceSearchBarText];
        self.searchBar.text = [NSString stringWithFormat:@"%@+port:80",searchBar.text];
    }
    else if (selectedScope == 1 && ![searchBar.text isEqual:@""] && searchBar.text  && searchBar.showsScopeBar == YES) {
        [self replaceSearchBarText];        
        self.searchBar.text = [NSString stringWithFormat:@"%@+port:21",searchBar.text];
    }
    else if (selectedScope == 2 && ![searchBar.text isEqual:@""] && searchBar.text  && searchBar.showsScopeBar == YES) {
        [self replaceSearchBarText];		
        self.searchBar.text = [NSString stringWithFormat:@"%@+port:22",searchBar.text];
    }
    else if (selectedScope == 3 && ![searchBar.text isEqual:@""] && searchBar.text  && searchBar.showsScopeBar == YES) {
        [self replaceSearchBarText];		
        self.searchBar.text = [NSString stringWithFormat:@"%@+port:161",searchBar.text];
    }
    else if (selectedScope == 4 && ![searchBar.text isEqual:@""] && searchBar.text && searchBar.showsScopeBar == YES) {
        [self replaceSearchBarText];		
        self.searchBar.text = [NSString stringWithFormat:@"%@+port:5060",searchBar.text];
    }
    else {
        self.searchBar.selectedScopeButtonIndex = -1;
    }
}

#pragma mark - Alert View
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (alertView.tag == 1 && buttonIndex == 1) {
			self.apiKey = @"ueZLMDjY4xBU5DbhR76ROvOEQP7Vj8FO";
			[defaults setObject:apiKey forKey:kapiKey];
			[defaults synchronize];
			[self queryAPI];
    }
		else if (alertView.tag == 0 && buttonIndex == 1){
			self.apiKey = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			[defaults setObject:apiKey forKey:kapiKey];
			[defaults synchronize];
			[self queryAPI];
		}
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
	if (alertView.tag == 0){
		UITextField *textField = [alertView textFieldAtIndex:0];
		if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 32){
			return NO;
		}
	}
	return YES;
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.matches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSUInteger row = [indexPath row];
	index = row;
	self.computerDictionary = [self.matches objectAtIndex:row];
	self.ip = [computerDictionary objectForKey:@"ip"];
	self.country_code = [computerDictionary objectForKey:@"country_code"];
	self.city = [computerDictionary objectForKey:@"city"];
	self.updated = [computerDictionary objectForKey:@"updated"];
	self.longitude = [computerDictionary objectForKey:@"longitude"];
	if ([longitude isEqual:[NSNull null]]){
		self.longitude = @"0.000";
	}
	self.latitude = [computerDictionary objectForKey:@"latitude"];
	if ([latitude isEqual:[NSNull null]]){
		self.latitude = @"0.000";
	}
	self.hostnames = [computerDictionary objectForKey:@"hostnames"];
	self.country_name = [computerDictionary objectForKey:@"country_name"];
	self.data = [computerDictionary objectForKey:@"data"];
	self.port = [computerDictionary objectForKey:@"port"]; 
    
    self.country_name = NSLocalizedString(country_name, @"This is the localized country name.");
	
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
	}

	cell.textLabel.text = ip;
    @try {
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
    }
    @catch (NSException *exception) {
        NSLog(@"Encountered exception: %@",exception);
    }
	if(country_code){
		cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",country_code]];
	}
    else {
		cell.imageView.image = [UIImage imageNamed:@"NULL"];
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* model = [NSString stringWithFormat:@"%@",[UIDevice currentDevice].model];
    if ([model isEqualToString:@"iPad"]){
        [self dismissAllPopTipViews];
        NSInteger row = indexPath.row;
        
        index = row;
        self.computerDictionary = [self.matches objectAtIndex:row];
        self.ip = [computerDictionary objectForKey:@"ip"];
        self.country_code = [computerDictionary objectForKey:@"country_code"];
        self.city = [computerDictionary objectForKey:@"city"];
        self.updated = [computerDictionary objectForKey:@"updated"];
        self.longitude = [computerDictionary objectForKey:@"longitude"];
        self.latitude = [computerDictionary objectForKey:@"latitude"];
        self.hostnames = [computerDictionary objectForKey:@"hostnames"];
        self.country_name = [computerDictionary objectForKey:@"country_name"];
        self.data = [computerDictionary objectForKey:@"data"];
        self.port = [computerDictionary objectForKey:@"port"];
		
        self.detailViewController.ip = ip;
        self.detailViewController.country_name = country_name;
        self.detailViewController.country_code = country_code;
        self.detailViewController.city = city;
        self.detailViewController.updated = updated;
        self.detailViewController.latitude = latitude;
        self.detailViewController.longitude = longitude;
        self.detailViewController.hostnames = hostnames;
        self.detailViewController.data = data;
        self.detailViewController.port = port;
        self.detailViewController.searched = searched;
        self.detailViewController.matches = matches;
        self.detailViewController.computerDictionary = computerDictionary;
        NSString *object = ip;
        [self.detailViewController setDetailItem:object];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self dismissAllPopTipViews];
	if ([[segue identifier] isEqualToString:@"showDetail"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSInteger row = indexPath.row;
    
    index = row;
    self.computerDictionary = [self.matches objectAtIndex:row];
    self.ip = [computerDictionary objectForKey:@"ip"];
    self.country_code = [computerDictionary objectForKey:@"country_code"];
    self.city = [computerDictionary objectForKey:@"city"];
    self.updated = [computerDictionary objectForKey:@"updated"];
    self.longitude = [computerDictionary objectForKey:@"longitude"];
    self.latitude = [computerDictionary objectForKey:@"latitude"];
    self.hostnames = [computerDictionary objectForKey:@"hostnames"];
    self.country_name = [computerDictionary objectForKey:@"country_name"];
    self.data = [computerDictionary objectForKey:@"data"];
    self.port = [computerDictionary objectForKey:@"port"]; 
		
    DetailViewController *dvc = segue.destinationViewController;
    dvc.ip = ip;
    dvc.country_name = country_name;
    dvc.country_code = country_code;
    dvc.city = city;
    dvc.updated = updated;
    dvc.latitude = latitude;
    dvc.longitude = longitude;
    dvc.hostnames = hostnames;
    dvc.data = data;
    dvc.port = port;
    dvc.matches = matches;
    dvc.computerDictionary = computerDictionary;
    NSString *object = ip;
    [[segue destinationViewController] setDetailItem:object];
	}
}

- (void)dismissAllPopTipViews {
	while ([visiblePopTipViews count] > 0) {
		CMPopTipView *popTipView = [visiblePopTipViews objectAtIndex:0];
		[visiblePopTipViews removeObjectAtIndex:0];
		[popTipView dismissAnimated:YES];
	}
}

-(void)scrollToTop{
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if (self.tableView.scrollEnabled == YES){
        [self.tableView reloadData];
    	[self.tableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    	[self.tableView deselectRowAtIndexPath:topIndexPath animated:NO];
	}
}
- (void)showInfo:(id)sender{
    [self dismissAllPopTipViews];
    [self scrollToTop];
	if (sender == currentPopTipViewTarget) {
		self.currentPopTipViewTarget = nil;
	}
	else {
		NSString *contentMessage = nil;
		UIView *contentView = nil;
		id content = [self.contents objectForKey:[NSNumber numberWithInt:[(UIView *)sender tag]]];
		if ([content isKindOfClass:[UIView class]]) {
			contentView = content;
		}
		else if ([content isKindOfClass:[NSString class]]) {
            NSString *lc1,*lc2,*lc3,*lc4,*lc5;
            lc1 = nil;
            lc2 = nil;
            lc3 = nil;
            lc4 = nil;
            lc5 = nil;
            
            NSString *c1,*c2,*c3,*c4,*c5;
            c1 = nil;
            c2 = nil;
            c3 = nil;
            c4 = nil;
            c5 = nil;
            
            if ([locations count] > 0) {
                lc1 = NSLocalizedString([[locations objectAtIndex:0] objectForKey:@"name"],@"Localized Top Location Result 1");
                c1 = [NSString stringWithFormat:@"%@%@: %@\n",locationType,lc1,[[locations objectAtIndex:0] objectForKey:@"count"]];
            }
            if ([locations count] > 1) {
                lc2 = NSLocalizedString([[locations objectAtIndex:1] objectForKey:@"name"],@"Localized Top Location Result 1");
				c2 = [NSString stringWithFormat:@"%@%@: %@\n",c1,lc2,[[locations objectAtIndex:1] objectForKey:@"count"]];
            }
            if ([locations count] > 2) {
                lc3 = NSLocalizedString([[locations objectAtIndex:2] objectForKey:@"name"],@"Localized Top Location Result 1");
                c3 = [NSString stringWithFormat:@"%@%@: %@\n",c2,lc3,[[locations objectAtIndex:2] objectForKey:@"count"]];
            }
            if ([locations count] > 3) {
                lc4 = NSLocalizedString([[locations objectAtIndex:3] objectForKey:@"name"],@"Localized Top Location Result 1");
				c4 = [NSString stringWithFormat:@"%@%@: %@\n",c3,lc4,[[locations objectAtIndex:3] objectForKey:@"count"]];
            }
            if ([locations count] > 4) {
                lc5 = NSLocalizedString([[locations objectAtIndex:4] objectForKey:@"name"],@"Localized Top Location Result 1");
				c5 = [NSString stringWithFormat:@"%@%@: %@\n",c4,lc5,[[locations objectAtIndex:4] objectForKey:@"count"]];
            }
            NSString* string = [NSString stringWithFormat:@"Top locations for %@ not found.",searched];
            switch ([locations count]) {
                case 1:contentMessage = c1;break;
                case 2:contentMessage = c2;break;
                case 3:contentMessage = c3;break;
                case 4:contentMessage = c4;break;
                case 5:contentMessage = c5;break;
                default:contentMessage = NSLocalizedString(string,@"Error for top locations");break;
            }
		}
        
		NSArray *colorScheme = [NSArray arrayWithObjects:[UIColor darkGrayColor], [NSNull null], nil];
		UIColor *backgroundColor = [colorScheme objectAtIndex:0];
		UIColor *textColor = [colorScheme objectAtIndex:1];
		
		CMPopTipView *popTipView;
		
        if (contentView) {
			popTipView = [[[CMPopTipView alloc] initWithCustomView:contentView] autorelease];
		}
		else {
			popTipView = [[[CMPopTipView alloc] initWithMessage:contentMessage] autorelease];
		}
        popTipView.delegate = self;

        if (backgroundColor && ![backgroundColor isEqual:[NSNull null]]) {
			popTipView.backgroundColor = backgroundColor;
		}
		if (textColor && ![textColor isEqual:[NSNull null]]) {
			popTipView.textColor = textColor;
		}
        
        popTipView.animation = arc4random() % 2;		
		
        if ([sender isKindOfClass:[UIButton class]]) {
			UIButton *button = (UIButton *)sender;
			[popTipView presentPointingAtView:button inView:self.view animated:YES];
		}
		else {
			UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
			[popTipView presentPointingAtBarButtonItem:barButtonItem animated:YES];
		}
		
		[visiblePopTipViews addObject:popTipView];
		self.currentPopTipViewTarget = sender;
	}
}

#pragma mark -
#pragma mark CMPopTipViewDelegate methods

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
	[visiblePopTipViews removeObject:popTipView];
	self.currentPopTipViewTarget = nil;
}

@end