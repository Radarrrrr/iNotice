#import "CLController.h"


// Shorthand for getting localized strings, used in formats below for readability
#define LocStr(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]


// This is a singleton class, see below
static CLController *sharedCLDelegate = nil;

@implementation CLController

@synthesize delegate=_delegate;
@synthesize locationManager;

- (id) init {
	self = [super init];
	if (self != nil) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		self.locationManager.delegate = self; // Tells the location manager to send updates to this object
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		self.locationManager.distanceFilter = 50.0;
	}
	return self;
}


// Called when the location is updated
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	// Horizontal coordinates
	if (signbit(newLocation.horizontalAccuracy)) //如果水平测量不存在
	{
		return;
	} 
	
	// Send the location to our delegate //设置我地坐标
	[self.delegate SetMyLocation:newLocation.coordinate.longitude with:newLocation.coordinate.latitude]; 
}


// Called when there is an error getting the location
- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	[self.delegate LocateError];
}

// See "Creating a Singleton Instance" in the Cocoa Fundamentals Guide for more info

+ (CLController *)sharedInstance {
    @synchronized(self) {
        if (sharedCLDelegate == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedCLDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedCLDelegate == nil) {
            sharedCLDelegate = [super allocWithZone:zone];
            return sharedCLDelegate;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}


@end