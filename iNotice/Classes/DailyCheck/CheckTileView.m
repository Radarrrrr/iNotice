//
//  CheckTileView.m
//  iNotice
//
//  Created by Radar on 14/10/18.
//
//

#import "CheckTileView.h"



@implementation CheckTileView
@synthesize delegate = _delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [DDFunction addRadiusToView:self radius:5];
        
        //add 背景
        UIView *backV = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        backV.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        backV.backgroundColor = DDCOLOR_BLUE;
        backV.alpha = 0.5;
        [self addSubview:backV];
        
        //add 文字
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _descLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _descLabel.backgroundColor = [UIColor clearColor];
        _descLabel.userInteractionEnabled = NO;
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.numberOfLines = 0;
        _descLabel.font = DDFONT_B(12);
        _descLabel.textColor = [UIColor whiteColor];
        [self addSubview:_descLabel];
        
        //是否完成标记图
        _doneV = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-20-2.5, frame.size.height-20+1, 20, 20)];
        _doneV.image = [UIImage imageNamed:@"icon_done"];
        _doneV.userInteractionEnabled = NO;
        _doneV.alpha = 0.0;
        [self addSubview:_doneV];
        
        
        //长按触发编辑
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];  
        longPressGestureRecognizer.minimumPressDuration = 0.5f;
        longPressGestureRecognizer.numberOfTouchesRequired = 1;
        longPressGestureRecognizer.enabled = YES;        
        [self addGestureRecognizer:longPressGestureRecognizer];
        [longPressGestureRecognizer release]; 
        
    }
    return self;
}

- (void)setCheckInfo:(CheckInfo *)checkInfo
{
    if(_checkInfo)
    {
        [_checkInfo release];
        _checkInfo = nil;
    }
    
    if(!checkInfo) return;
    _checkInfo = [checkInfo retain];
    
    //处理文字
    _descLabel.text = _checkInfo.infoDesc;
    
    //处理完成状态
    if(_checkInfo.isDone)
    {
        _doneV.alpha = 1.0;
        [DDFunction addBorderToView:self color:RGB(117, 200, 28) lineWidth:2];
    }
    else
    {
        _doneV.alpha = 0.0;
        [DDFunction addBorderToView:self color:[UIColor clearColor] lineWidth:2];
    }
}

- (void)dealloc
{
    [_descLabel release];
    [_checkInfo release];
    [_doneV release];
    
    [super dealloc];
}



//长按触发编辑
- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(![gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) return;
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        //返回代理 //触发编辑状态        
        if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(CheckTileViewDidTrigerEdit:)])
        {
            [self.delegate CheckTileViewDidTrigerEdit:self];
        }
    }
}



@end
