#import "EFTokenExchangeClient.h"
#import "NSData+Hex.h"

static EFTokenExchangeClient *sharedInstance = nil;

@implementation EFTokenExchangeClient

#pragma mark -
#pragma mark Class instance methods

- (void)setNotificationToken:(NSString *)notificationToken {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:notificationToken forKey:@"EFTECNotificationToken"];
	[defaults synchronize];
}

- (NSString *)notificationToken {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults stringForKey:@"EFTECNotificationToken"];
}

- (void)exchangeDeviceToken:(NSData *)deviceToken {
	NSString *escapedDeviceToken = [deviceToken hexStringValue];
	NSString *escapedNotificationToken = [self.notificationToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSString *body;
	if (escapedNotificationToken == nil) {
	    body = [NSString stringWithFormat:@"deviceToken=%@&deviceFamily=ios", escapedDeviceToken];	
	} else {
	    body = [NSString stringWithFormat:@"deviceToken=%@&notificationToken=%@", escapedDeviceToken, escapedNotificationToken];
	}
	
	NSString *url = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"EFTECDeviceTokenExchangeURL"];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[request setTimeoutInterval:15.0];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection != nil) {
		responseData = [[NSMutableData data] retain];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [responseData release];
	responseData = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	if ([response length] > 0) {
		[self setNotificationToken:response];
	}
	
	[response release];	
    [connection release];
    [responseData release];	
	responseData = nil;	
}

- (void)dealloc {
    [responseData release];		
	responseData = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Singleton methods

+ (EFTokenExchangeClient *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
			sharedInstance = [[EFTokenExchangeClient alloc] init];
		}
	}
	
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
	
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end