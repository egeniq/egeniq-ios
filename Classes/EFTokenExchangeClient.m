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

- (void)setDeviceToken:(NSString *)deviceToken {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:deviceToken forKey:@"EFTECDeviceToken"];
	[defaults synchronize];
}

- (NSString *)deviceToken {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults stringForKey:@"EFTECDeviceToken"];
}

- (void)exchangeDeviceToken:(NSData *)deviceToken {
    NSURL *URL = [NSURL URLWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"EFTECDeviceTokenExchangeURL"]];
    [self exchangeDeviceToken:deviceToken URL:URL];
}

- (void)exchangeDeviceToken:(NSData *)deviceToken URL:(NSURL *)URL {
	NSString *escapedDeviceToken = [deviceToken hexStringValue];
	NSString *escapedNotificationToken = [self.notificationToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
    if ([[self deviceToken] isEqualToString:escapedDeviceToken] && [[self notificationToken] isEqualToString:escapedNotificationToken]) {
        // The notification token we are about to send is the same as for the last successful attempt,
        // stopping to reduce server load
        return;
    } else if ([[self deviceToken] isEqualToString:escapedDeviceToken]) {
        // Same device token, but different notification token, tell server
    } else {
        // Different device token (perhaps user synced preferences to another/new device),
        // store new device token and
        // delete notification token as it must be invalid.
        [self setDeviceToken:escapedDeviceToken];
        [self setNotificationToken:nil];
    }
    
	NSString *body;
	if (escapedNotificationToken == nil) {
	    body = [NSString stringWithFormat:@"deviceToken=%@&deviceFamily=ios", escapedDeviceToken];	
	} else {
	    body = [NSString stringWithFormat:@"deviceToken=%@&notificationToken=%@", escapedDeviceToken, escapedNotificationToken];
	}
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
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

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end