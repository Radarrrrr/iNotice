//
//  SettingViewController.m
//  iNotice
//
//  Created by Radar on 15/1/14.
//
//

#import "SettingViewController.h"

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DDCOLOR_BACK_GROUND;

    //导航条效果
    if(IS_IOS7_ORLATER)
    {
        self.navigationController.navigationBar.barTintColor = RGB(100, 178, 230); //RGB(75, 118, 140); //RGB(222, 51, 80);
    }
    
    UILabel *titleL = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 22)] autorelease];
    titleL.backgroundColor = [UIColor clearColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = [UIColor whiteColor];
    titleL.font = DDFONT_B(18);
    titleL.text = @"设置";
    self.navigationItem.titleView = titleL;
    
}

- (void)dealloc
{
    
    [super dealloc];
}


@end
