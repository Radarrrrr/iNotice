//
//  CheckViewController.m
//  iNotice
//
//  Created by RYD on 14-10-3.
//
//

#import "CheckViewController.h"
#import "CheckInfo.h"
#import "DDFileManager.h"
#import "CheckInfoView.h"


@interface CheckViewController ()

@end

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DDCOLOR_BACK_GROUND;
    
    
    //初始化一些东西
    self.listDatas = [self loadDatasFromDB];
    if(!_listDatas)
    {
        self.listDatas = [[[NSMutableArray alloc] init] autorelease];
    }
    
    
    
    //导航条效果
    if(IS_IOS7_ORLATER)
    {
        self.navigationController.navigationBar.barTintColor = RGB(100, 178, 230); //RGB(75, 118, 140); //RGB(222, 51, 80);
    }
    
    UILabel *titleL = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 22)] autorelease];
    titleL.backgroundColor = [UIColor clearColor];
    titleL.textAlignment = NSTextAlignmentRight;
    titleL.textColor = [UIColor whiteColor];
    titleL.font = DDFONT_B(18);
    titleL.text = @"每日提醒";
    self.navigationItem.titleView = titleL;
    

    //add tilesView
    _tilesView = [[DDTilesView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tilesView.contentView.showsVerticalScrollIndicator = NO;
    _tilesView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tilesView.delegate = self;
    _tilesView.dataSource = self;
    _tilesView.shadowEnabled = YES;
    _tilesView.params = @{                      //设定瓦片表属性
                          @"x_offset"   :@"5.5",
                          @"y_offset"   :@"5.5",
                          @"x_blank"    :@"3",
                          @"y_blank"    :@"3",
                          @"tail_blank" :@"50"
                          };
    [self.view addSubview:_tilesView];
    
    
    //添加增加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(SCR_WIDTH-50, self.view.frame.size.height-50, 50, 50);
    addBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [addBtn setImage:[UIImage imageNamed:@"btn_addinfo.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
}

- (void)dealloc
{
    [_tilesView release];
    [_listDatas release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    //每次进入此方法，都检测当前时间，如果超过凌晨5点，则还原所有设置    
    [self checkAndResetDailyCheck];
}





#pragma mark -
#pragma mark 页面级特殊处理相关
- (void)checkAndResetDailyCheck
{
    if(!ARRAYVALID(_listDatas)) return;
    
    //检测当前时间，如果超过凌晨5点，则还原所有设置    
    //@"YY-MM-dd HH:mm:ss"
    
    //获取重置时间点
    NSString *cur_y_m_d = [DDFunction stringFromDate:[NSDate date] useFormat:@"YY-MM-dd"]; 
    NSString *limit_y_m_d_h_m_s = [cur_y_m_d stringByAppendingString:@" 05:00:00"];
    NSDate *limit_date = [DDFunction dateFromString:limit_y_m_d_h_m_s useFormat:@"YY-MM-dd HH:mm:ss"];
    NSTimeInterval limit_t = [limit_date timeIntervalSince1970];
    
    //获取当前时间点
    NSString *cur_y_m_d_h_m_s = [DDFunction stringFromDate:[NSDate date] useFormat:@"YY-MM-dd HH:mm:ss"]; 
    NSTimeInterval cur_t = [[NSDate date] timeIntervalSince1970];
    
    //获取上次重置的时间点
    NSTimeInterval reset_t = 0;
    NSString *reset_y_m_d_h_m_s = [[NSUserDefaults standardUserDefaults] objectForKey:@"last reset time string"];
    if(STRVALID(reset_y_m_d_h_m_s))
    {
        NSDate *reset_date = [DDFunction dateFromString:reset_y_m_d_h_m_s useFormat:@"YY-MM-dd HH:mm:ss"];
        reset_t = [reset_date timeIntervalSince1970];
    }
    
    
    //比较三个时间点，看是否需要重置，前提，limit_t和cur_t处在同一天内，即日期相同
    BOOL needReset = NO;
    if(cur_t < limit_t)
    {
        //如果当前时间比重置时间少，则不需要重置，即0-5点间，不需要考虑重置
        needReset = NO;
    }
    else
    {
        //当前时间多于重置时间了，可以考虑重置了，5-24点间，可以考虑重置
        if(reset_t != 0) //上次重置过
        {
            if(reset_t < limit_t)
            {
                //如果重置时间小于限制时间点，重置
                needReset = YES;
            }
            else if(reset_t > cur_t)
            {
                //如果重置时间大于当前时间，时间异常，重置
                needReset = YES;
            }
            else
            {
                //不需要重置
                needReset = NO;
            }
        }
        else  //没重置过
        {
            //重置
            needReset = YES;
        }
    }
    
    
    //重置数据
    if(needReset)
    {
        for(CheckInfo *info in _listDatas)
        {
            info.isDone = NO;
        }
        
        //保存本地
        [self saveCheckDatasToDB];
        
        //刷新页面
        [_tilesView reloadTiles];
        
        //纪录状态
        [[NSUserDefaults standardUserDefaults] setObject:cur_y_m_d_h_m_s forKey:@"last reset time string"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}




#pragma mark -
#pragma mark 瓦片处理相关
//DDTilesViewDataSource
- (NSInteger)numberOfTilesInTilesView:(DDTilesView*)tilesView
{
    return [_listDatas count];
}
- (UIView*)tilesView:(DDTilesView*)tilesView viewForIndex:(NSInteger)index
{
    CheckTileView *tileV = [[CheckTileView alloc] initWithFrame:CGRectMake(0, 0, (SCR_WIDTH-20)/4, (SCR_WIDTH-20)/4)]; //CGRectMake(0, 0, 75, 75)
    tileV.checkInfo = [_listDatas objectAtIndex:index];
    tileV.tileIndex = index;
    tileV.delegate = self;
    
    return tileV;
}

//DDTilesViewDelegate
- (void)tilesViewDidSelect:(UIView*)tileView index:(NSInteger)index
{
    //选择了哪个瓦片及该瓦片的index
    if(![tileView isKindOfClass:[CheckTileView class]]) return;
    
    [self changeStateOfTileView:(CheckTileView *)tileView];
}

- (void)changeStateOfTileView:(CheckTileView *)tileView
{
    if(!tileView) return;
    if(!ARRAYVALID(_listDatas)) return;
    
    NSInteger index = tileView.tileIndex;
    CheckInfo *info = tileView.checkInfo;
    
    if(!CHECKINARRAY(index, _listDatas)) return;
    if(!info) return;
    
    //修改数据
    CheckInfo *toInfo = (CheckInfo *)[_listDatas objectAtIndex:index];
    if(!toInfo) return;
    
    toInfo.isDone = !toInfo.isDone;
    [self saveCheckDatasToDB];
    
    //修改显示状态
    [tileView setCheckInfo:toInfo];
}

//CheckTileViewDelegate
- (void)CheckTileViewDidTrigerEdit:(CheckTileView *)tileView
{
    //触发编辑状态
    [self callInfoViewWithTile:tileView];
}





#pragma mark -
#pragma mark 内容编辑相关
- (void)addInfoAction:(id)sender
{        
    [self callInfoViewWithTile:nil];
}
- (void)callInfoViewWithTile:(CheckTileView *)tileView
{    
    CheckInfo *info = nil;
    NSInteger index = -1;
    
    if(tileView)
    {
        info = tileView.checkInfo;
        index = tileView.tileIndex;
    }
    
    ContentPosition position = positionDown;
    if(!info) position = positionUP;
    
    CheckInfoView *infoView = [[[CheckInfoView alloc] initWithCheckInfo:info forIndex:index] autorelease];
    [[DDSlideLayer sharedLayer] callSlideLayerWithObject:infoView 
                                                position:position 
                                               limitRect:CGRectZero 
                                               lockBlank:NO 
                                                 lockPan:YES 
                                              completion:^{
                                                  
                                                  [self handleChangeForInfoView:infoView];
                                                  
                                              }];
}

- (void)handleChangeForInfoView:(CheckInfoView*)infoView
{
    if(!infoView) return;
    
    switch (infoView.status) {
        case CheckInfoViewStatusNone:
        {
            return;
        }
            break;
        case CheckInfoViewStatusModify:
        {
            //修改数据源
            [self modifyCheckInfo:infoView.info forIndex:infoView.tileIndex];
        }
            break;
        case CheckInfoViewStatusAdd:
        {
            //直接添加新的
            [self addCheckInfo:infoView.info];
        }
            break;
        case CheckInfoViewStatusDelete:
        {
            //删除一个
            [self deleteCheckInfoForIndex:infoView.tileIndex];
        }
            break;
        default:
            break;
    }
}




#pragma mark -
#pragma mark 数据相关方法
- (NSMutableDictionary *)dictFromInfo:(CheckInfo*)info
{
    if(!info) return nil;
    if(![info isKindOfClass:[CheckInfo class]]) return nil;
    
    //数据转换成字典
    NSMutableDictionary *infoDic = [[[NSMutableDictionary alloc] init] autorelease];
    if(STRVALID(info.infoDesc))
    {
        [infoDic setObject:info.infoDesc forKey:@"check_key_description"];
    }
    
    [infoDic setObject:[NSNumber numberWithBool:info.isDone] forKey:@"check_key_isdone"];
    
    return infoDic;
}
- (CheckInfo *)infoFromDict:(NSDictionary*)dict
{
    if(!dict) return nil;
    
    //字典转换成数据
    NSString *description   = [dict objectForKey:@"check_key_description"];
    NSNumber *isdone        = [dict objectForKey:@"check_key_isdone"];
    
    CheckInfo *info = [[[CheckInfo alloc] init] autorelease];
    if(STRVALID(description))
    {
        info.infoDesc = description;
    }
    
    if(isdone && [isdone boolValue])
    {
        info.isDone = YES;
    }
    else
    {
        info.isDone = NO;
    }
    
    return info;
}

- (void)saveCheckDatasToDB
{
    if(!ARRAYVALID(_listDatas)) return;
    
    NSMutableArray *dicArray = [[[NSMutableArray alloc] init] autorelease];
    
    for(CheckInfo *info in _listDatas)
    {
        NSDictionary *dic = [self dictFromInfo:info];
        if(dic)
        {
            [dicArray addObject:dic];
        }
    }
    
    [[DDFileManager sharedManager] writeArrayToFile:check_list_plist_name withData:dicArray];
}

- (NSMutableArray*)loadDatasFromDB
{
    NSArray *datas = [[DDFileManager sharedManager] arrayFromFile:check_list_plist_name];
    if(!ARRAYVALID(datas)) return nil;
    
    NSMutableArray *listdatas = [[[NSMutableArray alloc] init] autorelease];
    
    for(NSDictionary *dic in datas)
    {
        CheckInfo *info = [self infoFromDict:dic];
        if(info)
        {
            [listdatas addObject:info];
        }
    }
    
    return listdatas;
}

- (void)addCheckInfo:(CheckInfo*)info
{
    if(!info) return;
    
    //加到最后一个显示
    [_listDatas addObject:info];
    
    //保存本地
    [self saveCheckDatasToDB];
    
    //刷新页面
    [_tilesView reloadTiles];
}

- (void)modifyCheckInfo:(CheckInfo *)info forIndex:(NSInteger)index
{
    if(!ARRAYVALID(_listDatas)) return;
    if(!CHECKINARRAY(index, _listDatas)) return;
    
    //找到对应的数据
    CheckInfo *theInfo = [_listDatas objectAtIndex:index];
    theInfo.infoDesc = info.infoDesc;
    theInfo.isDone = info.isDone;
    
    //保存本地
    [self saveCheckDatasToDB];
    
    //刷新页面
    [_tilesView reloadTiles];
}

- (void)deleteCheckInfoForIndex:(NSInteger)index
{
    if(!ARRAYVALID(_listDatas)) return;
    if(!CHECKINARRAY(index, _listDatas)) return;
    
    //删除index对应的info
    [_listDatas removeObjectAtIndex:index];
    
    //保存本地
    [self saveCheckDatasToDB];
    
    //刷新页面
    [_tilesView reloadTiles];
}




@end
