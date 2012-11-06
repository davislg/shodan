Visit the documentation for my Objective-C library for SHODAN at:

[http://ipwnstuff.github.com/shodan-objective-c/docs](http://ipwnstuff.github.com/shodan-objective-c/docs)

To visit the official Shodan API documentation go here:

[http://docs.shodanhq.com](http://docs.shodanhq.com)

## Usage

Before you can use this Objective-C library to connect to the SHODAN API, you need to have an API key [from SHODAN](http://www.shodanhq.com/api_doc).

Create and initialize an instance of the WebAPI class:

    #import "shodan.h" //Make sure to import this where you declare your interface.

    WebAPI* api = [[WebAPI alloc]init_with_api_key:@"Your API Key"];

Print a list of cisco-ios devices:

    NSDictionary* result = [api search:@"cisco"];
    int i = 0;
    for (id host in [result objectForKey:@"matches"]) {
        host = [[result objectForKey:@"matches"] objectAtIndex:i];
        i++;
        NSLog(@"%@",[host objectForKey:@"ip"]);
    }
Grab all information SHODAN has on a specific ip (4.59.125.121):

    NSDictionary* host = [api host:@"4.59.125.121"];
    NSLog(@"%@",host);

Previosly to test for exceptions/catch errors you would have to wrap any request in a @try-@catch block, now I simplified it by building it into my generic request method.

    BOOL exc_encountered = 0;
    @try {
        result = [NSJSONSerialization JSONObjectWithData:searchResults options:kNilOptions error:&error];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@",exception);
        exc_encountered = 1;
    }
    @finally {
        if (exc_encountered == 1) {
            NSLog(@"Exception encountered. Setting |result| for %@ to nil.",function);
            result = nil;
        }
        else {
            NSLog(@"Returning |result| for %@.",function);
        }
    }