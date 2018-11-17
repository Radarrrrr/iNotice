#import "Global.h"


static Global *_sharedGlobal;
static int _chooseHotelID = -1;


@implementation Global
@synthesize delegate=_delegate;


+ (Global *)sharedGlobal
{
	if (!_sharedGlobal) {
		_sharedGlobal = [[Global alloc] init];
	}
	return _sharedGlobal;
}

- (void)dealloc
{		
    [_myGpsLng release];
    [_myGpsLat release];
	[_sharedGlobal release];
	[super dealloc];
}




#pragma mark -
#pragma mark GPS定位相关
//开始定位当前的GPS坐标
-(void)StartLocating
{	
	[CLController sharedInstance].delegate = self;
	
	//在这里写获得当前位置GPS坐标的函数
	if(![CLController sharedInstance].locationManager.locationServicesEnabled) //如果定位设备不能用
	{
		NSLog(@"定位设备不能用");
		_myGpsLng = @"";
		_myGpsLat = @"";
		
		return;
    }
	
	[[CLController sharedInstance].locationManager startUpdatingLocation]; //开始定位我的坐标
}
//停止定位当前坐标
-(void)StopLocating
{
	[[CLController sharedInstance].locationManager stopUpdatingLocation]; //停止定位我的坐标
}





#pragma mark ---------实现代理协议函数----------
//从CLController过来的
-(void)SetMyLocation:(double)dLongitude with:(double)dLatitude
{
	//用户当前的gps坐标位置
	self.myGpsLng = [NSString stringWithFormat:@"%lf", dLongitude]; //@"116.39651";
	self.myGpsLat = [NSString stringWithFormat:@"%lf", dLatitude];  //@"39.99287";
	
	NSLog(@"我的位置：(lng:%@, lat:%@)", _myGpsLng, _myGpsLat);	
	
	if(self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector(ReturnLocateFinshFromGlobal)])
	{
		[self.delegate ReturnLocateFinshFromGlobal];
	}
}
-(void)LocateError
{	
	NSLog(@"定位失败");
	self.myGpsLng = nil;
	self.myGpsLat = nil;
}








@end
