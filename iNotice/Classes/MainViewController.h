//
//  MainViewController.h
//  iNotice
//
//  Created by Radar on 14-8-14.
//
//

#import <UIKit/UIKit.h>
#import "MoveableView.h"


#define last_selected_menu_type @"last selected menu type"


@interface MainViewController : UIViewController <MoveableViewDelegate> {
    
    MoveableView *_dragBtn; //菜单托转小块
    
    BOOL _needShowMenu;
    BOOL _dragBright;   //拉动点亮状态
    
    UINavigationController *_curNav;
}

@property (nonatomic, retain) UINavigationController *todoNav;
@property (nonatomic, retain) UINavigationController *checkNav;
@property (nonatomic, retain) UINavigationController *settingNav;

- (UIViewController*)visibleViewController;

@end
