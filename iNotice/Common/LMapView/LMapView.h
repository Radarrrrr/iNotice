#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import <MapKit/MKMapView.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKAnnotationView.h>
#import <CoreLocation/CoreLocation.h>
#import "Global.h"
#import "Marker.h"

@class LMapView;
@protocol MapDelegate <NSObject>
@optional
-(void)MapLoadFinishFromMapView;
-(void)MapLoadFailedFromMapView;
-(void)RetuenAnnotationCalloutAccessoryTapFromMapView:(LMapView*)lmapview withMarker:(Marker*)marker;
@end


@interface LMapView : UIView <MKMapViewDelegate> {

	MKMapView *_map;
	NSArray *_markerArray;
	Marker *_userMarker;
	Marker *_customMarker;
	Marker *_hotelMarker;
	
@private
	id _delegate;		
}

@property(assign) id<MapDelegate> delegate;


#pragma mark -----------内部函数--------------
-(void)MoveMapToLocation:(double)latitude withLng:(double)longitude;//把地图移动到指定当前位置
-(void)MoveMapToLocationBySpan:(double)latitude withLng:(double)longitude bySpan:(MKCoordinateSpan)theSpan; //根据偏移量的delta移动地图


#pragma mark --------供外部调用的接口----------
-(void)SetMyLocation:(Marker*)userMarker;//设置我自己的位置相关的属性,此函数必须在显示自己的位置之前调用
-(void)ShowMyLocation; //显示我的位置和提示窗口
-(void)AddMarkers:(NSArray*)markerArray; //marker类型的数组
-(void)RemoveAllMarkers; //清除所有的标记在地图上
-(CLLocationCoordinate2D)GetCenterCoord;//得到屏幕中心的地图坐标
-(double)GetAroundDistance;//得到当前缩放状态下面的搜索范围
-(MKCoordinateRegion)GetCoordinateRegion;//得到当前缩放状态下的地图可见范围
-(double)CalculateSphereDistance:(CLLocationCoordinate2D)geom1 toGeom:(CLLocationCoordinate2D)geom2;//计算两点间地理距离,返回值单位：米 
-(void)ShowPoiPopUpByID:(NSString*)poiID;//根据poi的ID显示他再地图上的popup窗口
-(void)AddCustomMarker:(Marker*)marker; //添加用户自定义poi到屏幕的正中心
-(void)CheckMarkerInMap:(Marker*)marker; //在地图上查看指定的marker
-(void)AddOnlyOneMarker:(Marker*)marker; //在地图上添加一个独立的marker
-(void)AddHotelMarker:(Marker*)marker;//添加一个hotel marker在地图上
-(void)HighLightMarkerInMap:(Marker*)marker;//在地图上高亮显示某一个marker，就是弹出popup窗口
-(void)OKtoShowMyLocation; //可以显示我的位置
-(void)CheckHotelMarkerInMap;


@end
