#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

typedef enum {
	typeHotel,
	typePoi,
	typeCustom,
	typeCheck,
	typeUser
} MarkerType;

@interface Marker : NSObject <MKAnnotation>{
	double latitude;
	double longitude;
	NSString *title;
	NSString *subtitle;
	UIImage *leftImage;
	UIImage *annImage;
	NSString *dataIndex;
	MKPinAnnotationColor pinAnColor;
	MarkerType type;
}
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) UIImage *leftImage;
@property (nonatomic, retain) UIImage *annImage;
@property (nonatomic, retain) NSString *dataIndex;
@property (nonatomic) MKPinAnnotationColor pinAnColor;
@property (nonatomic) MarkerType type;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
