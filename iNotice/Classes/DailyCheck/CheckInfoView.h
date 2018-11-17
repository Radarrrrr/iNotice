//
//  CheckInfoView.h
//  iNotice
//
//  Created by Radar on 14-9-3.
//
//

#import <UIKit/UIKit.h>
#import "CheckInfo.h"
#import <QuartzCore/QuartzCore.h>


typedef enum {
    CheckInfoViewStatusNone = 0, //点了空白什么都没做
    CheckInfoViewStatusModify,   //修改，点了“done”按钮，就算修改
    CheckInfoViewStatusAdd,      //添加
    CheckInfoViewStatusDelete    //删除
} ToDoInfoViewStatus;  


@interface CheckInfoView : UIView <UITextViewDelegate> {
    
    UITextView *_inputView;
    UIButton *_saveBtn;
    UIButton *_deleteBtn;
    
    UIView *_noticeLine;   //用来提示那些内容没有输入
}

@property (nonatomic, retain) CheckInfo  *info;
@property (nonatomic, retain) UIView    *canvasView;
@property (nonatomic)         ToDoInfoViewStatus status; 
@property (nonatomic)         NSInteger  tileIndex;


- (id)initWithCheckInfo:(CheckInfo*)info forIndex:(NSInteger)tileIndex;



@end
