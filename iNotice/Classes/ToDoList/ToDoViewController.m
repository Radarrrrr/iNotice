//
//  ToDoViewController.m
//  iNotice
//
//  Created by Radar on 14-8-28.
//
//

#import "ToDoViewController.h"
#import "DataCenter.h"
#import "ToDoInfo.h"
#import "DDFileManager.h"


@interface ToDoViewController ()

@end


@implementation ToDoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[[RImageManager sharedImageManager] fetchAllPhotosFromAlbum];
    
    //背景效果
    self.view.backgroundColor = DDCOLOR_BACK_GROUND;
    
//    _backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    _backView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    _backView.userInteractionEnabled = NO;
//    [self.view addSubview:_backView];
    
    
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
    titleL.text = @"我的记事本";
    self.navigationItem.titleView = titleL;
    
    
    //创建归属标题数组
    self.belongsArray = [self createBelongsArray];
    if(!ARRAYVALID(_belongsArray)) return;
    
    //创建列表数组
    self.listDatas = [self loadDatasFromDB];
    if(!ARRAYVALID(_listDatas))
    {
        self.listDatas = [self initListDatas];
    }
    if(!ARRAYVALID(_listDatas)) return;
    
    
    //创建 _tableView
    _tableView = [[DDTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.editRowEnabled = YES;
    _tableView.moveRowEnabled = YES;
    _tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _tableView.tableView.backgroundColor = [UIColor clearColor];    
    
    //添加headers
    [self createSectionHeaders];
    
    //添加table的footerview
    UIView *tableFooterV = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 220)] autorelease];
    tableFooterV.backgroundColor = [UIColor clearColor];
    
    UILabel *footerHL = [[[UILabel alloc] initWithFrame:CGRectMake(10, 40, CGRectGetWidth(tableFooterV.frame)-20, 16)] autorelease];
    footerHL.backgroundColor = [UIColor clearColor];
    footerHL.textAlignment = NSTextAlignmentLeft;
    footerHL.numberOfLines = 0;
    footerHL.font = DDFONT_B(12);
    footerHL.textColor = DDCOLOR_TEXT_C;
    footerHL.text = @"HOW TO DO:";
    [tableFooterV addSubview:footerHL];
    
    UILabel *footerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 60, CGRectGetWidth(tableFooterV.frame)-20, 90)] autorelease];
    footerLabel.backgroundColor = [UIColor clearColor];
    footerLabel.textAlignment = NSTextAlignmentLeft;
    footerLabel.numberOfLines = 0;
    footerLabel.font = DDFONT_B(12);
    footerLabel.textColor = DDCOLOR_TEXT_C;
    footerLabel.text = @"紧急且重要的事 -> 立即亲自处理 \n紧急但不重要的事 -> 立即交给别人处理 \n重要但不紧急的事 -> 稍后亲自处理 \n既不紧急又不重要的事 -> 以后再说 \n我的提醒 -> 一些常用の提醒";
    [tableFooterV addSubview:footerLabel];
    
    [DDFunction addLineToViewTop:footerLabel useColor:DDCOLOR_LINE_B];
    _tableView.tableView.tableFooterView = tableFooterV;
    

    
    
    //添加编辑按钮
    //editBtn
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(0, 0, 50, 16);
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleLabel.font = DDFONT_B(14);
    [editBtn setTitle:@"EDIT" forState:UIControlStateNormal];
    [editBtn setTitleColor:RGBS(240) forState:UIControlStateNormal];
    [editBtn setTitleColor:RGBA(200, 200, 200, 0.6) forState:UIControlStateHighlighted];
    [editBtn addTarget:self action:@selector(editListAction:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.tag = 1000;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 10, -5, -10);
    _editItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    //doneBtn
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(0, 0, 50, 16);
    doneBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    doneBtn.titleLabel.font = DDFONT_B(14);
    [doneBtn setTitle:@"DONE" forState:UIControlStateNormal];
    [doneBtn setTitleColor:RGBS(240) forState:UIControlStateNormal];
    [doneBtn setTitleColor:RGBA(200, 200, 200, 0.6) forState:UIControlStateHighlighted];
    [doneBtn addTarget:self action:@selector(editListAction:) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.tag = 1001;
    doneBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 10, -5, -10);
    _doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    
    
    //创建两个item
    [self.navigationItem setRightBarButtonItem:_editItem animated:YES];
    
    
    
    //添加增加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(SCR_WIDTH-50, self.view.frame.size.height-50, 50, 50);
    addBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [addBtn setImage:[UIImage imageNamed:@"btn_addinfo.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    
    
    //这里根据_listDatas的初始值，刷新列表页
    [self mergeAndRefreshFromListToTable];    
    
    
    
    //test shuju
    //-----
//    [_tableView appendData:@"这时第1段" useCell:@"ToDoCell" toSection:0];
//    [_tableView appendData:@"这时第2段" useCell:@"ToDoCell" toSection:0];
//    [_tableView appendData:@"这时第3段" useCell:@"ToDoCell" toSection:0];
//    
//    [_tableView appendData:@"这时第1段" useCell:@"ToDoCell" toSection:1];
//    [_tableView appendData:@"这时第2段" useCell:@"ToDoCell" toSection:1];
//    [_tableView appendData:@"这时第3段" useCell:@"ToDoCell" toSection:1];
//    
//    [_tableView appendData:@"这时第1段" useCell:@"ToDoCell" toSection:2];
//    [_tableView appendData:@"这时第2段" useCell:@"ToDoCell" toSection:2];
//    [_tableView appendData:@"这时第3段" useCell:@"ToDoCell" toSection:2];
//    
//    [_tableView appendData:@"这时第1段" useCell:@"ToDoCell" toSection:3];
//    [_tableView appendData:@"这时第2段" useCell:@"ToDoCell" toSection:3];
//    [_tableView appendData:@"这时第3段" useCell:@"ToDoCell" toSection:3];
//    
//    [_tableView appendData:@"这时第1段" useCell:@"ToDoCell" toSection:4];
//    [_tableView appendData:@"这时第2段" useCell:@"ToDoCell" toSection:4];
//    [_tableView appendData:@"这时第3段" useCell:@"ToDoCell" toSection:4];
    
    
    //-----
    
    
    
    //把紧急又重要的事情保存到group数组里边，用来给weiget显示
    //向group里边写入数据，给widget使用
    [self saveListDatasToGroup];
    
    
}

- (void)dealloc
{
    [_listDatas release];
    [_belongsArray release];
    [_tableView release];
    [_backView release];
    
    [_editItem release];
    [_doneItem release];
    
    [super dealloc];
}





#pragma mark -
#pragma mark 列表初始化相关
- (NSArray *)createBelongsArray
{
    NSArray *belongsArr = @[
                                @{@"belong":@"紧急且重要的事:", @"color":RGB(251, 11, 28)},
                                @{@"belong":@"紧急但不重要的事:", @"color":RGB(251, 70, 76)},
                                @{@"belong":@"重要但不紧急的事:", @"color":RGB(253, 153, 45)},
                                @{@"belong":@"既不紧急又不重要的事:", @"color":RGB(83, 162, 215)},
                                @{@"belong":@"我的提醒:", @"color":RGB(141, 224, 72)}
                           ];
    
    return belongsArr;
}

- (NSMutableArray *)initListDatas
{
    if(!ARRAYVALID(_belongsArray)) return nil;
    
    NSMutableArray *datasArr = [[[NSMutableArray alloc] init] autorelease];
    
    for(int i=0; i<[_belongsArray count]; i++)
    {
         NSMutableArray *secdatas = [[[NSMutableArray alloc] init] autorelease];
        [datasArr addObject:secdatas];
    }
    
    return datasArr;
}

- (void)createSectionHeaders
{
    if(!ARRAYVALID(_belongsArray)) return;
    
    for(int i=0; i<[_belongsArray count]; i++)
    {        
        NSDictionary *belongDic = [_belongsArray objectAtIndex:i];
        NSString *headerTitle = [belongDic objectForKey:@"belong"];
        
        UIView *hview = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)] autorelease];
        hview.backgroundColor = [belongDic objectForKey:@"color"];
        
        UILabel *headerL = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, CGRectGetHeight(hview.frame))] autorelease];
        headerL.backgroundColor = [UIColor clearColor];
        headerL.textAlignment = NSTextAlignmentLeft;
        headerL.font = DDFONT_B(14);
        headerL.textColor = RGBS(245);
        headerL.text = headerTitle;
        [hview addSubview:headerL];
        
        [_tableView setSection:i headerView:hview footerView:nil];
    }
}





#pragma mark -
#pragma mark 数据相关方法
- (NSMutableDictionary *)dictFromInfo:(ToDoInfo*)info
{
    if(!info) return nil;
    if(![info isKindOfClass:[ToDoInfo class]]) return nil;
    
    //数据转换成字典
    NSMutableDictionary *infoDic = [[[NSMutableDictionary alloc] init] autorelease];
    [infoDic setObject:[NSString stringWithFormat:@"%d", (int)info.todoID] forKey:@"todo_key_todoid"];
    [infoDic setObject:[NSString stringWithFormat:@"%d", (int)info.belongIndex] forKey:@"todo_key_belongindex"];
    if(STRVALID(info.infoDesc))
    {
        [infoDic setObject:info.infoDesc forKey:@"todo_key_description"];
    }
    if(STRVALID(info.createTime))
    {
        [infoDic setObject:info.createTime forKey:@"todo_key_createtime"];
    }
    
    return infoDic;
}
- (ToDoInfo *)infoFromDict:(NSDictionary*)dict
{
    if(!dict) return nil;
    
    //字典转换成数据
    NSString *todoid        = [dict objectForKey:@"todo_key_todoid"];
    NSString *belongindex   = [dict objectForKey:@"todo_key_belongindex"];
    NSString *description   = [dict objectForKey:@"todo_key_description"];
    NSString *createtime    = [dict objectForKey:@"todo_key_createtime"];
    
    ToDoInfo *info = [[[ToDoInfo alloc] init] autorelease];
    if(STRVALID(todoid))
    {
        info.todoID = [todoid integerValue];
    }
    if(STRVALID(belongindex))
    {
        info.belongIndex = [belongindex integerValue];
    }
    if(STRVALID(description))
    {
        info.infoDesc = description;
    }
    if(STRVALID(createtime))
    {
        info.createTime = createtime;
    }
    
    return info;
}

- (void)saveListDatasToDB
{
    if(!_listDatas) return;
    [[DDFileManager sharedManager] writeArrayToFile:to_do_list_plist_name withData:_listDatas];
    
    //把数据写入group给widget用
    [self saveListDatasToGroup];
}

- (NSMutableArray*)loadDatasFromDB
{
    NSArray *datas = [[DDFileManager sharedManager] arrayFromFile:to_do_list_plist_name];
    if(!datas) return nil;
    
    NSMutableArray *listdatas = [NSMutableArray arrayWithArray:datas];
    return listdatas;
}

- (void)mergeAndSaveDatasFromTableToList
{
    //把tableview内部的数据结构和本地存储的数据做合并，更新本地数据存储
    //用于从tableview返回操作以后，更新本地数据存储
    //Table Datas
//    [
//     {
//         "section_params":  //此字段可以没有
//         {
//             "header_height":"20",
//             "footer_height":"30",
//             "header_view":xxx,     //从外部做好的autoRelease类型的view, 必须每个都单独创建，否则内部重用就乱套了
//             "footer_view":xxx      //从外部做好的autoRelease类型的view, 必须每个都单独创建，否则内部重用就乱套了
//         },
//         "rows":            //此字段必须有，否则无法判断类型
//         [
//          {"cell":"xxx", "data":xxx},
//          {"cell":"xxx", "data":xxx},
//          {"cell":"xxx", "data":xxx}
//          ]
//     },
//     ...
//     ]
    
    
    //todoListDatas
//    [
//     [{},{},{}...],
//     [{},{},{}...],
//     [{},{},{}...],
//     [{},{},{}...],
//     [{},{},{}...],
//    ]
    
    
    //清除当前list数据源，创建新的数据源
    self.listDatas = [self initListDatas];
    
    //合并数据源，这里默认table的数据源已经被刷新过了，不考虑纯为空的情况
    NSMutableArray *tableDatas = _tableView.dataArray;
    for(int i=0; i<[tableDatas count]; i++)
    {
        NSDictionary *secdic = [tableDatas objectAtIndex:i];
        NSMutableArray *tablerows = [secdic objectForKey:@"rows"];
        if(!ARRAYVALID(tablerows)) continue;
        
        NSMutableArray *listrows = [_listDatas objectAtIndex:i];
        for(NSDictionary *rowdic in tablerows)
        {
            ToDoInfo *info = (ToDoInfo*)[rowdic objectForKey:@"data"];            
            NSMutableDictionary *dic = [self dictFromInfo:info];
            if(dic)
            {
                [listrows addObject:dic];
            }
        }
    }

    //保存到本地
    [self saveListDatasToDB];
}

- (void)mergeAndRefreshFromListToTable
{
    //用本地数据刷新tableview。
    //用于初始化等状态下，使用本List的数据源，刷新tableview
    
    //清空table里面所有数据，重新画列表
    [_tableView clearDatas];
    
    if(!ARRAYVALID(_listDatas)) 
    {
        [_tableView refreshTable];
        return;
    }
    
    //这里根据_listDatas的初始值，刷新列表页
    for(NSMutableArray *datas in _listDatas)
    {
        if(ARRAYVALID(datas))
        {
            for(NSDictionary *dic in datas)
            {
                ToDoInfo *info = [self infoFromDict:dic];
                [_tableView appendData:info useCell:@"ToDoCell" toSection:info.belongIndex];
            }
        }
    }
    //刷新一下列表
    [_tableView refreshTableWithAnimation:UITableViewRowAnimationTop];
    
}

- (void)addToDoInfo:(ToDoInfo*)info
{
    if(!info) return;
    if(info.belongIndex >= [_listDatas count]) return;
    
    //找到需要插入table的位置
    NSUInteger ints[2] = {info.belongIndex, 0};
	NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ints length:2];
    
    //先移动一下位置
    [self moveSectionToVisible:indexPath];
    
    //延迟0.5秒以后在做插入操作
    [DDFunction ActionAfterDelay:0.5 action:^{
        
        //把数据插入TableView的数组
        [_tableView insertData:info useCell:@"ToDoCell" toIndexPath:indexPath];
        
        //刷新一下列表
        [_tableView refreshTableWithAnimation:UITableViewRowAnimationTop];
        
        //更新一下list数据源
        [self mergeAndSaveDatasFromTableToList];
        
        //滚动到顶部并显示一下中刚添加的
        [_tableView selectIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self performSelector:@selector(delayDeselectCellAtIndexPath:) withObject:indexPath afterDelay:1];
        
    }];
    
}


- (void)moveSectionToVisible:(NSIndexPath*)indexPath
{
//    //算法暂时保留，以后再优化
//    CGRect hrect = [_tableView.tableView rectForHeaderInSection:indexPath.section];
//    CGRect tframe = _tableView.tableView.frame;
//    float cntH = _tableView.tableView.contentSize.height;
//    
//    if(cntH-tframe.size.height < 0) return;
//
//    float toY = hrect.origin.y;
//    if(cntH-tframe.size.height < hrect.origin.y)
//    {
//        toY = cntH-tframe.size.height;
//    }
//    
//    CGPoint offset = CGPointMake(0, toY);
//    [_tableView.tableView setContentOffset:offset animated:YES];
    
    
    //先使用这种算法
    id data = [_tableView cellDataOfRow:indexPath.row inSection:indexPath.section];
    if(!data) return;
    
    [_tableView.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


- (void)saveListDatasToGroup
{
    if(!_listDatas) return;
    
    //向group里边写入数据，给widget使用
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:inotice_app_group];
    [shared setObject:_listDatas forKey:@"todo_list_data"];
    [shared synchronize];
}



#pragma mark -
#pragma mark 编辑列表
- (void)editListAction:(id)sender
{        
    UIButton *btn = (UIButton*)sender;
    if(btn.tag == 1000)
    {
        [_tableView setEditing:YES animated:YES];
        [self.navigationItem setRightBarButtonItem:_doneItem animated:YES];
    }
    else
    {
        [_tableView setEditing:NO animated:YES];
        [self.navigationItem setRightBarButtonItem:_editItem animated:YES];
    }
    
}





#pragma mark -
#pragma mark 添加列表
- (void)addInfoAction:(id)sender
{        
//    [RImageManager getAlbumPhotoAssets:^(NSMutableArray *results) {
//        NSLog(@"获取了多少张照片: %d", results.count);
//        
//        if(! ARRAYVALID(results)) return;
//        
//        //随机选取一张照片
//        int radm = (int)[DDFunction randomFrom:0 to:(results.count-1)];
//        ALAsset *asset = [results objectAtIndex:radm];
//        
//        UIImage *photo = [RImageManager photoFromALAsset:asset];
//        int i=0;
//        _backView.image = photo;
//        
//    }];

    
//    [RImageManager fetchARandomPhoto:^(UIImage *photo) {
//        _backView.image = photo;
//    }];
//    
//    return;
    
    
    
    
    
    
    [self callInfoViewWithInfo:nil atIndexPath:nil];
}

- (void)delayDeselectCellAtIndexPath:(NSIndexPath*)indexPath
{
    [_tableView deselectIndexPath:indexPath animated:YES];
}

- (void)callInfoViewWithInfo:(ToDoInfo *)info atIndexPath:(NSIndexPath*)indexPath
{
    ContentPosition position = positionDown;
    if(!info) position = positionUP;
    
    ToDoInfoView *infoView = [[[ToDoInfoView alloc] initWithToDoInfo:info] autorelease];
    [[DDSlideLayer sharedLayer] callSlideLayerWithObject:infoView 
                                                position:position 
                                               limitRect:CGRectZero 
                                               lockBlank:NO 
                                                 lockPan:YES 
                                              completion:^{
                                                  
                                                  if(indexPath)
                                                  {
                                                      [_tableView deselectIndexPath:indexPath animated:YES];
                                                  }
                                                  
                                                  [self handleChangeForInfoView:infoView atIndexPath:indexPath];

                                              }];
}

- (void)handleChangeForInfoView:(ToDoInfoView*)infoView atIndexPath:(NSIndexPath*)indexPath
{
    if(!infoView) return;
    
    switch (infoView.status) {
        case ToDoInfoViewStatusNone:
        {
            return;
        }
            break;
        case ToDoInfoViewStatusModify:
        {
            if(!indexPath) return;
            
            //先移动到原来的位置
            [_tableView.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            [DDFunction ActionAfterDelay:0.5 action:^{
                
                //先移除原来的，再添加新的
                [_tableView deleteDataAtIndexPath:indexPath];
                [_tableView refreshTableWithAnimation:UITableViewRowAnimationLeft];
                
                [DDFunction ActionAfterDelay:0.5 action:^{
                    [self addToDoInfo:infoView.info];
                }];
            }];
            
            
        }
            break;
        case ToDoInfoViewStatusAdd:
        {
            //直接添加新的
            [self addToDoInfo:infoView.info];
        }
            break;
        default:
            break;
    }
}





#pragma mark -
#pragma mark delegate functions
//DDTableViewDelegate
- (void)DDTableViewDidSelectIndexPath:(NSIndexPath*)indexPath withData:(id)data ontable:(DDTableView*)table; //点击了某一个cell
{
    [self callInfoViewWithInfo:(ToDoInfo*)data atIndexPath:indexPath];
}

- (void)DDTableViewDidDeleteRowAtIndexPath:(NSIndexPath*)indexPath ontable:(DDTableView *)table
{
    //删除了某一行
    [self mergeAndSaveDatasFromTableToList];
}
- (void)DDTableViewDidMoveRowFrom:(NSIndexPath*)fromIndexPath to:(NSIndexPath*)toIndexPath ontable:(DDTableView*)table
{
    //从一个row移动到另一个row
    //修改移动行的归属ID
    ToDoInfo *info = [_tableView cellDataOfRow:toIndexPath.row inSection:toIndexPath.section];
    info.belongIndex = toIndexPath.section;
    
    //合并数据源
    [self mergeAndSaveDatasFromTableToList];
    
    [DDFunction ActionAfterDelay:0.25 
                          action:^{
                              [_tableView refreshTable];
                          }];
    
}





@end







