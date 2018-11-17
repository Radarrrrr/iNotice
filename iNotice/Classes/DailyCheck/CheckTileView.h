//
//  CheckTileView.h
//  iNotice
//
//  Created by Radar on 14/10/18.
//
//

#import <UIKit/UIKit.h>
#import "CheckInfo.h"


@class CheckTileView;
@protocol CheckTileViewDelegate <NSObject>
@optional
- (void)CheckTileViewDidTrigerEdit:(CheckTileView *)tileView; //check瓦片触发编辑
@end


@interface CheckTileView : UIView {

    UILabel *_descLabel;
    UIImageView *_doneV;
    
@private
    id _delegate;
}
@property (assign) id <CheckTileViewDelegate> delegate;

@property (nonatomic, retain) CheckInfo *checkInfo;
@property (nonatomic)         NSInteger tileIndex; //瓦片编号


@end
