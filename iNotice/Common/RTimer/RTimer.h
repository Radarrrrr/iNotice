//
//  RTimer.h
//  Radar Use
//
//  Version: v2.0
//
//  Created by Radar on 12-4-4.
//  Copyright 2010 Radar. All rights reserved.
//  

/*使用方法:
1. 添加头文件 #import "RTimer.h"
2. 添加 RTimerDelegate 协议
3. 创建timer (记得relesae)
 
    RTimer *timer = [[RTimer alloc] init];
    timer.delegate = self;
    timer.bRepeat = YES;
    timer.timeInterval = @"(10.0-20.0)"; //@"10.0" for non random, @"(10.0-20.0)" for random
   
2. 开启计时器
   [timer startTimer];
 
3. 关闭计时器
   [timer stopTimer];
 
4. 随时可以触发一次计时器返回
   [timer fireTimer];
*/

#import <Foundation/Foundation.h>


@class RTimer;
@protocol RTimerDelegate <NSObject>
@optional
-(void)rtimerDidFired:(RTimer*)rtimer;
@end


@interface RTimer : NSObject {

    //in use
	NSTimer *_timer;
    double _useTimerInterval;
    BOOL _bRandom;
    
    //out use
	BOOL _bRepeat;
    NSString *_timeInterval;  
	
@private
	id _delegate;		
}

@property (assign)              id <RTimerDelegate> delegate;
@property (nonatomic)           BOOL bRepeat;            //是否重复

//PS: 注意用英文写，不要用中文，否则判断会失误 (重要)
//1. 固定时间间隔, 设定格式为: @"10", 或者 @"10.0"
//2. 随机时间间隔, 设定格式为: @"(40-80)", 或者 @"(40.0-80.0)" 为最小时间和最大时间
@property (nonatomic, retain)   NSString *timeInterval;  //设定timer时间间隔, 单位:秒, 可设定小数点后位数, 表示毫秒


- (void)startTimer;  //开始计时器
- (void)stopTimer;   //停止计时器
- (void)fireTimer;   //立即触发timer一次


@end
