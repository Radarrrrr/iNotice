//
//  DataCenter.h
//  iNotice
//
//  Created by Radar on 14-8-29.
//
//

#import <Foundation/Foundation.h>
#import "ToDoInfo.h"



@interface DataCenter : NSObject {
    
}

//@property (nonatomic, retain) NSMutableArray


//+ (DataCenter*)sharedCenter;


#pragma mark -
#pragma mark To Do List 相关
/* ToDoList数据结构
[
    [{},{},{}...],
    [{},{},{}...],
    [{},{},{}...],
    [{},{},{}...],
    [{},{},{}...],
]
*/
+ (void)saveToDoInfo:(ToDoInfo*)info;  //保存一个记录到某个section去
+ (NSMutableArray *)loadToDoInfoList;   //读取保存在本地的数据列表

+ (void)mergeDatasForToDoList:(NSMutableArray*)tableDatas; //把tableview内部的数据结构和本地存储的数据做合并，更新本地数据存储


@end
