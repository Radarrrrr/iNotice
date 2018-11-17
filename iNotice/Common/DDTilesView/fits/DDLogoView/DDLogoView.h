//
//  DDLogoView.h
//  CMSTableViewDemo
//
//  Created by Radar on 13-5-28.
//  Copyright (c) 2013年 www.dangdang.com. All rights reserved.
//

/*使用方法
 //创建本类，使用position决定是放在header还是footer位置（两个位置需要单独创建并添加）
 DDLogoView *logoV = [[DDLogoView alloc] initWithPosition:ddPositionFooter onScroll:contentView];
 logoV.logo = [UIImage imageNamed:@"logo.png"];
 [contentView addSubview:logoV];
 [logoV release];
*/


#import <UIKit/UIKit.h>


typedef enum {
    ddPositionHeader = 0, //logoView放在滚动页面header的位置
    ddPositionFooter      //logoView放在滚动页面footer的位置
} DDLogoViewPosition;


@interface DDLogoView : UIView {
 
    UIImageView *_logoView;
    DDLogoViewPosition _position;//logo要放置在DDLogoView的顶部还是底部，用于区别放在外面滚动页的上方还是下方
    
    UIImage *_logo;
}

@property (nonatomic, retain) UIImage *logo;        //要显示的logo图片，必须从外部设定，否则就无效果

- (id)initWithPosition:(DDLogoViewPosition)position onScroll:(UIScrollView*)scrollView; //scrollView属性可以是UIScrollView或者UITableView


@end
