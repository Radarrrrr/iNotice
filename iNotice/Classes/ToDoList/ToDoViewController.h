//
//  ToDoViewController.h
//  iNotice
//
//  Created by Radar on 14-8-28.
//
//

#import <UIKit/UIKit.h>
#import "DDTableView.h"
#import "ToDoInfoView.h"


#define to_do_list_plist_name @"todo_list.plist"


/* listDatas 数据结构
[
    [{},{},{}...],
    [{},{},{}...],
    [{},{},{}...],
    [{},{},{}...],
    [{},{},{}...],
]
*/


@interface ToDoViewController : UIViewController <DDTableViewDelegate> {
    
    DDTableView *_tableView;
    
    UIImageView *_backView;
    
    UIBarButtonItem *_editItem;
    UIBarButtonItem *_doneItem;
    
}

@property (nonatomic, retain) NSArray        *belongsArray; //{"belong":"", "color":xxx}
@property (nonatomic, retain) NSMutableArray *listDatas;  //这个数据里边装的是字典结构，和check不一样


@end
