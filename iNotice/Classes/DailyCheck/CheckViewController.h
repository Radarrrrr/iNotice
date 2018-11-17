//
//  CheckViewController.h
//  iNotice
//
//  Created by RYD on 14-10-3.
//
//

#import <UIKit/UIKit.h>
#import "DDTilesView.h"
#import "CheckTileView.h"


#define check_list_plist_name @"check_list.plist"


@interface CheckViewController : UIViewController <DDTilesViewDataSource, DDTilesViewDelegate, CheckTileViewDelegate> {
    
    DDTilesView *_tilesView;
    
}

@property (nonatomic, retain) NSMutableArray *listDatas; //这个数据里边装的是CheckInfo类，和todo不一样


@end
