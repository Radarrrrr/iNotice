#import "LMapView.h"


#define PI 3.1415926

@implementation LMapView

@synthesize delegate=_delegate;


#pragma mark -------系统函数------
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		_map = [[MKMapView alloc] initWithFrame:frame];
	    [_map setMapType: MKMapTypeStandard];
		[_map setDelegate:self];
	
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code	
	[self addSubview:_map];
}



#pragma mark -----------内部函数--------------
-(void)MoveMapToLocation:(double)latitude withLng:(double)longitude
{
	CLLocationCoordinate2D theCenter;
	theCenter.latitude = latitude; 
	theCenter.longitude = longitude;

	
	MKCoordinateSpan theSpan;
	theSpan.latitudeDelta = 0.05;
	theSpan.longitudeDelta = 0.05;
	
	MKCoordinateRegion theRegin;
	theRegin.center=theCenter;
	theRegin.span = theSpan;
	[_map setRegion:theRegin];
	[_map regionThatFits:theRegin];
	
	
	[_map setCenterCoordinate:theCenter animated:YES];
}
-(void)MoveMapToLocationBySpan:(double)latitude withLng:(double)longitude bySpan:(MKCoordinateSpan)theSpan
{
	CLLocationCoordinate2D theCenter;
	theCenter.latitude = latitude; 
	theCenter.longitude = longitude;
	
	MKCoordinateRegion theRegin;
	theRegin.center=theCenter;
	theRegin.span = theSpan;
	[_map setRegion:theRegin];
	[_map regionThatFits:theRegin];
	
	[_map setCenterCoordinate:theCenter animated:YES];
}




#pragma mark -------代理--------
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	if(annotation == mapView.userLocation)
	{
		mapView.userLocation.title = _userMarker.title;
		mapView.userLocation.subtitle = _userMarker.subtitle;
		return nil;
	}
	else
	{
		/*
		MKAnnotationView *currentMarkerAnnotationView=[[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"thisAnnotation"] autorelease];
		currentMarkerAnnotationView.image = [UIImage imageNamed:@"marker.png"];
		
		currentMarkerAnnotationView.canShowCallout = YES;
		UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		currentMarkerAnnotationView.rightCalloutAccessoryView = nextBtn;
		
		UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marker.png"]];
		currentMarkerAnnotationView.leftCalloutAccessoryView = imageview;
		
		return currentMarkerAnnotationView;
		*/
		
		Marker *marker = (Marker*)annotation;
		
		if(marker.annImage == nil)
		{
			
			MKPinAnnotationView *pinmarkerView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinmarker"] autorelease];
			
			pinmarkerView.animatesDrop = YES;
			//pinmarkerView.pinColor = MKPinAnnotationColorRed;
			pinmarkerView.pinColor = marker.pinAnColor;
			
			pinmarkerView.canShowCallout = YES;
			
			if(marker.type == typePoi || marker.type == typeCustom)
			{
				UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
				pinmarkerView.rightCalloutAccessoryView = nextBtn;
			}
			
			if(marker.leftImage != nil)
			{
				UIImageView *imageview = [[UIImageView alloc] initWithImage:marker.leftImage];
				pinmarkerView.leftCalloutAccessoryView = imageview;
			}
			
			return pinmarkerView;
		}
		else
		{
			/*
			 MKAnnotationView *markerView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"marker"];
			 if(markerView == nil) 
			 {
			 markerView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"marker"];
			 }
			 */
			
			MKAnnotationView *markerView=[[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"marker"] autorelease];
			markerView.image = marker.annImage;
			
			markerView.canShowCallout = YES;
			
			if(marker.type == typePoi || marker.type == typeCustom)
			{
				UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
				markerView.rightCalloutAccessoryView = nextBtn;
			}
			
			if(marker.leftImage != nil)
			{
				UIImageView *imageview = [[UIImageView alloc] initWithImage:marker.leftImage];
				markerView.leftCalloutAccessoryView = imageview;
			}
		
			return markerView;
		
		}
	}
	
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
	if(views == nil) return;
	for(int i=0; i<[views count]; i++)
	{
		id view = [views objectAtIndex:i];
		if([[view class] isSubclassOfClass:[NSClassFromString(@"MKUserLocationView") class]])
		{
			MKAnnotationView *userLocationView = [mapView viewForAnnotation:mapView.userLocation];
			//UIButton *nBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			//userLocationView.rightCalloutAccessoryView = nBtn;
			
			if(_userMarker.leftImage != nil)
			{
				UIImageView *imageview = [[UIImageView alloc] initWithImage:_userMarker.leftImage];
				userLocationView.leftCalloutAccessoryView = imageview;
				[imageview release];
			}
			
			//[_map selectAnnotation:_map.userLocation animated:YES];
			
			break;
		}
		
	}
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	Marker *marker = (Marker*)view.annotation;
	if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(RetuenAnnotationCalloutAccessoryTapFromMapView:withMarker:)])
	{
		[self.delegate RetuenAnnotationCalloutAccessoryTapFromMapView:self withMarker:marker];
	}
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
	if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(MapLoadFinishFromMapView)])
	{
		[self.delegate MapLoadFinishFromMapView];
	}
}
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
	if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(MapLoadFailedFromMapView)])
	{
		[self.delegate MapLoadFailedFromMapView];
	}
}



#pragma mark --------供外部调用的接口----------
-(void)SetMyLocation:(Marker*)userMarker
{
	if(userMarker == nil) return;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	_userMarker = [userMarker retain];
	[pool release];
}
-(void)ShowMyLocation
{
	[self MoveMapToLocation:[[Global sharedGlobal].myGpsLat doubleValue] withLng:[[Global sharedGlobal].myGpsLng doubleValue]];
	//_map.showsUserLocation=YES;
	
	//显示自己的位置提示call out
	[_map selectAnnotation:_map.userLocation animated:YES];
	
}
-(void)AddMarkers:(NSArray*)markerArray
{
	if(markerArray == nil || [markerArray count] == 0) return;
	
	if(_markerArray != nil)
	{
		[_markerArray release];
		_markerArray = nil;
	}
	
	_markerArray = [markerArray retain];
	
	[_map addAnnotations:_markerArray];
	
}
-(void)RemoveAllMarkers
{
	NSMutableArray *curAnnos = [[NSMutableArray alloc] initWithArray:_map.annotations];
	[curAnnos removeObject:_map.userLocation];
	[curAnnos removeObject:_customMarker];
	[curAnnos removeObject:_hotelMarker];
	[_map removeAnnotations:curAnnos];
	[curAnnos release];
}
-(CLLocationCoordinate2D)GetCenterCoord
{
	return _map.centerCoordinate;
}
-(double)GetAroundDistance
{
	CLLocationCoordinate2D centercoord = _map.centerCoordinate;
	CLLocationCoordinate2D connerCoord = [_map convertPoint:CGPointMake(0.0, 0.0) toCoordinateFromView:_map];
	
	double distance = [self CalculateSphereDistance:centercoord toGeom:connerCoord];
	return distance;
}
//返回值单位：米 
-(double)CalculateSphereDistance:(CLLocationCoordinate2D)geom1 toGeom:(CLLocationCoordinate2D)geom2
{
	double rad = 6371004; //Earth radius in metre
    //Convert to radians
    double p1X = geom1.longitude / 180 * PI;
    double p1Y = geom1.latitude / 180 * PI;
    double p2X = geom2.longitude / 180 * PI;
    double p2Y = geom2.latitude / 180 * PI;
    
    return acos(sin(p1Y) * sin(p2Y) + cos(p1Y) * cos(p2Y) * cos(p2X - p1X)) * rad;
}
-(MKCoordinateRegion)GetCoordinateRegion
{
	return _map.region;
}
-(void)ShowPoiPopUpByID:(NSString*)poiID
{
	Marker *showMarker;
	for(int i=0; i<[_markerArray count]; i++)
	{
		Marker *marker = [_markerArray objectAtIndex:i];
		if([marker.dataIndex compare:poiID] == NSOrderedSame)
		{
			showMarker = marker;
			break;
		}
	}
	
	if(showMarker == nil) return;
	
	[self MoveMapToLocation:showMarker.latitude withLng:showMarker.longitude];
	[_map selectAnnotation:showMarker animated:YES];
}
-(void)AddCustomMarker:(Marker*)marker
{
	if(marker == nil) return;
	
	if(_customMarker != nil)
	{
		[_map removeAnnotation:_customMarker];
		[_customMarker release];
	}
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	_customMarker = [marker retain];
	[pool release];
	
	[_map addAnnotation:_customMarker];
	//[_map selectAnnotation:_customMarker animated:YES];
}
-(void)CheckMarkerInMap:(Marker*)marker
{
	if(marker == nil) return;
	
	[self MoveMapToLocation:marker.latitude withLng:marker.longitude];
	
	Marker *showMarker = nil;
	NSArray *markers = _map.annotations;
	for(int i=0; i<[markers count]; i++)
	{
		Marker *mark = (Marker*)[markers objectAtIndex:i];
		if(mark.coordinate.latitude == marker.coordinate.latitude && mark.coordinate.longitude == marker.coordinate.longitude && 
		   [mark.title compare:marker.title] == NSOrderedSame && [mark.subtitle compare:marker.subtitle] == NSOrderedSame)
		{
			showMarker = mark;
			break;
		}
	}

	if(showMarker != nil)
	{
		[_map selectAnnotation:showMarker animated:YES];
	}
	else
	{
		showMarker = marker;
		[self AddOnlyOneMarker:showMarker];
		[_map selectAnnotation:showMarker animated:YES];
	}	
	
}
-(void)AddOnlyOneMarker:(Marker*)marker
{
	if(marker == nil) return;
	
	//[self RemoveAllMarkers];
	[self MoveMapToLocation:marker.latitude withLng:marker.longitude];
	[_map addAnnotation:marker];
}
-(void)AddHotelMarker:(Marker*)marker
{
	if(marker == nil) return;
	
	if(_hotelMarker != nil)
	{
		[_map removeAnnotation:_hotelMarker];
		[_hotelMarker release];
	}
	
	_hotelMarker = [marker retain];
	
	[self MoveMapToLocation:_hotelMarker.latitude withLng:_hotelMarker.longitude];
	[_map addAnnotation:_hotelMarker];
	[_map selectAnnotation:_hotelMarker animated:YES];
	
	
}
-(void)HighLightMarkerInMap:(Marker*)marker
{
	if(marker == nil) return;
	[self MoveMapToLocation:marker.latitude withLng:marker.longitude];
	[_map selectAnnotation:marker animated:YES];
}
-(void)OKtoShowMyLocation
{
	_map.showsUserLocation = YES;
}
-(void)CheckHotelMarkerInMap
{
	[self CheckMarkerInMap:_hotelMarker];
}





- (void)dealloc {
	if(_markerArray != nil)
	{
		[_markerArray release];
		_markerArray = nil;
	}
	if(_userMarker != nil)
	{
		[_userMarker release];
		_userMarker = nil;
	}
	if(_customMarker != nil)
	{
		[_customMarker release];
		_customMarker = nil;
	}
	if(_hotelMarker != nil)
	{
		[_hotelMarker release];
		_hotelMarker = nil;
	}
	
	[_map release];
    [super dealloc];
}





@end
