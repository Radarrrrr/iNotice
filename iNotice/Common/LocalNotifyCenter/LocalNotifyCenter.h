//
//  LocalNotifyCenter.h
//  TestSthDemo
//
//  Created by Radar on 15/1/15.
//  Copyright (c) 2015年 www.dangdang.com. All rights reserved.
//

//说明
//info: @{
//          @"source":@"xxxxx",                //来源页面的identifier
//          @"fire_date":@"YY-MM-dd HH:mm:ss", //该通知的触发时间，字符串格式
//          @"fire_msg":@"xxxxx",              //该通知触发时显示在提示上的文字信息
//          @"link_url":@"xxxxx"               //通知返回到程序里时候，用来做跳转定位的跳转链接
//       }


#import <Foundation/Foundation.h>

@interface LocalNotifyCenter : NSObject


//注册本地通知
+ (void)registerNotify:(NSDate *)fireDate 
               message:(NSString *)message
                  info:(NSDictionary *)infoDic        //UILocalNotification 的 userInfo字段，用来记录要传递的内容
        repeatInterval:(NSCalendarUnit)repeatInterval // 0 means don't repeat
                 sound:(NSString *)soundName
                 badge:(NSInteger)badge;

//注册本地通知 - 简化方法
+ (void)registerNotifyWithInfo:(NSDictionary *)info;  //只用info来规划本地通知 info: @{@"source":@"xxxxx", @"fire_date":@"YY-MM-dd HH:mm:ss", @"fire_msg":@"xxxxx", @"link_url":@"xxxxx"}


//撤销本地通知
+ (void)revokeNotifyWithInfo:(NSDictionary *)info;              //根据通知的info信息取消该通知
+ (void)revokeAllNotifyWithIdentifier:(NSString*)identifier;    //根据通知的来源页面identifier，移除该页面上注册的所有通知
+ (void)revokeAllNotifications;                                 //取消所有已经规划的消息通知


//检查通知是否已经添加
+ (BOOL)checkHasRegisterByInfo:(NSDictionary *)info;         //通过info判断是否已经添加，必须所有属性都符合才算添加了 info: @{@"source":@"xxxxx", @"fire_date":@"YY-MM-dd HH:mm:ss", @"fire_msg":@"xxxxx", @"link_url":@"xxxxx"}


//一些配套方法
+ (NSString *)linkUrlFromNotify:(UILocalNotification *)notifiy;       //从本地通知中获取linkurl, 用于AppDelegate的 didReceiveLocalNotification: 方法中, 获取跳转字典使用
+ (NSString *)linkUrlFromLaunchOptions:(NSDictionary *)launchOptions; //从本地通知中获取linkurl, 用于AppDelegate的 didFinishLaunchingWithOptions: 方法中, 获取跳转字典使用

+ (NSDictionary*)userInfoMake:(NSString *)source firedate:(NSString *)firedate firemsg:(NSString *)firemsg linkurl:(NSString *)linkurl; //快速组合通知的userInfo字典的宏方法


@end
