//
//  ToDoInfoView.h
//  iNotice
//
//  Created by Radar on 14-9-3.
//
//

#import <UIKit/UIKit.h>
#import "ToDoInfo.h"
#import <QuartzCore/QuartzCore.h>


typedef enum {
    ToDoInfoViewStatusNone = 0, //点了空白什么都没做
    ToDoInfoViewStatusModify,   //修改，点了“done”按钮，就算修改
    ToDoInfoViewStatusAdd       //添加
} ToDoInfoViewStatus;  


@interface ToDoInfoView : UIView <UITextViewDelegate> {
    
    UITextView *_inputView;
    NSInteger _selBelongIndex;
    UIButton *_saveBtn;
    
    UIView *_noticeLine;   //用来提示那些内容没有输入
    UIView *_noticeCircle;
}

@property (nonatomic, retain) ToDoInfo  *info;
@property (nonatomic, retain) UIView    *canvasView;
@property (nonatomic, retain) NSArray   *belongsArray; //{"belong":"", "color":xxx}
@property (nonatomic)         ToDoInfoViewStatus status; 


- (id)initWithToDoInfo:(ToDoInfo*)info;



@end
