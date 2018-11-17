//
//  DataCenter.m
//  iNotice
//
//  Created by Radar on 14-8-29.
//
//

#import "DataCenter.h"
#import "DDFileManager.h"



//static DataCenter *_sharedCenter;


@implementation DataCenter


//+ (DataCenter*)sharedCenter
//{
//	if (!_sharedCenter) {
//		_sharedCenter = [[DataCenter alloc] init];
//	}
//	return _sharedCenter;
//}
//
//- (void)dealloc
//{		
//	[_sharedCenter release];
//	[super dealloc];
//}




#pragma mark -
#pragma mark To Do List 相关
//内部方法
+ (NSMutableDictionary *)dictFromToDoInfo:(ToDoInfo*)info
{
    if(!info) return nil;
    
    //数据转换成字典
    NSMutableDictionary *infoDic = [[[NSMutableDictionary alloc] init] autorelease];
    [infoDic setObject:[NSString stringWithFormat:@"%d", (int)info.todoID] forKey:@"todo_key_todoid"];
    [infoDic setObject:[NSString stringWithFormat:@"%d", (int)info.belongIndex] forKey:@"todo_key_belongindex"];
    if(STRVALID(info.infoDesc))
    {
        [infoDic setObject:info.infoDesc forKey:@"todo_key_description"];
    }
    
    return infoDic;
}
+ (ToDoInfo *)todoInfoFromDict:(NSMutableDictionary*)dict
{
    if(!dict) return nil;
    
    //字典转换成数据
    NSString *todoid        = [dict objectForKey:@"todo_key_todoid"];
    NSString *belongindex   = [dict objectForKey:@"todo_key_belongindex"];
    NSString *description   = [dict objectForKey:@"todo_key_description"];
    
    ToDoInfo *info = [[[ToDoInfo alloc] init] autorelease];
    if(STRVALID(todoid))
    {
        info.todoID = [todoid integerValue];
    }
    if(STRVALID(belongindex))
    {
        info.belongIndex = [belongindex integerValue];
    }
    if(STRVALID(description))
    {
        info.infoDesc = description;
    }
    
    return info;
}


//外部方法
+ (void)saveToDoInfo:(ToDoInfo*)info
{
    if(!info) return;
    
    //数据转换成字典
    NSMutableDictionary *dic = [self dictFromToDoInfo:info];
    if(!dic) return;
    
    
    
    
}

+ (NSMutableArray *)loadToDoInfoList
{
    //读取保存在本地的数据列表
    
    return nil;
}

+ (void)mergeDatasForToDoList:(NSMutableArray*)tableDatas
{
    //把tableview内部的数据结构和本地存储的数据做合并，更新本地数据存储
    //Table Datas
//    [
//     {
//         "section_params":  //此字段可以没有
//         {
//             "header_height":"20",
//             "footer_height":"30",
//             "header_view":xxx,     //从外部做好的autoRelease类型的view, 必须每个都单独创建，否则内部重用就乱套了
//             "footer_view":xxx      //从外部做好的autoRelease类型的view, 必须每个都单独创建，否则内部重用就乱套了
//         },
//         "rows":            //此字段必须有，否则无法判断类型
//         [
//          {"cell":"xxx", "data":xxx},
//          {"cell":"xxx", "data":xxx},
//          {"cell":"xxx", "data":xxx}
//          ]
//     },
//     ...
//     ]
    
    //todoListDatas
//    [
//     [{},{},{}...],
//     [{},{},{}...],
//     [{},{},{}...],
//     [{},{},{}...],
//     [{},{},{}...],
//    ]

    
    
    
}




@end
