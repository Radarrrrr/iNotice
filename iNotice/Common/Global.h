//PS:本类用来装载全局变量以及全局函数以及需要持续运行的功能，主要执行跟参数有关的部分，本类在程序运行过程中一直处于运行状态

#import <UIKit/UIKit.h>
#import "CLController.h"
#import <AssetsLibrary/AssetsLibrary.h>


@class Global;
@protocol GlobalDelegate <NSObject>
@optional
-(void)ReturnLocateFinshFromGlobal;
@end


@interface Global : NSObject<CLControllerDelegate> {

@private
	id _delegate;	
}

@property (assign) id<GlobalDelegate> delegate;
@property (nonatomic, retain) NSString *myGpsLat; //我的坐标经纬度
@property (nonatomic, retain) NSString *myGpsLng;

+ (Global *)sharedGlobal;


-(void)StartLocating; //开始定位当前的GPS坐标
-(void)StopLocating;  //停止定位当前坐标



@end