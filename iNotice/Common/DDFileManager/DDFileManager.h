//
//  DDFileManager.h
//  DDDevLib
//
//  Created by Radar on 12-10-15.
//  Copyright (c) 2012年 www.dangdang.com. All rights reserved.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DDFileManager : NSObject {

}

+ (DDFileManager *)sharedManager;



#pragma mark -
#pragma mark in use functions
-(BOOL)checkIfTheVersionUpdated;



#pragma mark -
#pragma mark out use functions
-(BOOL)writeDictionaryToFile:(NSString*)fileName withData:(NSDictionary*)dic; 
-(NSDictionary*)dictionaryFromFile:(NSString*)fileName; 

-(BOOL)writeArrayToFile:(NSString*)fileName withData:(NSArray*)array;
-(NSArray*)arrayFromFile:(NSString*)fileName; 

-(BOOL)writePhotoToFile:(NSString*)fileName withData:(UIImage*)photo;
-(UIImage*)photoFromFile:(NSString*)fileName;

-(BOOL)writeDataToFile:(NSString*)fileName withData:(NSData*)data;  //写NSData的内容到document，这些data内容，包括音频，视频等需要按照NSData格式存储的数据
-(NSData*)dataFromFile:(NSString*)fileName;

-(BOOL)deleteFileForName:(NSString*)fileName;
-(NSString*)getPathForFileName:(NSString*)fileName;   //获取的是document下面的路径

-(void)checkAndCreateFileForName:(NSString*)fileName; //在document里面查找对应的文件名字，如果没有，就从app的bundle里面copy一份
-(void)moveBundleFileToDocument:(NSString*)fileName;  //把bundle里边的文件拷贝到document里边


@end
