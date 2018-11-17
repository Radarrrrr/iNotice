//
//  RTimer.m
//  Radar Use
//
//  Created by Radar on 12-4-4.
//  Copyright 2010 Radar. All rights reserved.
//  

#import "RTimer.h"


#pragma mark -
#pragma mark in use functions & params
@interface RTimer ()

@property (nonatomic, retain) NSTimer *timer;

- (BOOL)checkIfRandom; //检查是否随机
- (double)randomTimeInterval; //计算随机时间
- (double)randomFrom:(double)num1 to:(double)num2; //在两个数之间做随机数
- (void)timerFireMethod;

@end



@implementation RTimer
@synthesize delegate=_delegate;
@synthesize timer = _timer;
@synthesize bRepeat = _bRepeat;
@dynamic timeInterval;



#pragma mark -
#pragma mark system functions
- (id)init {
    self = [super init];
    if (self)
    {
        _useTimerInterval = 0.0;
        _bRandom = NO;
    }
    return self;
}

- (void)dealloc
{
	[self stopTimer];
	
    [_timeInterval release];
	[_timer release];
	[super dealloc];
}


- (void)setTimeInterval:(NSString *)atime
{
    //设定_timeInterval
    [_timeInterval release];
    _timeInterval = [atime retain];
        
    //判定_bRandom
    _bRandom = [self checkIfRandom];
}




#pragma mark -
#pragma mark in use functions
- (BOOL)checkIfRandom
{
    // 10.0 or (10.0-40.0)
    BOOL bRand = NO;
    
    if(_timeInterval)
    {
        NSRange range1 = [_timeInterval rangeOfString:@"("];
        NSRange range2 = [_timeInterval rangeOfString:@"-"];
        NSRange range3 = [_timeInterval rangeOfString:@")"];
        if(range1.length != 0 && range2.length != 0 && range3.length != 0)
        {
            //完全符合要求，才可以认定为是随机方式
            bRand = YES;
        }
    }
    
    return bRand;
}
- (double)randomTimeInterval
{
    if(!_timeInterval) return 0.0;
    
    NSString *randomString = _timeInterval;
    randomString = [randomString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    randomString = [randomString stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    NSArray *ranArr = [randomString componentsSeparatedByString:@"-"];
    if(!ranArr || [ranArr count] != 2) return 0.0; 
    
    double minRan = [(NSString*)[ranArr objectAtIndex:0] doubleValue];
    double maxRan = [(NSString*)[ranArr objectAtIndex:1] doubleValue];

    double ranTime = [self randomFrom:minRan to:maxRan];
    return ranTime;
}
- (double)randomFrom:(double)num1 to:(double)num2
{
    int startVal = num1*10000;
    int endVal = num2*10000; 
    
    int randomValue = startVal +(arc4random()%(endVal - startVal));
    double a = randomValue;
    
    return(a/10000.0);
}

- (double)createUseTimeInterval
{
    double ausetime = 0.0;
    
    if(!_bRandom)
    {
        ausetime = [_timeInterval doubleValue];
    }
    else
    {
        ausetime = [self randomTimeInterval]; 
    }
    
    return ausetime;
}


- (void)timerFireMethod
{
	//return to delegate 
	if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(rtimerDidFired:)])
	{
		[self.delegate rtimerDidFired:self];
	}
    
    //如果是随机时间timer，那么根据_bRepeat判断是否继续
    if(_bRandom && _bRepeat)
    {
        [self stopTimer];
        [self startTimer];
    }
}





#pragma mark -
#pragma mark out use functions
- (void)startTimer
{
    _useTimerInterval = [self createUseTimeInterval];
    if(_useTimerInterval == 0.0) return;
    
    BOOL bUseRepeat = _bRepeat;
    if(_bRandom)
    {
        bUseRepeat = NO;
    }
    
	self.timer =  [NSTimer scheduledTimerWithTimeInterval:_useTimerInterval
													target:self 
												  selector:@selector(timerFireMethod) 
												  userInfo:nil 
												   repeats:bUseRepeat];
}
- (void)stopTimer
{
	if(_timer && [_timer isValid])
	{
		[_timer invalidate];
	}	
}
- (void)fireTimer
{
	[_timer fire];
}






@end
