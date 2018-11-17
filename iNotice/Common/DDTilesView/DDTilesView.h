//
//  DDTilesView.h
//  CMSTestDemo
//
//  Created by Radar on 13-6-21.
//  Copyright (c) 2013年 www.dangdang.com. All rights reserved.
//

//PS: 本组件默认左右两侧偏移量相同，即左右两侧都按照_xoffset的大小来处理空白区域，但上下并不是，下部由_tailblank来指定空白区域

/* 
 //1. 引入头文件，添加代理和数据源 <DDTilesViewDataSource, DDTilesViewDelegate>
 
 //2. 创建一个瓦片表类
 DDTilesView *tilesView = [[DDTilesView alloc] initWithFrame:CGRectMake(0, 0, 320, 548)];
 tilesView.delegate = self;
 tilesView.dataSource = self;
 tilesView.refreshEnabled = YES;
 tilesView.loadMoreEnabled = YES;
 tilesView.shadowEnabled = YES;
 tilesView.headerLogo = [UIImage imageNamed:@"logo.png"];
 tilesView.footerLogo = [UIImage imageNamed:@"logo.png"];
 tilesView.params = @{                                          //[可选]设定瓦片表属性
                         @"x_offset"   :@"10",
                         @"y_offset"   :@"10",
                         @"x_blank"    :@"10",
                         @"y_blank"    :@"10",
                         @"tail_blank" :@"10"
                     };
 tilesView.dragRefreshControll.tintColor = [UIColor redColor];  //[可选]设定下拉水滴颜色
 [self.view addSubview:tilesView];
 [tilesView release];
 
 //3. 实现数据源方法，必须实现，否则无法正常显示且会引起CRASH
 - (NSInteger)numberOfTilesInTilesView:(DDTilesView*)tilesView;
 - (UIView*)tilesView:(DDTilesView*)tilesView viewForIndex:(NSInteger)index; 
 
 //4. 实现代理方法，接收返回的事件
 
*/

#import <UIKit/UIKit.h>
#import "DDTView.h"
#import "ISRefreshControl.h"
#import "DDLogoView.h"


#define ddtsv_more_view_height          40  //读取更多view的高度
#define ddtsv_load_more_back_offset     0   //读取更多的触发点，向回提前的尺寸



typedef enum {
    DDTilesViewTriggerRefresh = 0, //触发下拉刷新
    DDTilesViewTriggerLoadMore     //触发上提读取更多
} DDTilesViewTrigger;





@class DDTilesView;

//delegate方法
@protocol DDTilesViewDelegate<NSObject>
@optional

- (void)tilesViewDidSelect:(UIView*)tileView index:(NSInteger)index; //选择了哪个瓦片及该瓦片的index
- (void)tilesViewDidTrigger:(DDTilesViewTrigger)triggerType; //触发下拉刷新或者加载更多

//供外部某些特殊需求使用的，为了获取内部的scrollview的滚动的事件而引出来的方法
- (void)tilesViewDidScroll:(DDTilesView*)tilesView; 
- (void)tilesViewDidEndDecelerating:(DDTilesView *)tilesView;
- (void)tilesViewDidEndDragging:(DDTilesView *)tilesView willDecelerate:(BOOL)decelerate;

@end


//datasource方法 //PS: 请注意，dataSource为@required方法，必须实现，否则会crash
@protocol DDTilesViewDataSource<NSObject>
@required

- (NSInteger)numberOfTilesInTilesView:(DDTilesView*)tilesView;  //所有瓦片的总数量，如果设定为0，则无内容展示

//根据index获取该index要显示的view，放在DDTilesView的一个格子里
//PS: view必须为autorelease类型，保证本类内部只有一次引用计数，否则会内存泄漏
//PS: 瓦片的宽度和高度可以由外部更改，本类内部会自动计算可用空间
- (UIView*)tilesView:(DDTilesView*)tilesView viewForIndex:(NSInteger)index; 

@end




@interface DDTilesView : UIView <DDTViewDelegate, UIScrollViewDelegate> {
 
    UIScrollView *_contentView;  //容器view，用来做下拉刷新和内部所有元素的承载
    
    float _xoffset;  //几个偏移量，内部使用，用来绘制瓦片的位置
    float _yoffset;
    float _xblank;
    float _yblank;
    float _tailblank;
    
    float _useableX; //当前可以使用的X和Y坐标点，用于放置瓦片的x，y
    float _useableY; 
    
    UIView *_moreView; //读取更多的footerview
    BOOL _loadMoreEnabled; //是否需要读取更多
    
    ISRefreshControl *_dragRefreshControll; //注意:这个属性能设置的东西很变态，iOS4.x什么都不能改，iOS5.x只能改水滴的颜色，iOS6.x什么都能改
    BOOL _refreshEnabled;  //是否需要下拉刷新
    
    BOOL _loading; //正在读取中，此属性用来卡断其他刷新触发 default is NO
    
    DDLogoView *_logoHeaderView;
    DDLogoView *_logoFooterView;
    UIImage *_headerLogo;  //header和footer里边用的logo，如果logo不存在，则不会显示下拉或者上提出现的logo，当然，如果有下拉或者上提读取功能，这个logo也不会出现
    UIImage *_footerLogo;
    
    NSDictionary *_params; //位置属性
    
    BOOL _shadowEnabled; 
    
@private
	id _delegate;		
    id _dataSource;
}

@property (assign) id <DDTilesViewDelegate> delegate;
@property (assign) id <DDTilesViewDataSource> dataSource;

@property (nonatomic)           BOOL    loadMoreEnabled;  //是否需要读取更多,可随时从外部更改设定, default is NO 
@property (nonatomic)           BOOL    refreshEnabled;   //是否需要下拉刷新,可随时从外部更改设定, default is NO
@property (nonatomic, retain)   UIImage *headerLogo;      //不写则无logo，header和footer里边用的logo，如果logo不存在，则不会显示下拉或者上提出现的logo，当然，如果有下拉或者上提读取功能，这个logo也不会出现
@property (nonatomic, retain)   UIImage *footerLogo;      //不写则无logo

@property (nonatomic)           BOOL    shadowEnabled;    //点击瓦片的时候覆盖的阴影图层是否存在 default is NO

/* PS: 字典key必须和这个例子一样，否则找不到配置数据
属性数据源结构:
params = @{
              @"x_offset"   :@"10",   //起始点横向偏移量            //不写默认 0
              @"y_offset"   :@"10",   //起始点纵向偏移量            //不写默认 0
              @"x_blank"    :@"10",   //两个瓦片之间横向空白距离      //不写默认 0
              @"y_blank"    :@"10",   //两个瓦片之间纵向空白距离      //不写默认 0
              @"tail_blank" :@"10"    //瓦片列表最后边添加的空白距离   //不写默认 0
          }
*/
@property (nonatomic, retain) NSDictionary *params; //位置属性，如果不写此属性，则默认瓦片之间没有任何间隔且从最左上开始平铺摆放，最下面也没有空白区域


//供外部使用的属性
@property (nonatomic, retain) UIScrollView     *contentView;            //内部容器view，用来做下拉刷新和内部所有元素的承载
@property (nonatomic, retain) ISRefreshControl *dragRefreshControll;    //用作下拉刷新得水滴效果controller,可以从外部调用此属性来修改文字或者颜色等效果


- (void)reloadTiles;  //读取瓦片数据源，绘制瓦片列表


@end











