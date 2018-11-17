#import "Marker.h"


@implementation Marker

@synthesize latitude;
@synthesize longitude;
@synthesize title;
@synthesize subtitle;
@synthesize leftImage;
@synthesize annImage;
@synthesize dataIndex;
@synthesize pinAnColor;
@synthesize type;

- (CLLocationCoordinate2D)coordinate
{
	CLLocationCoordinate2D coord = {self.latitude, self.longitude};
	return coord;
}

- (void)dealloc {
    [super dealloc];
}

@end
