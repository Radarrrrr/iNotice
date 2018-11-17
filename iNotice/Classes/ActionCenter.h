//
//  ActionCenter.h
//  ddDemo
//
//  Created by panda on 13-3-12.
//  Copyright (c) 2013年 DangDang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionCenter : NSObject


//中央控制器入口
/*!@brief 中央控制器跳转链接方法，使用时请注意入口参数类型，不可以加入中途return。
 * @param linkURL       [必须]需要跳转到的cms字典，字典列表参照: project_description 文档
 * @param data          [可选]需要额外附加的数据，必须为字典结构，跳转到linkURL的时候附加使用，此字段不一定用，用来处理某些特殊情况时候的数据传入
*/
+ (void)actionForLinkURL:(NSString*)linkURL;
+ (void)actionForLinkURL:(NSString*)linkURL data:(NSDictionary*)data;



@end
