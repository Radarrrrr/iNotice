//
//  DDLogoView.m
//  CMSTableViewDemo
//
//  Created by Radar on 13-5-28.
//  Copyright (c) 2013年 www.dangdang.com. All rights reserved.
//

#import "DDLogoView.h"


@interface DDLogoView ()

- (void)adjustLogoViewPositon:(float)showHeight;

- (void)fixLogoPosition:(UIScrollView*)scrollView; //根据相关的scrollview的各种位置属性，修正logo的显示效果
- (void)fixFooterOffset:(UIScrollView*)scrollView; //如果是放在ddPositionFooter的位置，那么再改变了scrollView的contentSize以后，必须调用一次此方法，来重新设定footer的位置

@end


@implementation DDLogoView
@dynamic logo;

- (id)initWithPosition:(DDLogoViewPosition)position onScroll:(UIScrollView*)scrollView
{
    if(!scrollView) return nil;
    
    CGRect frame = CGRectMake(0, -1000, scrollView.frame.size.width, 1000);
    if(position == ddPositionFooter)
    {
        frame = CGRectMake(0, scrollView.contentSize.height, scrollView.frame.size.width, 1000);
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _position = position;
        
        //add _logoView
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_logoView];
        
    }
    return self;
}


- (void)dealloc
{
    [_logo release];
    [_logoView release];
    
    [super dealloc];
}


- (void)setLogo:(UIImage*)alogo
{
    [_logo release];
    
    if(alogo)
    {
        _logo = [alogo retain];
    }
    else
    {
        _logo = nil;
    }
    
    _logoView.image = _logo;
    
    //根据图片大小，调整_logoView的大小和位置
    CGRect sframe = self.frame;
    CGRect lframe = _logoView.frame;
    
    //如果图片过大，按照最宽处理
    CGSize logoSize = _logo.size;
    if(logoSize.width > sframe.size.width)
    {
        float k = logoSize.width/logoSize.height;
        
        logoSize.width = sframe.size.width;
        logoSize.height = logoSize.width/k;
    }
    
        
    lframe.size = logoSize;
    lframe.origin.x = (self.frame.size.width-logoSize.width)/2;
    
    if(_position == ddPositionHeader)
    {
        lframe.origin.y = sframe.size.height - logoSize.height;
    }
    else if(_position == ddPositionFooter)
    {
        lframe.origin.y = 0;
    }
    
    _logoView.frame = lframe;
}





#pragma mark -
#pragma mark in use functions
- (void)adjustLogoViewPositon:(float)showHeight
{
    if(!_logo) return;
    
    //根据当前frame的大小，调整_logoView的显示位置
    CGRect sframe = self.frame;
    CGRect lframe = _logoView.frame;
    
    float logoH = _logoView.frame.size.height;
    float logoY = 0.0;
    
    if(showHeight <= logoH)
    {
        //如果可显示区域比logo小，那么贴着一边放置
        if(_position == ddPositionHeader)
        {
            logoY = sframe.size.height - lframe.size.height;
        }
        else if(_position == ddPositionFooter)
        {
            logoY = 0.0;
        }
    }
    else
    {
        //如果可显示区域比logo大，那么放在可见区域的中间
        float blank = (showHeight-logoH)/2;
        
        if(_position == ddPositionHeader)
        {
            
            logoY = sframe.size.height - lframe.size.height - blank;
        }
        else if(_position == ddPositionFooter)
        {
            logoY = blank;
        }
    }
    
    //修改_logoView的位置
    lframe.origin.y = logoY;
    _logoView.frame = lframe;
}






#pragma mark -
#pragma mark KVO fix functions
- (void)fixLogoPosition:(UIScrollView*)scrollView
{
    if(!scrollView) return;
    
    //根据相关的scrollview的各种位置属性，修正logo的显示效果
    float showHeight = 0.0;
    
    CGPoint cntOffset = scrollView.contentOffset;
    CGSize  cntSize   = scrollView.contentSize;
    CGRect  rect = scrollView.frame;
    
    if(cntSize.height<rect.size.height)
    {
        cntSize = scrollView.frame.size;
    }
    
    if(cntOffset.y > cntSize.height-rect.size.height)
    {
        //footer向上显示出来
        showHeight = cntOffset.y - (cntSize.height-rect.size.height);
    }
    else if(cntOffset.y < 0)
    {
        showHeight = -cntOffset.y;
    }

    //改动showHeight
    [self adjustLogoViewPositon:showHeight];
}

- (void)fixFooterOffset:(UIScrollView*)scrollView
{
    if(!scrollView) return;
    
    if(_position == ddPositionFooter)
    {
        CGSize  cntSize   = scrollView.contentSize;
        
        CGRect fframe = self.frame;
        fframe.origin.y = cntSize.height;
        self.frame = fframe;
    }
}






#pragma mark -
#pragma mark - KVO 监听UIScrollView属性变化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if ([self.superview isKindOfClass:[UIScrollView class]]) 
    {
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
        [self.superview removeObserver:self forKeyPath:@"contentSize"];
    }
}
- (void)didMoveToSuperview
{
    if ([self.superview isKindOfClass:[UIScrollView class]]) 
    {
        [self.superview addObserver:self forKeyPath:@"contentOffset" options:0 context:NULL];
        [self.superview addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == self.superview && [keyPath isEqualToString:@"contentOffset"]) 
    {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        [self fixLogoPosition:scrollView];
        return;
    }
    else if(object == self.superview && [keyPath isEqualToString:@"contentSize"])
    {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        [self fixFooterOffset:scrollView];
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}





@end
