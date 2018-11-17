//
//  DDTilesView.m
//  CMSTestDemo
//
//  Created by Radar on 13-6-21.
//  Copyright (c) 2013年 www.dangdang.com. All rights reserved.
//

#import "DDTilesView.h"



#pragma mark -
#pragma mark in use params & functions
@interface DDTilesView ()


- (CGRect)rectForTile:(UIView*)tile; //获取该瓦片应该放置的区域位置
- (void)fixContentSize; //修正总体高度
- (void)clearContents;  //清空content上所有的内容

- (void)trigger:(DDTilesViewTrigger)triggerType; //触发刷新或者加载更多事件
- (void)checkLoadMore; //检测是否需要加载更多

- (void)dragRefreshAction:(ISRefreshControl *)refreshControl; //下拉刷新触发事件

- (void)fixHeaderLogo;
- (void)fixFooterLogo;

- (void)doneLoading; //关闭loading等待状态及标志

@end



@implementation DDTilesView
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize contentView = _contentView;
@synthesize dragRefreshControll = _dragRefreshControll;
@synthesize shadowEnabled = _shadowEnabled;
@dynamic params;
@dynamic loadMoreEnabled;
@dynamic refreshEnabled;
@dynamic headerLogo;
@dynamic footerLogo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        
        //初始化位置
        _xoffset = 0.0;  
        _yoffset = 0.0;
        _xblank = 0.0;
        _yblank = 0.0;
        _tailblank = 0.0;
        _useableX = _xoffset;
        _useableY = _yoffset;
        
        _loading = NO;
        _loadMoreEnabled = NO;
        _refreshEnabled = NO;
        _shadowEnabled = NO;
        
        
        //add _contentView
        self.contentView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.bounces = YES;
        _contentView.alwaysBounceVertical = YES;
        _contentView.delegate = self;
        _contentView.showsVerticalScrollIndicator = YES;
        _contentView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        [self addSubview:_contentView];
        
        
        //create _moreView
        _moreView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, ddtsv_more_view_height)];
        _moreView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _moreView.backgroundColor = [UIColor clearColor];
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((frame.size.width-20)/2, (ddtsv_more_view_height-20)/2, 20, 20)];
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [spinner startAnimating];
        [_moreView addSubview:spinner];
        [spinner release];
        
        
        //create _dragRefreshControll
        self.dragRefreshControll = [[[ISRefreshControl alloc] init] autorelease];
        [_dragRefreshControll addTarget:self action:@selector(dragRefreshAction:) forControlEvents:UIControlEventValueChanged];
    
    }
    return self;
}

- (void)dealloc
{
    [_params release];
    [_contentView release];
    [_moreView release];
    [_dragRefreshControll release];
    [_logoHeaderView release];
    [_logoFooterView release];
    
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    //绘制元素
    [self reloadTiles];
}





#pragma mark -
#pragma mark setter&getter functions
- (void)setParams:(NSDictionary *)aparams
{
    if(_params)
    {
        [_params release];
        _params = nil;
    }
    
    if(aparams)
    {
        _params = [aparams retain];
    }
    else
    {
        _params = nil;
    }
    
    
    //找到几个偏移量，用来绘制瓦片的位置的
    _xoffset = 0.0;  
    _yoffset = 0.0;
    _xblank = 0.0;
    _yblank = 0.0;
    _tailblank = 0.0;
    
    if(_params)
    {    
        NSString *xoStr = (NSString*)[_params objectForKey:@"x_offset"];
        if(xoStr) _xoffset = [xoStr floatValue];
        
        NSString *yoStr = (NSString*)[_params objectForKey:@"y_offset"];
        if(yoStr) _yoffset = [yoStr floatValue];
        
        NSString *xbStr = (NSString*)[_params objectForKey:@"x_blank"];
        if(xbStr) _xblank = [xbStr floatValue];
        
        NSString *ybStr = (NSString*)[_params objectForKey:@"y_blank"];
        if(ybStr) _yblank = [ybStr floatValue];
        
        NSString *tbStr = (NSString*)[_params objectForKey:@"tail_blank"];
        if(tbStr) _tailblank = [tbStr floatValue];
    }
    
}
- (NSDictionary*)params
{
    return _params;
}

- (void)setLoadMoreEnabled:(BOOL)enabled
{
    _loadMoreEnabled = enabled;
    
    if(_loadMoreEnabled)
    {
        if(![_moreView superview])
        {
            //如果没添加，那么添加
            [_contentView addSubview:_moreView];
        }
    }
    else
    {
        if([_moreView superview])
        {
            //如果已经添加，那么移除
            [_moreView removeFromSuperview];
        }
    }
    
    //刷新一下容器
    [self fixContentSize];
    
    [self fixFooterLogo];
    
}
- (BOOL)loadMoreEnabled
{
    return _loadMoreEnabled;
}

- (void)setRefreshEnabled:(BOOL)enabled
{
    _refreshEnabled = enabled;
    
    if(_refreshEnabled)
    {
        if(![_dragRefreshControll superview])
        {                
            [_contentView addSubview:_dragRefreshControll];
        }
        
    }
    else
    {
        if(_dragRefreshControll && [_dragRefreshControll superview])
        {
            [_dragRefreshControll removeFromSuperview];
        }
    }
    
    [self fixHeaderLogo];
    
}
-(BOOL)refreshEnabled
{
    return _refreshEnabled;
}


- (void)setHeaderLogo:(UIImage *)aheaderLogo
{
    [_headerLogo release];
    _headerLogo = nil;
    if(aheaderLogo)
    {
        _headerLogo = [aheaderLogo retain];
    }
    
    //创建logoview
    if(_headerLogo)
    {
        if(!_logoHeaderView)
        {
            _logoHeaderView = [[DDLogoView alloc] initWithPosition:ddPositionHeader onScroll:_contentView];
            _logoHeaderView.logo = _headerLogo;
        }
    }
    
    [self fixHeaderLogo];

}
- (UIImage*)headerLogo
{
    return _headerLogo;
}


- (void)setFooterLogo:(UIImage *)afooterLogo
{
    [_footerLogo release];
    _footerLogo = nil;
    if(afooterLogo)
    {
        _footerLogo = [afooterLogo retain];
    }
    
    //创建logoview
    if(_footerLogo)
    {
        if(!_logoFooterView)
        {
            _logoFooterView = [[DDLogoView alloc] initWithPosition:ddPositionFooter onScroll:_contentView];
            _logoFooterView.logo = _footerLogo;
        }
    }
    
    [self fixFooterLogo];
    
}
- (UIImage*)footerLogo
{
    return _footerLogo;
}





#pragma mark -
#pragma mark in use functions
- (CGRect)rectForTile:(UIView*)tile
{
    //获取该瓦片应该放置的区域位置
    if(!tile) return CGRectZero;
    
    //如果整个可显示区域都装不下一个瓦片，那么就直接返回zero了
    if(tile.frame.size.width > _contentView.contentSize.width-_xoffset*2)
    {
        return CGRectZero;
    }
    
    //其他情况下，才去做位置的判断
    float useableX = _xoffset;
    float useableY = _yoffset;
    float maxY = _yoffset;
    
    NSArray *subViews = [_contentView subviews];
    if(subViews && [subViews count] != 0)
    {
        //找到目前已有的subview的最远点xy
        for(UIView *subV in subViews)
        {
            if(![subV isKindOfClass:[DDTView class]])
            {
                continue;
            }
            
            CGRect subRect = subV.frame;
            float subXoff = subRect.origin.x + subRect.size.width;
            float subYoff = subRect.origin.y + subRect.size.height;
            
            //找到能提供最远点maxY的瓦片，用来当作基础点
            if(subYoff >= maxY)
            {
                maxY = subYoff;
                
                useableX = subXoff;
                useableY = subRect.origin.y;
            }
        }
    }
    
    //加上空白区域
    if(useableX > _xoffset)
    {
        useableX += _xblank;
    }
    if(maxY > _yoffset)
    {
        maxY += _yblank;
    }
    
    //获取总共的可用宽度
    float cntW  = _contentView.contentSize.width;
    CGSize tsize = tile.frame.size;
    float canuseW = cntW-useableX-_xoffset;
    
    
    //找到放置的位置
    float px;
    float py;
    
    //判断是否能放开
    if(tsize.width <= canuseW)
    {
        //可以放开，放在后面
        px = useableX;
        py = useableY;
    }
    else
    {
        //放不开，另起一行
        px = _xoffset;
        py = maxY;
    }
    
    //创建要放置的区域
    CGRect tileRect = CGRectMake(px, py, tsize.width, tsize.height);
    return tileRect;
}

- (void)fixContentSize
{
    //根据自己view上的所有的subview的frame，重新设定contentSize的大小
    CGRect sframe = _contentView.frame;
    float maxHeight = sframe.size.height;
    
    NSArray *subViews = [_contentView subviews];
    if(subViews && [subViews count] != 0)
    {
        //计算所有组件的位置和高度计算frame的大小
        for(UIView *subV in subViews)
        {
            if(![subV isKindOfClass:[DDTView class]])
            {
                continue;
            }
            
            CGRect subRect = subV.frame;
            float subHeight = subRect.origin.y + subRect.size.height;
            
            if(subHeight > maxHeight)
            {
                maxHeight = subHeight;
            }
        }
    }
    
    //加上tail_blank
    if(maxHeight > sframe.size.height)
    {
        maxHeight += _tailblank;
    }

    
    //设定读取更多view
    if(_loadMoreEnabled && [_moreView superview])
    {
        //改一下more的位置
        CGRect mframe = _moreView.frame;
        mframe.origin.y = maxHeight;
        _moreView.frame = mframe;
        
        //改一下content的高度
        maxHeight += mframe.size.height;
    }
    
    
    //重设定contentSize
    CGSize cntSize = _contentView.contentSize;
    cntSize.height = maxHeight;
    _contentView.contentSize = cntSize;
    
}

- (void)clearContents
{
    NSArray *subViews = [_contentView subviews];
    if(subViews && [subViews count] != 0)
    {
        for(UIView *subV in subViews)
        {            
            if([subV isKindOfClass:[DDTView class]])
            {
                [subV removeFromSuperview];
            }
        }
    }
}

- (void)trigger:(DDTilesViewTrigger)triggerType
{
    if(_loading) return;
    _loading = YES;
    
    //触发                
    if(_delegate && [_delegate respondsToSelector:@selector(tilesViewDidTrigger:)])
    {
        [_delegate tilesViewDidTrigger:triggerType];
    }
}

- (void)checkLoadMore
{
    if(!_loadMoreEnabled) return;
    if(_loading) return;
    
    CGPoint cntOffset = _contentView.contentOffset;
    CGSize  cntSize   = _contentView.contentSize;
    CGRect  rect      = _contentView.frame;
    CGRect  mframe    = _moreView.frame;
    
    if(cntOffset.y > cntSize.height-rect.size.height-mframe.size.height-ddtsv_load_more_back_offset)
    {
        [self trigger:DDTilesViewTriggerLoadMore];
    }
}
- (void)dragRefreshAction:(ISRefreshControl *)refreshControl
{
    //下拉刷新触发事件
    //只有当前读取状态是None的时候才触发刷新, 否则这次就算白下拉了
    if(!_refreshEnabled) return;
    
    if(!_loading)
    {
        [self trigger:DDTilesViewTriggerRefresh];
    }
    else
    {
        if(_dragRefreshControll)
        {
            [_dragRefreshControll endRefreshing];
        }
    }
}

- (void)fixHeaderLogo
{
    if(!_logoHeaderView) return;
    
    if(_headerLogo && !_refreshEnabled)
    {
        //添加headerlogo
        if(![_logoHeaderView superview])
        {
            [_contentView addSubview:_logoHeaderView];
        }
    }
    else
    {
        if([_logoHeaderView superview])
        {
            [_logoHeaderView removeFromSuperview];
        }
    }
}
- (void)fixFooterLogo
{
    if(!_logoFooterView) return;
    
    if(_footerLogo && !_loadMoreEnabled)
    {
        //添加footerlogo
        if(![_logoFooterView superview])
        {
            [_contentView addSubview:_logoFooterView];
        }
    }
    else
    {
        if([_logoFooterView superview])
        {
            [_logoFooterView removeFromSuperview];
        }
    }
}



- (void)doneLoading
{
    //关闭loading等待状态及标志
    _loading = NO;
    
    if(_refreshEnabled && _dragRefreshControll && [_dragRefreshControll superview] && _dragRefreshControll.refreshing)
    {
        //关闭刷新效果
        [_dragRefreshControll endRefreshing];
    }
}






#pragma mark -
#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector(tilesViewDidScroll:)])
	{
		[self.delegate tilesViewDidScroll:self];
	}
    
    
    //检查是否触发加载更多
    if(_loadMoreEnabled)
    {
        [self checkLoadMore];
    }
    
    //如果有logoview，做显示方面的改动
//    if(_refreshStyle == RefreshStyleNone)
//    {
//        if(_headerLogo && _logoHeaderView)
//        {
//            CGPoint cntOffset = _tableView.contentOffset;
//            if(cntOffset.y < 0)
//            {
//                float showHeight = -cntOffset.y;
//                [_logoHeaderView setShowHeight:showHeight];
//            }
//        }
//    }
    
//    if(_loadMoreStyle == LoadMoreStyleNone)
//    {
//        if(_footerLogo && _logoFooterView)
//        {
//            CGPoint cntOffset = _tableView.contentOffset;
//            CGSize  cntSize   = _tableView.contentSize;
//            CGRect  rect = _tableView.frame;
//            if(cntOffset.y > cntSize.height-rect.size.height)
//            {
//                float showHeight = cntOffset.y - (cntSize.height-rect.size.height);
//                [_logoFooterView setShowHeight:showHeight];
//            }
//        }
//    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector(tilesViewDidEndDecelerating:)])
	{
		[self.delegate tilesViewDidEndDecelerating:self];
	}
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(self.delegate && [(NSObject*)self.delegate respondsToSelector:@selector(tilesViewDidEndDragging:willDecelerate:)])
	{
		[self.delegate tilesViewDidEndDragging:self willDecelerate:decelerate];
	}
}





#pragma mark -
#pragma mark delegate functions
//DDTViewDelegate
- (void)DDTViewDidSelectIndex:(NSInteger)index tile:(UIView*)tile onDDTView:(DDTView*)ddtview
{
    //返回给代理，选中了那个瓦片
    if(_delegate && [_delegate respondsToSelector:@selector(tilesViewDidSelect:index:)])
    {
        [_delegate tilesViewDidSelect:tile index:index];
    }
}





#pragma mark -
#pragma mark out use functions
- (void)reloadTiles
{    
    //清空所有瓦片
    [self clearContents];
    
    //获取瓦片总数量
    NSInteger tilesCount = 0;
    if(_dataSource && [_dataSource respondsToSelector:@selector(numberOfTilesInTilesView:)])
    {
        tilesCount = [_dataSource numberOfTilesInTilesView:self];
    }
    
    //有瓦片才进行绘制
    if(tilesCount > 0)
    {
        //绘制瓦片
        for(int i=0; i<tilesCount; i++)
        {
            UIView *tileView = nil;
            if(_dataSource && [_dataSource respondsToSelector:@selector(tilesView:viewForIndex:)])
            {
                tileView = (UIView*)[_dataSource tilesView:self viewForIndex:i]; //tileView 是 autorelease
            }
            
            if(!tileView) continue;
            
            //拿到这个瓦片应该放置的位置
            CGRect tileRect = [self rectForTile:tileView];
            if(tileRect.size.width == 0 && tileRect.size.height == 0) continue;
                
            //设定瓦片在瓦片容器上的frame
            tileView.frame = CGRectMake(0, 0, tileRect.size.width, tileRect.size.height);
            
            //创建瓦片容器，把瓦片放容器上
            DDTView *ddtView = [[[DDTView alloc] initWithFrame:tileRect] autorelease];
            ddtView.delegate = self;
            ddtView.index = i;
            ddtView.tileView = tileView;
            ddtView.coverEnabled = _shadowEnabled;
            
            //检查瓦片是否有倒角，如果有，容器也倒角
            float radius = tileView.layer.cornerRadius;
            if(radius != 0.0)
            {
                ddtView.layer.cornerRadius = radius;
                ddtView.layer.masksToBounds = YES;
            }
            
            //添加瓦片
            [_contentView addSubview:ddtView];
        }
    }
    
    //根据里边所有的瓦片的位置，重新修正一下contentSize的大小
    [self fixContentSize];
    
    //关闭loading等待状态及标志
    [self doneLoading];
}





@end
