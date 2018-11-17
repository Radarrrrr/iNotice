//
//  DDTView.m
//  DDDevLib
//
//  Created by Radar on 13-8-7.
//  Copyright (c) 2013年 www.dangdang.com. All rights reserved.
//


#import "DDTView.h"



#pragma mark -
#pragma mark in use params & functions
@interface DDTView ()

- (void)tapAction; //本类上点击一次事件
- (void)addCover;
- (void)removeCover;

@end



@implementation DDTView
@synthesize delegate = _delegate;
@synthesize index = _index;
@synthesize coverEnabled = _coverEnabled;
@dynamic tileView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _coverEnabled = NO;
    }
    return self;
}

- (void)dealloc
{
    [_tileView release];
    
    [super dealloc];
}


- (void)setTileView:(UIView *)atileView
{
    if(_tileView)
    {
        if([_tileView superview])
        {
            [_tileView removeFromSuperview];
        }
        [_tileView release];
        _tileView = nil;
    }
    
    if(atileView)
    {
        _tileView = [atileView retain];
        [self addSubview:_tileView];
    }        
}

- (UIView*)tileView
{
    return _tileView;
}





#pragma mark -
#pragma mark in use functions
- (void)tapAction
{
    //本类上点击一次事件
    if(_delegate && [_delegate respondsToSelector:@selector(DDTViewDidSelectIndex:tile:onDDTView:)])
    {
        [_delegate DDTViewDidSelectIndex:_index tile:_tileView onDDTView:self];
    }
}

- (void)addCover
{
    UIView *cover = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
    cover.backgroundColor = ddtview_cover_color;
    cover.alpha = ddtview_cover_alpha;
    cover.tag = 100000;
    [self addSubview:cover];
}
- (void)removeCover
{
    UIView *cover = [self viewWithTag:100000];
    if(cover && [cover superview])
    {
        [cover removeFromSuperview];
    }
}



#pragma mark -
#pragma mark touches functions
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event; 
{
    if(_coverEnabled)
    {
        [self removeCover];
    }
}
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event 
{
    if(_coverEnabled)
    {
        [self addCover];
    }
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event 
{    
}
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event 
{
    if(_coverEnabled)
    {
        [self removeCover];
    }
    
    NSSet *allTouches = [event allTouches];
    switch ([allTouches count]) {
        case 1: 
		{
            UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
            CGPoint tPoint = [touch locationInView:self];
            
            CGRect sRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            BOOL inView = CGRectContainsPoint(sRect, tPoint);
            if(inView)
            {
                [self tapAction];
            }
        }
			break;
		default:
			break;
	}
}



@end
