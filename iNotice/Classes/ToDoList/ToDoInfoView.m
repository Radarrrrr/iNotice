//
//  ToDoInfoView.m
//  iNotice
//
//  Created by Radar on 14-9-3.
//
//

#import "ToDoInfoView.h"


#define canvas_pos_init  SCR_HEIGHT-20-44-200-10


@implementation ToDoInfoView


- (id)initWithToDoInfo:(ToDoInfo*)info
{
    CGRect frame = CGRectMake(0, 0, 320, SCR_HEIGHT-20-44);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.info = info;
        self.belongsArray = [self createBelongsArray];
        
        _selBelongIndex = 0;
        self.status = ToDoInfoViewStatusNone;
        
        
        //添加_canvasView
        float cposY = canvas_pos_init;
        if(!_info) cposY = 64;
        
        self.canvasView = [[[UIView alloc] initWithFrame:CGRectMake(10, cposY, SCR_WIDTH-20, 200)] autorelease];
        _canvasView.backgroundColor = RGB(223, 238, 207);
        [DDFunction addRadiusToView:_canvasView radius:8];
        [self addSubview:_canvasView];
        
        
        //add _inputView
        _inputView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(_canvasView.frame)-20, 110)];
        _inputView.backgroundColor = [UIColor clearColor];//RGBS(240);
        _inputView.delegate = self;
        _inputView.textColor = DDCOLOR_TEXT_B;
        _inputView.font = DDFONT_B(14);
        [_canvasView addSubview:_inputView];
        
        //add line
        UIView *line = [[[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_inputView.frame), CGRectGetWidth(_canvasView.frame)-20, 0.5)] autorelease];
        line.backgroundColor = RGBS(200);
        [_canvasView addSubview:line];
        
        
        //add savebtn
        _saveBtn = [[UIButton buttonWithColor:DDCOLOR_BLUE selColor:nil] retain];
        _saveBtn.frame = CGRectMake(CGRectGetWidth(_canvasView.frame)-5-60, CGRectGetHeight(_canvasView.frame)-5-40, 60, 40);
        [DDFunction addRadiusToView:_saveBtn radius:6];
        [_saveBtn setTitle:@"done" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = DDFONT_B(14);
        [_saveBtn addTarget:self action:@selector(doneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn.enabled = NO;
        [_canvasView addSubview:_saveBtn];
    
        
        //add belongs buttons
        [self addBelongsButtons];
        
        
        //add _noticeLine
        _noticeLine = [[UIView alloc] initWithFrame:CGRectMake(0, 25, CGRectGetWidth(_inputView.frame), 1.5)];
        _noticeLine.backgroundColor = DDCOLOR_GOLD;
        _noticeLine.userInteractionEnabled = NO;
        _noticeLine.alpha = 0.0;
        [_inputView addSubview:_noticeLine];
        
        
        //add _noticeCircle
        _noticeCircle = [[UIView alloc] initWithFrame:CGRectMake(7, CGRectGetMaxY(_inputView.frame)+4, 300-5-60-5-2-2, CGRectGetHeight(_canvasView.frame)-CGRectGetMaxY(_inputView.frame)-3-6)];
        _noticeCircle.backgroundColor = [UIColor clearColor];
        _noticeCircle.userInteractionEnabled = NO;
        [DDFunction addRadiusToView:_noticeCircle radius:6];
        [DDFunction addBorderToView:_noticeCircle color:DDCOLOR_GOLD lineWidth:1.5];
        _noticeCircle.alpha = 0.0;
        [_canvasView addSubview:_noticeCircle];
        
        
        //init status
        [self initViewStatus];
        
        
    }
    return self;
}

- (void)dealloc
{
    [_info release];
    [_canvasView release];
    [_inputView release];
    [_belongsArray release];
    [_saveBtn release];
    [_noticeLine release];
    [_noticeCircle release];
        
    [super dealloc];
}


- (void)drawRect:(CGRect)rect
{
    
}




#pragma mark -
#pragma mark in use functions
- (NSArray *)createBelongsArray
{
    NSArray *belongsArr = @[
                            @{@"belong":@"既紧急又重要", @"color":RGB(251, 11, 28)},
                            @{@"belong":@"紧急但不重要", @"color":RGB(251, 70, 76)},
                            @{@"belong":@"重要但不紧急", @"color":RGB(253, 153, 45)},
                            @{@"belong":@"不紧急也不重要", @"color":RGB(83, 162, 215)},
                            @{@"belong":@"我的提醒", @"color":RGB(141, 224, 72)} 
                           ];
    
    return belongsArr;
}

- (void)addBelongsButtons
{
    if(!ARRAYVALID(_belongsArray)) return;
    
    float x = 10;
    float y = CGRectGetMaxY(_inputView.frame)+7;
    
    for(int i=0; i<[_belongsArray count]; i++)
    {
        NSDictionary *belong = [_belongsArray objectAtIndex:i];
        
        NSString *note  = [belong objectForKey:@"belong"];
        UIColor  *color = [belong objectForKey:@"color"];
        
        float width = [DDFunction getWidthForString:note font:DDFONT(10) height:30] + 10;
        
        UIButton *btn = [UIButton buttonWithColor:color selColor:nil];
        btn.frame = CGRectMake(x, y, width, 30);
        [DDFunction addRadiusToView:btn radius:4];
        [btn setTitle:note forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = DDFONT_B(10);
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_canvasView addSubview:btn];
        
        
        if(i<2)
        {
            x = x + width + 5;
        }
        else if(i == 2)
        {
            x = 10;
            y = y + CGRectGetHeight(btn.frame) + 5;
        }
        else
        {
            x = x+width+5;
        }
    }
}

- (void)initViewStatus
{
    if(_info)
    {
        _inputView.text = _info.infoDesc;
        _selBelongIndex = _info.belongIndex;
    }
    else
    {
        //_inputView.text = @"写下你要做的事情...";
        [_inputView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.25];
    }
    
    [self selectBelong:_selBelongIndex];
}

- (void)changToEditMode:(BOOL)bedit
{
    CGRect iframe = _canvasView.frame;
    
    if(bedit)
    {
        if(iframe.origin.y == 0) return;
        iframe.origin.y = 0;
        _saveBtn.enabled = YES;
        _inputView.textColor = DDCOLOR_TEXT_A;
    }
    else
    {
        if(iframe.origin.y == canvas_pos_init) return;
        iframe.origin.y = canvas_pos_init;
        _saveBtn.enabled = NO;
        _inputView.textColor = DDCOLOR_TEXT_B;
    }
    
    //如果是新建，则不做任何移动
    if(!_info) return;
    
    [UIView animateWithDuration:0.3 
                     animations:^{
                         _canvasView.frame = iframe;
                     }];
}

- (void)selectAction:(UIButton*)btn
{
    NSInteger toindex = btn.tag-100;
    
    //有变化就变成编辑模式
    if(toindex != _selBelongIndex)
    {
        [self changToEditMode:YES];
    }
    
    _selBelongIndex = toindex;
    
    //选中对应的按钮
    [self selectBelong:_selBelongIndex];
}

- (void)selectBelong:(NSInteger)belongindex
{
    NSInteger useBtnTag = 100+belongindex;
    
    //选中对应的按钮
    for(int i=0; i<[_belongsArray count]; i++)
    {
        UIColor *tocolor = [UIColor clearColor];
        
        UIButton *tbtn = (UIButton*)[_canvasView viewWithTag:100+i];
        if(tbtn.tag == useBtnTag)
        {
            //是选中的按钮
            tocolor = DDCOLOR_GOLD;
        }
        
        [DDFunction addBorderToView:tbtn color:tocolor lineWidth:2.0];
    }
}

- (void)doneBtnAction:(id)sender
{
    if(!STRVALID(_inputView.text)) 
    {
        [self flashView:_noticeLine];
        return;
    }
    
    if(_selBelongIndex == -1) 
    {
        [self flashView:_noticeCircle];
        return;
    }
    
    if(!_info)
    {
        //添加新的记录
        ToDoInfo *info = [[[ToDoInfo alloc] init] autorelease];
        //info.todoID =     //获取一个新的编号
        info.infoDesc = _inputView.text;
        info.belongIndex = _selBelongIndex;
        info.createTime = [DDFunction stringFromDate:[NSDate date] useFormat:@"yyyy-MM-dd HH:mm"];
        
        self.info = info;
        self.status = ToDoInfoViewStatusAdd;
    }
    else
    {
        if([_info.infoDesc isEqualToString:_inputView.text] && _info.belongIndex == _selBelongIndex)
        {
            //完全没变
            self.status = ToDoInfoViewStatusNone;
        }
        else
        {
            self.info.infoDesc = _inputView.text;
            self.info.belongIndex = _selBelongIndex;
            self.info.createTime = [DDFunction stringFromDate:[NSDate date] useFormat:@"yyyy-MM-dd HH:mm"];
            self.status = ToDoInfoViewStatusModify;
        }
    }
    
    
    if([_inputView isFirstResponder])
    {
        [_inputView resignFirstResponder];
    }
    
    [[DDSlideLayer sharedLayer] closeSlideLayer];
}

- (void)flashView:(UIView*)view
{
    //让某一个view闪动
    if(!view) return;
    view.alpha = 0.0;
    
    [UIView animateWithDuration:0.5 
                     animations:^{
                         view.alpha = 1.0;
                     } 
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.5 
                                          animations:^{
                                              view.alpha = 0.0;
                                          } 
                                          completion:^(BOOL finished) {
                                              
                                              [UIView animateWithDuration:0.5 
                                                               animations:^{
                                                                   view.alpha = 1.0;
                                                               } 
                                                               completion:^(BOOL finished) {
                                                                   
                                                                   [UIView animateWithDuration:0.5 
                                                                                    animations:^{
                                                                                        view.alpha = 0.0;
                                                                                    } 
                                                                                    completion:^(BOOL finished) {
                                                                                    }];
                                                                   
                                                               }];
                                          }];
                         
                     }];
}






#pragma mark -
#pragma mark delegate functions
- (void)textViewDidBeginEditing:(UITextView *)textView
{    
    [self changToEditMode:YES];
    
    if(!_info)
    {
        _inputView.text = nil;
    }
}




#pragma mark -
#pragma mark touches functions
- (void) touchesCanceled 
{
}
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event 
{
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event 
{
}
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event 
{
	NSSet *allTouches = [event allTouches];
	
    switch ([allTouches count]) {
        case 1: 
		{
            UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			CGPoint tapPoint = [touch locationInView:self];
			
            switch (touch.tapCount) 
			{
                case 1: 
				{				
                    BOOL bin = CGRectContainsPoint(_canvasView.frame, tapPoint);
					if(!bin)
                    {
                        self.status = ToDoInfoViewStatusNone;
                        
                        if([_inputView isFirstResponder])
                        {
                            [_inputView resignFirstResponder];
                        }
                        
                        [[DDSlideLayer sharedLayer] closeSlideLayer];
                    }
				}
					break;
				default:
					break;
            }
        }
			break;
		default:
			break;
	}
}





@end
