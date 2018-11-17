//
//  AppDelegate.m
//  iNotice
//
//  Created by Radar on 14-5-26.
//
//

#import "AppDelegate.h"
#import "LocalNotifyCenter.h"

@implementation AppDelegate


#pragma mark -
#pragma mark 系统方法相关
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //创建框架
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.mainViewController = [[[MainViewController alloc] init] autorelease];
    UINavigationController *mainNav = [[[UINavigationController alloc] initWithRootViewController:_mainViewController] autorelease];
    mainNav.navigationBarHidden = YES;
    self.window.rootViewController = mainNav;
    
    
    //清空本地通知badge数量
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //本地通知处理
    [self scheduleLocalNotify];
    
    
    return YES;
}

- (void)dealloc
{
    [_window release];
    [_mainViewController release];
    
    [super dealloc];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //清空本地通知badge数量
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //从后台进前台，触发当前页面的viewwillappear方法
    UIViewController *visibleVC = [_mainViewController visibleViewController];
    [visibleVC performSelector:@selector(viewWillAppear:) withObject:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //只要程序激活，都会进这里，不管是第一次启动还是后台进前台
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    
    //options:
    //    {
    //        UIApplicationOpenURLOptionsOpenInPlaceKey = 0;
    //        UIApplicationOpenURLOptionsSourceApplicationKey = "com.dangdang.TestWidget.TestClipsWidget";
    //    }
    
    
    NSLog(@"接收到了外面的跳转URL: %@", url);
    return YES;
}




#pragma mark -
#pragma mark 内部方法相关
- (void)scheduleLocalNotify
{
    //未完成: 此处还无法更改提示时间，需要在做更多逻辑，并整理闹钟接口出来
    //TO DO: 提出设定每日提醒的时间的方法，整理成一个新方法
    //暂时先只处理每日提醒的通知
    
    //处理dailycheck的提醒
    //全部移除每日提醒的通知
    [LocalNotifyCenter revokeAllNotifyWithIdentifier:local_notify_identifier_daily_check];

    //重新添加每日提醒的通知
    //获取闹钟时间点
    NSString *cur_y_m_d = [DDFunction stringFromDate:[NSDate date] useFormat:@"YY-MM-dd"]; 
    NSString *alarm_y_m_d_h_m_s = [cur_y_m_d stringByAppendingString:@" 21:30:00"];
    NSDate *alarm_date = [DDFunction dateFromString:alarm_y_m_d_h_m_s useFormat:@"YY-MM-dd HH:mm:ss"];
    NSTimeInterval alarm_t = [alarm_date timeIntervalSince1970];
    
    //获取当前时间点
    NSTimeInterval cur_t = [[NSDate date] timeIntervalSince1970];
    
    //判断当前是否已经超过了闹钟点
    NSTimeInterval fire_time = alarm_t;
    if(cur_t >= fire_time)
    {
        //超过了闹钟点，需要注册从明天开始
        fire_time += 24*60*60;
    }
    
    NSDate   *fireDate  = [NSDate dateWithTimeIntervalSince1970:fire_time];
    NSString *fire_date = [DDFunction stringFromDate:fireDate useFormat:@"YY-MM-dd HH:mm:ss"];
    NSString *fire_msg  = @"今天你的事情完成了吗?";
    NSString *link_url  = @"check://";
    NSDictionary *info = [LocalNotifyCenter userInfoMake:local_notify_identifier_daily_check firedate:fire_date firemsg:fire_msg linkurl:link_url];
    
    //注册通知
    [LocalNotifyCenter registerNotify:fireDate 
                              message:fire_msg 
                                 info:info
                       repeatInterval:NSCalendarUnitDay 
                                sound:UILocalNotificationDefaultSoundName 
                                badge:1];
    
    
    
}





@end
