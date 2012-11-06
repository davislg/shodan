//
//  api.m
//  shodan
//
//  Created by Erran Carey on 6/2/12.
//  Copyright (c) 2012 @ipwnstuff. All rights reserved.
//

#import "api.h"

@implementation WebAPI

@synthesize api_key;
@synthesize args;
@synthesize base_url;
@synthesize result;
@synthesize params;

-(id)init_with_api_key:(NSString*)apikey
{
	if (self = [super init]){
		api_key = [apikey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		base_url = @"http://www.shodanhq.com/api/";
	}
	return self;
}

-(void)set_api_key:(NSString*)apikey
{
	api_key = apikey;
}

-(void)request:(NSString*)function
{
  // Send the request based on the function.
	params = [NSMutableDictionary dictionaryWithObjectsAndKeys:base_url,@"base_url",[function stringByAppendingFormat:@"?"],@"function",[NSString stringWithFormat:@"key=%@",api_key],@"api_key",nil];
	NSURL* url = nil;
	NSString* url_string = @"";

#ifdef TARGET_OS_IPHONE
	url_string = [url_string stringByAppendingFormat:@"%@",base_url];
	url_string = [url_string stringByAppendingFormat:@"%@",[function stringByAppendingFormat:@"?"]];
	url_string = [url_string stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"key=%@",api_key]];
#else
	for (id key in params){
		url_string = [url_string stringByAppendingFormat:@"%@",[params objectForKey:key]];
	}
#endif
	
	if ([function isEqualToString:@"count"]) {
		url = [NSURL URLWithString:[url_string stringByAppendingFormat:@"&q=%@",args]];
	}
	else if ([function isEqualToString:@"host"]) {
		url = [NSURL URLWithString:[url_string stringByAppendingFormat:@"&ip=%@",args]];
	}
	else if ([function isEqualToString:@"info"]) {
		url = [NSURL URLWithString:url_string];
	}
	else if ([function isEqualToString:@"locations"]) {
		url = [NSURL URLWithString:[url_string stringByAppendingFormat:@"&q=%@",args]];
	}
	else if ([function isEqualToString:@"search"]) {
		url = [NSURL URLWithString:[url_string stringByAppendingFormat:@"&q=%@",args]];
	}
	
	NSError* error;
	NSData* searchResults = [NSData dataWithContentsOfURL:url];
	if(!searchResults){
		result = nil;
	}
	else{
		result = [NSJSONSerialization JSONObjectWithData:searchResults options:kNilOptions error:&error];
	}
}

-(NSDictionary*)count:(NSString*)query
{
  /*
   * Find the number of results for a query.
   *
   * Required arguments:
   *	 - query : Search query.
   *
   * Usage:
   *	 `[api count@"your query"];`
   *
   */
	args = [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	[self request:@"count"];
	return result;
}

-(NSDictionary*)host:(NSString*)ip
{
  /*
   * Get all the available information on a host in the SHODAN database
   *
   * Required arguments:
   *    — host : The IP address of the host.
   *
   * Usage:
   *    `[api search:@"your query"];`
   *
   * Stores a dictionary containing: "ip", "longitude", "latitude", "hostnames", "country_code", "country", "country_name", "data"
   * The dictionary is contained in api.results
   */
	args = [ip stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	[self request:@"host"];
	return result;
}

-(NSDictionary*)info
{
  /*
   * View the current API key's plan, add-ons, and credits.
   *
   * Usage:
   *    `[api info];`
   *
   * Stores a dictionary containing: "unlocked_left", "telnet", "plan", "https", "unlocked"
   * The dictionary is contained in api.results
   */
	[self request:@"info"];
	return result;
}

-(NSDictionary*)locations:(NSString*)query
{
  /*
   * Return a list of the countries and cities found for a given search query.
   *
   * Required arguments:
   *    — query : Search query.
   *
   * Usage:
   *    `[api locations:@"your query"];`
   *
   * Stores a dictionary containing: "cities" and "countries"
   * The dictionary is contained in api.results
   */
	args = [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	[self request:@"locations"];
	return result;
}

-(NSDictionary*)search:(NSString*)query page:(int)p limit:(int)l offset:(int)o
{
  /*
   * Search the SHODAN database.
   *
   * Required arguments:
   *    — query : Search query.
   *
   * Optional arguments:
   *    - page : Specify the page number for results.
   *    - limit : Determine the results per page.
   *    - offset : Specify from which result you begin.
   *
   * Usage:
   *    `[api search:@"your query"];`
   *
   * Stores a dictionary containing: "cities", "countries", "matches", "total"
   * The dictionary is contained in api.results
   */
	
	query = [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	
	args = [query stringByAppendingString:[NSString stringWithFormat:@"&p=%i&l=%i&o=%i",p,l,o]];
	[self request:@"search"];
	return result;
}

-(NSDictionary*)search:(NSString*)query
{
	[self search:query page:1 limit:100 offset:0];
	return result;
}

-(NSDictionary*)search:(NSString*)query page:(int)p
{
	[self search:query page:p limit:100 offset:0];
	return result;
}

-(NSDictionary*)search:(NSString*)query page:(int)p limit:(int)l
{
	[self search:query page:p limit:l offset:0];
	return result;
}

@end

