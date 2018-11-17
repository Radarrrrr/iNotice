//
//  ToDoInfo.m
//  iNotice
//
//  Created by Radar on 14-8-28.
//
//

#import "ToDoInfo.h"

@implementation ToDoInfo


- (void)dealloc
{
    [_infoDesc release];
    [_createTime release];
    
    [super dealloc];
}


@end
