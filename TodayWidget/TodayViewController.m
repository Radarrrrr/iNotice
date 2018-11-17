//
//  TodayViewController.m
//  TodayWidget
//
//  Created by Radar on 16/9/29.
//
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>


@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setPreferredContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 100)];
    
    
    //放置背景颜色
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    backView.backgroundColor = [UIColor whiteColor];//WRGB(50, 220, 210);
    backView.alpha = 0.1;
    [self.view addSubview:backView];
    
    
    //放入口按钮
    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enterBtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
    [enterBtn setTitle:@"快速开始记录>>>" forState:UIControlStateNormal];
    [enterBtn setTitleColor:WRGB(100, 100, 100) forState:UIControlStateNormal];  
    [enterBtn setTitleColor:WRGB(150, 150, 150)  forState:UIControlStateHighlighted]; 
    enterBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [enterBtn setContentEdgeInsets:UIEdgeInsetsMake(85, 220, 0, 0)];
    [enterBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
    
    
    //从group里边取出数据显示
    //取todolist的
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:inotice_widget_app_group];
    NSMutableArray *listDatas = (NSMutableArray*)[shared objectForKey:@"todo_list_data"];
    if(listDatas && [listDatas count] != 0)
    {
        //获取紧急又重要的信息显示
        /* ToDoList数据结构
         [
         [{},{},{}...],
         [{},{},{}...],
         [{},{},{}...],
         [{},{},{}...],
         [{},{},{}...],
         ]
         */
        NSArray *firstArr = (NSArray*)[listDatas objectAtIndex:0];
        if(firstArr)
        {
            //显示数字
            UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 150, 100)];
            numLabel.backgroundColor = [UIColor clearColor];
            numLabel.userInteractionEnabled = NO;
            numLabel.textAlignment = NSTextAlignmentLeft;
            numLabel.font = [UIFont systemFontOfSize:90];
            numLabel.textColor = WRGB(250, 40, 60);
            numLabel.text = [NSString stringWithFormat:@"%d", (int)firstArr.count];
            [self.view addSubview:numLabel];
        }
    }
    
    
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

// 一般默认的View是从图标的右边开始的...如果你想变换,就要实现这个方法
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    //UIEdgeInsets newMarginInsets = UIEdgeInsetsMake(defaultMarginInsets.top, defaultMarginInsets.left - 16, defaultMarginInsets.bottom, defaultMarginInsets.right);
    //return newMarginInsets;
    return UIEdgeInsetsZero; // 完全靠到了左边....
    //return UIEdgeInsetsMake(0.0, 16.0, 0, 0);
}

//对widget的点击在这里
- (void)clickAction:(id)sender
{
    [self.extensionContext openURL:[NSURL URLWithString:@"inotice://"] completionHandler:^(BOOL success) {
        NSLog(@"open url result:%d",success);
    }];
}




@end
