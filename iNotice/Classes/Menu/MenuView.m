//
//  MenuView.m
//  iNotice
//
//  Created by Radar on 14-9-12.
//
//

#import "MenuView.h"

@implementation MenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        //init一些参数
        self.menuArray = [self createMenuArray];
        self.selectedType = MenuTypeNone;
        
        //add bgview
        UIView *bgview = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        bgview.backgroundColor = [UIColor blackColor];
        bgview.alpha = 0.6;
        [self addSubview:bgview];
        
        
        //add tilesView
        _tilesView = [[DDTilesView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _tilesView.contentView.showsVerticalScrollIndicator = NO;
        _tilesView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tilesView.delegate = self;
        _tilesView.dataSource = self;
        _tilesView.shadowEnabled = YES;
        _tilesView.params = @{                      //设定瓦片表属性
                             @"x_offset"   :@"12.5",
                             @"y_offset"   :@"64",
                             @"x_blank"    :@"5",
                             @"y_blank"    :@"5",
                             @"tail_blank" :@"10"
                            };
        [self addSubview:_tilesView];
        
        
        //add titleview
        UILabel *titleL = [[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 44)] autorelease];
        titleL.backgroundColor = [UIColor clearColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.numberOfLines = 1;
        titleL.textColor = [UIColor whiteColor];
        titleL.font = DDFONT_B(16);
        titleL.text = @"这是菜单";
        [_tilesView.contentView addSubview:titleL];

        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (void)dealloc
{
    [_tilesView release];
    [_menuArray release];
    [super dealloc];
}





#pragma mark -
#pragma mark 内部使用方法
- (NSArray *)createMenuArray
{
    NSArray *menuArr = @[
                          @{@"menu_name":@"我的记事本", @"menu_type":@(MenuTypeToDoList)},
                          @{@"menu_name":@"每日提醒", @"menu_type":@(MenuTypeDailyCheck)}
                        ];
    return menuArr;
}

- (UIView *)createTileViewForIndex:(NSInteger)index
{
    if(index >= [_menuArray count]) return nil;
    
    NSDictionary *menuDic = [_menuArray objectAtIndex:index];
    
    //创造瓦片
    //暂时都先做成两个的
    UIView *tileV = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tile_width_double, tile_height)] autorelease];
    tileV.backgroundColor = DDCOLOR_BLUE;
    
    UILabel *nameL = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tileV.frame), CGRectGetHeight(tileV.frame))] autorelease];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textAlignment = NSTextAlignmentCenter;
    nameL.numberOfLines = 0;
    nameL.textColor = [UIColor whiteColor];
    nameL.font = DDFONT_B(30);
    nameL.text = [menuDic objectForKey:@"menu_name"];
    [tileV addSubview:nameL];
    
    return tileV;
}





#pragma mark -
#pragma mark delegate functions
//DDTilesViewDataSource
- (NSInteger)numberOfTilesInTilesView:(DDTilesView*)tilesView
{
    return [_menuArray count];
}
- (UIView*)tilesView:(DDTilesView*)tilesView viewForIndex:(NSInteger)index
{
    UIView *tileV = [self createTileViewForIndex:index];
    
    return tileV;
}

//DDTilesViewDelegate
- (void)tilesViewDidSelect:(UIView*)tileView index:(NSInteger)index
{
    //选择了哪个瓦片及该瓦片的index
    NSDictionary *menuDic = [_menuArray objectAtIndex:index];
    NSNumber *type = [menuDic objectForKey:@"menu_type"];
    self.selectedType = [type integerValue];
    
    [[DDSlideLayer sharedLayer] closeSlideLayer];
}






#pragma mark -
#pragma mark 外部使用方法
+ (void)callMenuView:(void (^)(MenuView *menuView))completion
{
    MenuView *menuV = [[[MenuView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH-50, SCR_HEIGHT)] autorelease];
    [[DDSlideLayer sharedLayer] callSlideLayerWithObject:menuV 
                                                position:positionLeft 
                                               limitRect:CGRectZero 
                                               lockBlank:NO 
                                                 lockPan:NO 
                                              completion:^{
                                                  
                                                  if(completion)
                                                  {
                                                      completion(menuV);
                                                  }
                                              }];
}




@end
