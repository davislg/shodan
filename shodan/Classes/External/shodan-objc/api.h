//
//  api.h
//  shodan
//
//  Created by Erran Carey on 6/2/12.
//  Copyright (c) 2012 @ipwnstuff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebAPI : NSObject

@property (strong, nonatomic) NSString* api_key;
@property (strong, nonatomic) NSString* args;
@property (strong,nonatomic) NSString* base_url;
@property (strong,nonatomic) NSDictionary* params;
@property (strong, nonatomic) NSDictionary* result;

-(id)init_with_api_key:(NSString*)apikey;

-(void)set_api_key:(NSString*)apikey;

-(void)request:(NSString*)function;

-(NSDictionary*)info;
-(NSDictionary*)host:(NSString*)ip;
-(NSDictionary*)locations:(NSString*)query;
-(NSDictionary*)search:(NSString*)query;
-(NSDictionary*)search:(NSString*)query page:(int)p;
-(NSDictionary*)search:(NSString*)query page:(int)p limit:(int)l;
-(NSDictionary*)search:(NSString*)query page:(int)p limit:(int)l offset:(int)o;

@end