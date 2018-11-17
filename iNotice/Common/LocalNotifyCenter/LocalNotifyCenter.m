//
//  LocalNotifyCenter.m
//  TestSthDemo
//
//  Created by Radar on 15/1/15.
//  Copyright (c) 2015年 www.dangdang.com. All rights reserved.
//

#import "LocalNotifyCenter.h"


@implementation LocalNotifyCenter



#pragma mark -
#pragma mark 内部使用的方法
+ (void)initRegisterLocalNotification
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //iOS 8.0以上需要注册
        if([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
        {
            UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        }
    });
}

+ (NSDate*)dateFromString:(NSString*)dateString useFormat:(NSString*)format
{
    if(!dateString || [dateString isEqualToString:@""]) return nil;
    if(!format || [format isEqualToString:@""]) return nil;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [formatter setDateFormat:format];
    
    NSDate* adate = [formatter dateFromString:dateString];
    [formatter release];
    
    return adate;
}





#pragma mark -
#pragma mark 对外开放方法
+ (void)registerNotify:(NSDate *)fireDate 
               message:(NSString *)message
                  info:(NSDictionary *)infoDic
        repeatInterval:(NSCalendarUnit)repeatInterval // 0 means don't repeat
                 sound:(NSString *)soundName
                 badge:(NSInteger)badge
{
    //先注册一次本地通知, 单实例注册
    [LocalNotifyCenter initRegisterLocalNotification];
    
    
    //创建本地通知
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];  
    
    // 设置notification的属性  
    localNotification.fireDate = fireDate;  //触发时间
    localNotification.alertBody = message; // 消息内容  
    localNotification.repeatInterval = repeatInterval; // 重复的时间间隔  
    localNotification.soundName = soundName; //UILocalNotificationDefaultSoundName; // 触发消息时播放的声音  
    localNotification.applicationIconBadgeNumber = badge; //应用程序Badge数目  
    
    //设置随Notification传递的参数  
    localNotification.userInfo = infoDic;  
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification]; //注册
    [localNotification release]; //释放 
    
}

+ (void)registerNotifyWithInfo:(NSDictionary *)info
{
    //只用info来规划本地通知 info: @{@"fire_date":@"YY-MM-dd HH:mm:ss", @"fire_msg":@"xxxxx", @"link_url":@"xxxxx"}
    if(!info) return;
    
    //没有时间，没有message都不能添加规划
    NSString *dateString = [info objectForKey:@"fire_date"];
    NSDate *fireDate = [LocalNotifyCenter dateFromString:dateString useFormat:@"YY-MM-dd HH:mm:ss"];
    if(!fireDate) return;
    
    NSString *fireMsg = [info objectForKey:@"fire_msg"];
    if(!fireMsg || [fireMsg isEqualToString:@""]) return;
    
    //规划通知
    [LocalNotifyCenter registerNotify:fireDate message:fireMsg info:info repeatInterval:0 sound:UILocalNotificationDefaultSoundName badge:1];
}

+ (void)revokeNotifyWithInfo:(NSDictionary *)info
{
    if(!info) return;
    
    NSString *dateString = [info objectForKey:@"fire_date"];
    NSString *fireMsg = [info objectForKey:@"fire_msg"];
    NSString *linkUrl = [info objectForKey:@"link_url"];
    
    if(!dateString || [dateString isEqualToString:@""]) return;
    if(!fireMsg || [fireMsg isEqualToString:@""]) return;
    
    
    //要求必须存在userInfo，这是在添加的时候就写进去的
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];  
    for(UILocalNotification *notification in notifications) 
    {  
        NSDictionary *infoDic = notification.userInfo;
        if(!infoDic) continue;
        
        NSString *noti_date = [infoDic objectForKey:@"fire_date"];
        NSString *noti_msg  = [infoDic objectForKey:@"fire_msg"];
        NSString *noti_link = [infoDic objectForKey:@"link_url"];
        
        //时间不同或者信息不同都返回
        if(![noti_date isEqualToString:dateString] || ![noti_msg isEqualToString:fireMsg]) continue;
        
        //时间和信息都相同，对比linkurl是否相同
        if(linkUrl && ![linkUrl isEqualToString:@""]) //如果要取消的通知存在link
        {
            //如果通知的link不存在，继续
            if(!noti_link || [noti_link isEqualToString:@""]) continue;
            
            //如果都存在但是不相同，继续
            if(![noti_link isEqualToString:linkUrl]) continue;
            
            //都存在且相同，找到了对应的通知，取消掉
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
        else //如果要取消的通知不存在link
        {
            //如果通知的link却存在，继续
            if(noti_link && ![noti_link isEqualToString:@""]) continue;
                
            //通知的link也不存在，那么目前就是找到了对应的通知，取消掉
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }  
    
}

+ (void)revokeAllNotifyWithIdentifier:(NSString*)identifier
{
    //info: @{@"source":@"xxxxx", @"fire_date":@"YY-MM-dd HH:mm:ss", @"fire_msg":@"xxxxx", @"link_url":@"xxxxx"}
    if(!identifier || [identifier isEqualToString:@""]) return;
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];  
    if(!notifications || [notifications count] == 0) return;
        
    for(UILocalNotification *notification in notifications) 
    {  
        NSDictionary *infoDic = notification.userInfo;
        if(!infoDic) continue;
        
        NSString *source_id = [infoDic objectForKey:@"source"];
        if(!source_id || [source_id isEqualToString:@""]) continue;
        
        if([source_id isEqualToString:identifier])
        {
            //移除该通知
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }  
}

+ (void)revokeAllNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


+ (BOOL)checkHasRegisterByInfo:(NSDictionary *)info 
{
    //info: @{@"source":@"xxxxx", @"fire_date":@"YY-MM-dd HH:mm:ss", @"fire_msg":@"xxxxx", @"link_url":@"xxxxx"}
    if(!info) return NO;
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];  
    for(UILocalNotification *notification in notifications) 
    {  
        NSDictionary *infoDic = notification.userInfo;
        if(!infoDic) continue;
        
        if([infoDic isEqualToDictionary:info])
        {
            return YES;
        }
    }  
    
    return NO;
}




+ (NSString *)linkUrlFromNotify:(UILocalNotification *)notifiy
{
    NSDictionary *infoDic = notifiy.userInfo;
    if(!infoDic) return nil;
    
    //info: @{@"source":@"xxxxx", @"fire_date":@"YY-MM-dd HH:mm:ss", @"fire_msg":@"xxxxx", @"link_url":@"xxxxx"}
    NSString *linkUrl = [infoDic objectForKey:@"link_url"];
    return linkUrl;
}

+ (NSString *)linkUrlFromLaunchOptions:(NSDictionary *)launchOptions
{
    if(!launchOptions) return nil;
    
    UILocalNotification *notify = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    NSString *linkUrl = [LocalNotifyCenter linkUrlFromNotify:notify];
    return linkUrl;
}

+ (NSDictionary*)userInfoMake:(NSString *)source firedate:(NSString *)firedate firemsg:(NSString *)firemsg linkurl:(NSString *)linkurl
{
    //info: @{@"source":@"xxxxx", @"fire_date":@"YY-MM-dd HH:mm:ss", @"fire_msg":@"xxxxx", @"link_url":@"xxxxx"}
    NSMutableDictionary *infoDic = [[[NSMutableDictionary alloc] init] autorelease];
    
    if(source && ![source isEqualToString:@""]) 
    {
        [infoDic setObject:source forKey:@"source"];
    }
    
    if(firedate && ![firedate isEqualToString:@""]) 
    {
        [infoDic setObject:firedate forKey:@"fire_date"];
    }
    
    if(firemsg && ![firemsg isEqualToString:@""]) 
    {
        [infoDic setObject:firemsg forKey:@"fire_msg"];
    }
    
    if(linkurl && ![linkurl isEqualToString:@""]) 
    {
        [infoDic setObject:linkurl forKey:@"link_url"];
    }
    
    return infoDic;
}


@end







