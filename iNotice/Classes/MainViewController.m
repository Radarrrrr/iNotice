//
//  MainViewController.m
//  iNotice
//
//  Created by Radar on 14-8-14.
//
//

#import "MainViewController.h"
#import "ToDoViewController.h"
#import "CheckViewController.h"
#import "SettingViewController.h"
#import "MenuView.h"
#import "iNotice-Bridging-Header.h"
#import "iNotice-Swift.h"


@interface MainViewController ()

@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = DDCOLOR_BACK_GROUND;
    
    _needShowMenu = NO;
    _dragBright = NO;

    
    //初始化菜单对应的功能页面
    NSNumber *menutype = [[NSUserDefaults standardUserDefaults] objectForKey:last_selected_menu_type];
    if(!menutype || [menutype integerValue] == MenuTypeNone)
    {
        [self initFunctionViewForMenuType:MenuTypeToDoList];
    }
    else
    {
        [self initFunctionViewForMenuType:[menutype integerValue]];
    }
    

/*  //拉线方式，暂时不删除保留
    //add _dragBtn
    _dragBtn = [[MoveableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, 40, 40)];
    _dragBtn.clipsToBounds = NO;
    _dragBtn.horizontalOnly = YES;
    _dragBtn.delegate = self;
    _dragBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dragBtn];
    
    //add image to drag
    UIImageView *imageV = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_dragBtn.frame), CGRectGetHeight(_dragBtn.frame))] autorelease];
    imageV.image = [UIImage imageNamed:@"btn_menu.png"]; 
    imageV.userInteractionEnabled = NO;
    imageV.tag = 1000;
    [DDFunction addRadiusToView:imageV radius:CGRectGetWidth(imageV.frame)/2];
    [DDFunction addBorderToView:imageV color:DDCOLOR_GOLD lineWidth:2.5];
    [_dragBtn addSubview:imageV];
    
    //add line to _dragBtn
    UIView *line = [[[UIView alloc] initWithFrame:CGRectMake(-320, CGRectGetHeight(_dragBtn.frame)/2, 320, 2)] autorelease];
    line.backgroundColor = DDCOLOR_RED;
    line.tag = 1001;
    [_dragBtn addSubview:line];
    
    //添加KVO监听
    [_dragBtn addObserver:self forKeyPath:@"center" options:0 context:NULL];
*/    
    
    
    //使用SphereMenu做功能选择方式
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveShpereMenuNotify:) name:@"notify_spheremenu_did_select" object:nil];
    
    UIImage *menuIcon = [UIImage imageNamed:@"icon_menu"];
    NSArray *icons = @[
                       [UIImage imageNamed:@"icon_note"],
                       [UIImage imageNamed:@"icon_check"],
                       [UIImage imageNamed:@"icon_setting"]
                      ];
    
    //@Radar 暂时先保留第一行，因为这个地方是更新了xcode以后，swift的 super.init() 这种形式不能用了，必须放一个属性才行。。
    //SphereMenu *spMenu = [[[SphereMenu alloc] initWithStartPoint:CGPointMake(34, SCR_HEIGHT-34) startImage:menuIcon submenuImages:icons] autorelease];
    SphereMenu *spMenu = [[[SphereMenu alloc] initWithFrame:CGRectZero startPoint:CGPointMake(34, SCR_HEIGHT-34) startImage:menuIcon submenuImages:icons] autorelease];
    //spMenu.delegate = self;
    //[self.view addSubview:spMenu];
    
    UIWindow *topWindow = [UIApplication sharedApplication].keyWindow;
    [topWindow addSubview:spMenu];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notify_spheremenu_did_select" object:nil];
    
    [_dragBtn removeObserver:self forKeyPath:@"center"];
    
    [_todoNav release];
    [_checkNav release];
    [_settingNav release];
    
    [_dragBtn release];
    
    [super dealloc];
}




#pragma mark -
#pragma mark 系统级相关页面切换逻辑
- (UIViewController*)visibleViewController 
{    
    return _curNav.topViewController;
}




#pragma mark -
#pragma mark 处理SphereMenu相关页面切换逻辑
-(void)receiveShpereMenuNotify:(NSNotification*)notification
{
    id numIndex = [notification object];
    if(![numIndex isKindOfClass:[NSNumber class]]) return;
    
    NSInteger index = [numIndex integerValue];
    NSLog(@"select menu %d", (int)index);
    
    MenuType menutype = MenuTypeNone;
    
    switch ((int)index) {
        case 0:
        {
            menutype = MenuTypeToDoList;
        }
            break;
        case 1:
        {
            menutype = MenuTypeDailyCheck;
        }
            break;
        case 2:
        {
            menutype = MenuTypeSetting;
        }
            break;
        default:
            break;
    }
    
    [self handleSelectedMenuType:menutype];
}





#pragma mark -
#pragma mark 处理FunctionView功能显示层
- (void)initFunctionViewForMenuType:(NSInteger)menutype
{
    switch (menutype) {
        case MenuTypeToDoList:
        {
            if(_todoNav) return;
            
            //add _todoNav
            ToDoViewController *todoVC = [[[ToDoViewController alloc] init] autorelease];
            self.todoNav = [[[UINavigationController alloc] initWithRootViewController:todoVC] autorelease];
            _todoNav.navigationBarHidden = NO;
            [self.view addSubview:_todoNav.view];
            
            _curNav = _todoNav;
            
        }
            break;
        case MenuTypeDailyCheck:
        {
            if(_checkNav) return;
            
            //add _checkNav
            CheckViewController *checkVC = [[[CheckViewController alloc] init] autorelease];
            self.checkNav = [[[UINavigationController alloc] initWithRootViewController:checkVC] autorelease];
            _checkNav.navigationBarHidden = NO;
            [self.view addSubview:_checkNav.view];
            
            _curNav = _checkNav;
            
        }
            break;
        case MenuTypeSetting:
        {
            if(_settingNav) return;
            
            //add _settingNav
            SettingViewController *settingVC = [[[SettingViewController alloc] init] autorelease];
            self.settingNav = [[[UINavigationController alloc] initWithRootViewController:settingVC] autorelease];
            _settingNav.navigationBarHidden = NO;
            [self.view addSubview:_settingNav.view];
            
            _curNav = _settingNav;
            
        }
            break;
        default:
            break;
    }
    
}

- (void)handleSelectedMenuType:(NSInteger)menuType
{
    switch (menuType) {
        case MenuTypeNone:
        {
            //什么都不做
            return;
        }
            break;
        case MenuTypeToDoList:
        {
            //显示我的记事本
            if(_curNav == _todoNav) return;
            
            if(!_todoNav)
            {
                [self initFunctionViewForMenuType:MenuTypeToDoList];
            }
            
            [self.view bringSubviewToFront:_todoNav.view];
            
            _curNav = _todoNav;
        }
            break;
        case MenuTypeDailyCheck:
        {
            //显示每日提醒
            if(_curNav == _checkNav) return;
            
            if(!_checkNav)
            {
                [self initFunctionViewForMenuType:MenuTypeDailyCheck];
            }
            
            [self.view bringSubviewToFront:_checkNav.view];
            
            _curNav = _checkNav;
        }
            break;
        case MenuTypeSetting:
        {
            //显示设置页面
            if(_curNav == _settingNav) return;
            
            if(!_settingNav)
            {
                [self initFunctionViewForMenuType:MenuTypeSetting];
            }
            
            [self.view bringSubviewToFront:_settingNav.view];
            
            _curNav = _settingNav;
        }
            break;
        default:
            break;
    }
    
    [self.view bringSubviewToFront:_dragBtn];
    
    //触发当前层的显示
    UIViewController *curVC = _curNav.topViewController;
    [curVC performSelector:@selector(viewWillAppear:) withObject:nil];
    
    
    //存起来当前选择的菜单类型
    [[NSUserDefaults standardUserDefaults] setObject:@(menuType) forKey:last_selected_menu_type];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}





#pragma mark -
#pragma mark 拉线打开menuview相关，暂时关闭此功能，不删除保留，打开上边注释的部分就可以使用
//KVO 监听_dragBtn的位置
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _dragBtn && [keyPath isEqualToString:@"center"]) 
    {
        //NSLog(@"center: %.f", _dragBtn.center.x);
        float posX   = _dragBtn.center.x;
        float limitX = 140;
        
        if(posX >= limitX)
        {
            if(!_needShowMenu)
            {
                _needShowMenu = YES;
            }
            
            [self brightMenuBtn:YES];
        }
        else
        {
            [self brightMenuBtn:NO];
        }
        
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)brightMenuBtn:(BOOL)bright
{
    //点亮菜单按钮
    UIImageView *imageV = (UIImageView*)[_dragBtn viewWithTag:1000];
    UIView *line = (UIView*)[_dragBtn viewWithTag:1001];
    
    CGRect lframe = line.frame;
    CGRect toframe;
    UIColor *tocolor;
    
    if(bright)
    {
        if(_dragBright) return;
        _dragBright = YES;
        
        toframe = CGRectMake(-5, -5, CGRectGetWidth(_dragBtn.frame)+10, CGRectGetHeight(_dragBtn.frame)+10);
        tocolor = DDCOLOR_RED;
        
        line.backgroundColor = DDCOLOR_RED;
        lframe.origin.x = -320-5;
        line.frame = lframe;
    }
    else
    {
        if(!_dragBright) return;
        _dragBright = NO;
        
        toframe = CGRectMake(0, 0, CGRectGetWidth(_dragBtn.frame), CGRectGetHeight(_dragBtn.frame));
        tocolor = DDCOLOR_GOLD;
        
        line.backgroundColor = DDCOLOR_RED;
        lframe.origin.x = -320;
        line.frame = lframe;
    }
    
    
    imageV.frame = toframe;
    [DDFunction addBorderToView:imageV color:tocolor lineWidth:2.5];
    [DDFunction addRadiusToView:imageV radius:toframe.size.width/2];
}

//MoveableViewDelegate
- (void)MoveableViewTouchUp:(MoveableView*)moveableView
{
    [self brightMenuBtn:NO];
    
    //回弹浮动按钮
    [UIView animateWithDuration:0.2 
                     animations:^{
                         
                         CGRect mframe = _dragBtn.frame;
                         mframe.origin.x = 0;
                         _dragBtn.frame = mframe;
                         
                     } 
                     completion:^(BOOL finished) {
                        
                         //触发菜单浮层弹出
                         [self checkAndcallMenuView];
                         
                     }];
    
}

- (void)checkAndcallMenuView
{
    if(!_needShowMenu) return;
    
    [MenuView callMenuView:^(MenuView *menuView) {
        _needShowMenu = NO;
        
        //处理选择的菜单
        [self handleSelectedMenuType:menuView.selectedType];
        
    }];
}



@end









