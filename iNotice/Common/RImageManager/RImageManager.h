//
//  RImageManager.h
//  SMJ
//
//  Created by mac on 10-10-9.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RImageManager : NSObject {
    
}

+ (RImageManager*)sharedImageManager;



#pragma mark -
#pragma mark 实例方法
- (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;         //use a original image scale to new size and return a new image
- (UIImage *)imageFor3Ratio4WithImage:(UIImage*)image;        //change the photo to 3:4, return a new image
- (UIImage *)imageMergedForImage:(UIImage*)originImage maskImage:(UIImage*)maskImage; //the two images must the same size, if not, the regular is origin Image
- (UIImage *)imageCutAndMergedForImage:(UIImage*)originImage maskImage:(UIImage*)maskImage cutRect:(CGRect)cutRect; //the size of mask should be equal to cutRect, if not, the regular is cutRect
- (UIImage *)composeImages:(NSArray*)images toSize:(CGSize)coverSize; //compose some images to a new image, index 0 is the buttom layer image
- (UIImage *)cutPhotoFromPhoto:(UIImage*)photo fitSize:(CGSize)fitSize inRect:(CGRect)cutRect; //inRect是要切下来的区域在fitSize大小的photo上的相对位置, PS: 想象一下“回”字
- (UIImage *)imageFromLayer:(CALayer*)layer size:(CGSize)size;//从layer生成image
- (UIImage *)imageAddAlpha:(UIImage*)image;                  //给一个UIImage，添加Alpha，如果没有alpha则添加，如果有则保持原样
- (UIImage *)imageCorrectOrientation:(UIImage*)image;        //纠正照相机过来的UIImage自带的imageOrientation不是UP的问题，把image的方向全部变成UP，并且图像大小保持原有不变


#pragma mark -
#pragma mark 类方法
+ (void)getAlbumPhotoAssets:(void (^)(NSMutableArray *results))completion;   //从相册里边取出所有的照片 //results is from ALAsset
+ (UIImage *)photoFromALAsset:(ALAsset*)asset;                               //从一个ALAsset获取对应的照片大图
+ (void)fetchARandomPhoto:(void (^)(UIImage *photo))completion;              //从照相机的已保存相册里边随机获取一张照片，没有照片的话，block不返回


@end
