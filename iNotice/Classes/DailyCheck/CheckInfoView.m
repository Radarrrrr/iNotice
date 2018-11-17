//
//  CheckInfoView.m
//  iNotice
//
//  Created by Radar on 14-9-3.
//
//

#import "CheckInfoView.h"


#define canvas_pos_init  SCR_HEIGHT-20-44-200-10


@implementation CheckInfoView


- (id)initWithCheckInfo:(CheckInfo*)info forIndex:(NSInteger)tileIndex
{
    CGRect frame = CGRectMake(0, 0, 320, SCR_HEIGHT-20-44);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.info = info;
        self.tileIndex = tileIndex;
        self.status = CheckInfoViewStatusNone;
        
        
        //添加_canvasView
        float cposY = canvas_pos_init;
        if(!_info) cposY = 64;
        
        self.canvasView = [[[UIView alloc] initWithFrame:CGRectMake(10, cposY, SCR_WIDTH-20, 200)] autorelease];
        _canvasView.backgroundColor = RGB(223, 238, 207);
        [DDFunction addRadiusToView:_canvasView radius:8];
        [self addSubview:_canvasView];
        
        
        //add _inputView
        _inputView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(_canvasView.frame)-5-60-5-10, CGRectGetHeight(_canvasView.frame)-20)];
        _inputView.backgroundColor = [UIColor clearColor];//RGBS(240);
        _inputView.delegate = self;
        _inputView.textColor = DDCOLOR_TEXT_B;
        _inputView.font = DDFONT_B(14);
        [_canvasView addSubview:_inputView];
        
        //add line
        UIView *line = [[[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_canvasView.frame)-5-60-5, 10, 0.5, CGRectGetHeight(_canvasView.frame)-20)] autorelease];
        line.backgroundColor = RGBS(220);
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
        
        
        //add deletebtn
        _deleteBtn = [[UIButton buttonWithColor:DDCOLOR_BLUE selColor:nil] retain];
        _deleteBtn.frame = CGRectMake(CGRectGetWidth(_canvasView.frame)-5-60, CGRectGetHeight(_canvasView.frame)-5-40-5-40, 60, 40);
        [DDFunction addRadiusToView:_deleteBtn radius:6];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = DDFONT_B(14);
        [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.alpha = 0.0;
        [_canvasView addSubview:_deleteBtn];
    

        //add _noticeLine
        _noticeLine = [[UIView alloc] initWithFrame:CGRectMake(0, 25, CGRectGetWidth(_inputView.frame)-5, 1.5)];
        _noticeLine.backgroundColor = DDCOLOR_GOLD;
        _noticeLine.userInteractionEnabled = NO;
        _noticeLine.alpha = 0.0;
        [_inputView addSubview:_noticeLine];
        
        
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
    [_saveBtn release];
    [_deleteBtn release];
    [_noticeLine release];
        
    [super dealloc];
}


- (void)drawRect:(CGRect)rect
{
    
}




#pragma mark -
#pragma mark in use functions
- (void)initViewStatus
{
    if(_info)
    {
        _deleteBtn.alpha = 1.0;
        _inputView.text = _info.infoDesc;
    }
    else
    {
        _deleteBtn.alpha = 0.0;
        [_inputView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.25];
    }
}

- (void)changToEditMode:(BOOL)bedit
{
    CGRect iframe = _canvasView.frame;
    
    if(bedit)
    {
        if(iframe.origin.y == 0) return;
        iframe.origin.y = 0;
        _saveBtn.enabled = YES;
        _deleteBtn.alpha = 0.0;
        _inputView.textColor = DDCOLOR_TEXT_A;
    }
    else
    {
        if(iframe.origin.y == canvas_pos_init) return;
        iframe.origin.y = canvas_pos_init;
        _saveBtn.enabled = NO;
        _deleteBtn.alpha = 1.0;
        _inputView.textColor = DDCOLOR_TEXT_B;
    }
    
    //如果是新建，则不做任何移动
    if(!_info) return;
    
    [UIView animateWithDuration:0.3 
                     animations:^{
                         _canvasView.frame = iframe;
                     }];
}


- (void)doneBtnAction:(id)sender
{
    if(!STRVALID(_inputView.text)) 
    {
        [self flashView:_noticeLine];
        return;
    }
    
    
    if(!_info)
    {
        //添加新的记录
        CheckInfo *info = [[[CheckInfo alloc] init] autorelease];
        info.infoDesc = _inputView.text;
        info.isDone = NO;
        
        self.info = info;
        self.status = CheckInfoViewStatusAdd;
    }
    else
    {
        if([_info.infoDesc isEqualToString:_inputView.text])
        {
            //完全没变
            self.status = CheckInfoViewStatusNone;
        }
        else
        {
            //改了内容
            self.info.infoDesc = _inputView.text;
            self.status = CheckInfoViewStatusModify;
        }
    }
    
    
    if([_inputView isFirstResponder])
    {
        [_inputView resignFirstResponder];
    }
    
    [[DDSlideLayer sharedLayer] closeSlideLayer];
}

- (void)deleteBtnAction:(id)sender
{
    if(_tileIndex == -1) return;

    self.status = CheckInfoViewStatusDelete;
    
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
                        self.status = CheckInfoViewStatusNone;
                        
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
