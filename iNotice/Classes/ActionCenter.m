//
//  ActionCenter.m
//  ddDemo
//
//  Created by panda on 13-3-12.
//  Copyright (c) 2013年 DangDang. All rights reserved.
//


#import "ActionCenter.h"



@implementation ActionCenter

+ (void)actionForLinkURL:(NSString *)linkURL
{
    [ActionCenter actionForLinkURL:linkURL data:nil];
}

+ (void)actionForLinkURL:(NSString*)linkURL data:(NSDictionary*)data
{
    if(!STRVALID(linkURL)) return;

    
    //因为URL要区分大小写，所以不对URL做处理
    if(![linkURL hasPrefix:@"http://"] && ![linkURL hasPrefix:@"https://"])
    {
        linkURL = [linkURL lowercaseString];
        linkURL = [linkURL stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
    
    //处理linkURL跳转
    if ([linkURL hasPrefix:@"check://"])  //每日check
    {
        //TO DO: 处理从本地通知提醒进入到每日check页面
        
    }

}






@end