//
//  MenuView.h
//  iNotice
//
//  Created by Radar on 14-9-12.
//
//
//此类因为换成了SphereMenu而暂时不使用了，保留，以后功能点多了以后，还得换成这个使用

#import <UIKit/UIKit.h>
#import "DDTilesView.h"


#define tile_width_sigle  120    //占据一个格子的瓦片的长宽
#define tile_width_double 245    //占据两个格子的瓦片的长度
#define tile_height       120    //瓦片的高度


typedef enum {
    MenuTypeNone = 0,           //什么都没选
    MenuTypeToDoList = 1,       //提醒事项(分重要性级别)
    MenuTypeDailyCheck = 2,     //每日提醒(按天重置)
    
    MenuTypeSetting =3          //setting页面
} MenuType;



@interface MenuView : UIView <DDTilesViewDataSource, DDTilesViewDelegate> {
    
    DDTilesView *_tilesView;
    
}

@property (nonatomic) NSInteger selectedType;
@property (nonatomic, retain)  NSArray *menuArray; //[{"menu_name":"xxx", "menu_type":"xxx"},...]


+ (void)callMenuView:(void (^)(MenuView *menuView))completion; //呼叫menuview，完成关闭之后用block返回

@end
