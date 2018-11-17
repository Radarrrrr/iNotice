//
//  ToDoInfo.h
//  iNotice
//
//  Created by Radar on 14-8-28.
//
//

#import <Foundation/Foundation.h>

@interface ToDoInfo : NSObject {

}

@property (nonatomic)           NSInteger todoID;        //ID
@property (nonatomic)           NSInteger belongIndex;   //归属位置
@property (nonatomic, retain)   NSString  *infoDesc;     //描述
@property (nonatomic, retain)   NSString  *createTime;   //创建时间



@end
