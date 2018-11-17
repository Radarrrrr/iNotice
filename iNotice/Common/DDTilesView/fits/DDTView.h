//
//  DDTView.h
//  DDDevLib
//
//  Created by Radar on 13-8-7.
//  Copyright (c) 2013年 www.dangdang.com. All rights reserved.
//
//PS: 本类是所有瓦片下面的容器，用来处理点击操作和内置index的返回等



#import <UIKit/UIKit.h>


//按下去的时候出现的cover的颜色和alpha值，由于项目中只需要设定一种风格，所以这两个属性由宏来设定
#define ddtview_cover_color [UIColor darkGrayColor]
#define ddtview_cover_alpha 0.5


@class DDTView;

//delegate方法
@protocol DDTViewDelegate<NSObject>
@optional

- (void)DDTViewDidSelectIndex:(NSInteger)index tile:(UIView*)tile onDDTView:(DDTView*)ddtview;

@end


@interface DDTView : UIView {
    
    NSInteger _index; 
    UIView   *_tileView; 
    
    BOOL _coverEnabled;
    
@private
	id _delegate;		
}

@property (assign) id <DDTViewDelegate> delegate;
@property (nonatomic)         NSInteger index;          //本瓦片的index
@property (nonatomic, retain) UIView    *tileView;      //本瓦片内部的tile，由外部设定给的真实的瓦片
@property (nonatomic)         BOOL      coverEnabled;   //是否点击有覆盖层效果，default is NO




@end
