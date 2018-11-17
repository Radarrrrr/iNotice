// This protocol is used to send the text for location updates back to another view controller
#import <CoreLocation/CoreLocation.h>

@protocol CLControllerDelegate <NSObject>
@required
-(void)SetMyLocation:(double)dLatitude with:(double)dLongitude;
-(void)LocateError;
@end


// Class definition
@interface CLController : NSObject <CLLocationManagerDelegate> {
	
	CLLocationManager *locationManager;

	
@private
	id _delegate;
}

@property (assign) id<CLControllerDelegate> delegate;
@property (nonatomic, retain) CLLocationManager *locationManager;



- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;

+ (CLController *)sharedInstance;

@end

