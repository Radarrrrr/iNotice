//
//  RImageManager.m
//  SMJ
//
//  Created by mac on 10-10-9.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RImageManager.h"


@interface RImageManager ()
+ (double)randomFrom:(double)numMin to:(double)numMax;

@end


static RImageManager *_sharedImageManager;


@implementation RImageManager


- (id)init
{
    self = [super init];
    if (self) {
    
    }
    return self;
}


+ (RImageManager*)sharedImageManager;
{
	if (!_sharedImageManager) {
		_sharedImageManager = [[RImageManager alloc] init];
	}
	return _sharedImageManager;
}


- (void)dealloc
{		
	[_sharedImageManager release];
	[super dealloc];
}







#pragma mark -
#pragma mark 内部使用的类方法
+ (double)randomFrom:(double)numMin to:(double)numMax
{
    if(numMin == numMax) return numMin;
    
    int startVal = numMin*10000;
    int endVal = numMax*10000; 
    
    int minVal = startVal;
    if(endVal < minVal) minVal = endVal;
    
    int randomValue = minVal + (arc4random()%ABS(endVal - startVal));
    double a = randomValue;
    
    return(a/10000.0);
}







#pragma mark -
#pragma mark 实例方法
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
	// Create a graphics image context
	UIGraphicsBeginImageContext(newSize);
	
	// Tell the old image to draw in this new context, with the desired
	// new size
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	
	// Get the new image from the context
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End the context
	UIGraphicsEndImageContext();
	
	// Return the new image.
	return newImage;
}
-(UIImage*)imageFor3Ratio4WithImage:(UIImage*)image
{
	if(image == nil) return nil;
	if(image.size.width == image.size.height*0.75) return image;
	if(image.size.width == 1936.0 && image.size.height == 2592.0) return image;
	
	
		
	float contxWidth;
	float contxHeight;
	float offsetx;
	float offsety;
	
	if(image.size.width > image.size.height*0.75)
	{
		contxWidth = image.size.width;
		contxHeight = image.size.width/0.75;
		offsetx = 0.0;
		offsety = (contxHeight-image.size.height)/2;
	}
	else
	{
		contxHeight = image.size.height;
		contxWidth = contxHeight*0.75;
		offsetx = (contxWidth-image.size.width)/2;
		offsety = 0.0;
	}


	// Create a graphics image context
	UIGraphicsBeginImageContext(CGSizeMake(contxWidth, contxHeight));
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0.0, 0.0, contxWidth, contxHeight));
	
	// Tell the old image to draw in this new context, with the desired
	// new size
	[image drawInRect:CGRectMake(offsetx, offsety, image.size.width, image.size.height)];
	
	// Get the new image from the context
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End the context
	UIGraphicsEndImageContext();
	
	// Return the new image.
	return newImage;
}

-(UIImage*)imageMergedForImage:(UIImage*)originImage maskImage:(UIImage*)maskImage
{
	if(originImage == nil) return nil;
	if(maskImage == nil) return originImage;
	
	CGSize imageSize = originImage.size;
	
	UIGraphicsBeginImageContext(imageSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	
    // full the color in the context
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0.0, 0.0, imageSize.width, imageSize.height));
    
	CGContextSetAlpha(ctx, 0.0);
	CGContextClipToMask(ctx, CGRectMake(0.0, 0.0, imageSize.width, imageSize.height), [maskImage CGImage]);
	
	// draw source image on the context
	[originImage drawInRect:CGRectMake(0.0, 0.0, imageSize.width, imageSize.height)];
	
    UIImage* mergePhoto = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return mergePhoto;
}
-(UIImage*)imageCutAndMergedForImage:(UIImage*)originImage maskImage:(UIImage*)maskImage cutRect:(CGRect)cutRect
{
	
	if(originImage == nil) return nil;
	if(maskImage == nil) return originImage;
	
	CGSize imageSize = originImage.size;
	
	UIGraphicsBeginImageContext(cutRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	
    // full the color in the context
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0.0, 0.0, cutRect.size.width, cutRect.size.height));
    
	CGContextSetAlpha(ctx, 0.0);
	CGContextClipToMask(ctx, CGRectMake(0.0, 0.0, cutRect.size.width, cutRect.size.height), [maskImage CGImage]);
	
	// draw source image on the context
	[originImage drawInRect:CGRectMake(0.0-cutRect.origin.x, 0.0-cutRect.origin.y, imageSize.width, imageSize.height)];
	
    UIImage* mergePhoto = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return mergePhoto;
	
}
-(UIImage*)composeImages:(NSArray*)images toSize:(CGSize)coverSize
{
	if(images == nil || [images count] == 0) return nil;
	
	UIGraphicsBeginImageContext(coverSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	
    // full the color in the context
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0.0, 0.0, coverSize.width, coverSize.height));
    
    // draw source image on the context
	for(UIImage *image in images)
	{
		[image drawInRect:CGRectMake(0.0, 0.0, coverSize.width, coverSize.height)];
	}
	
    UIImage* compiledPhoto = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return compiledPhoto;
}
-(UIImage*)cutPhotoFromPhoto:(UIImage*)photo fitSize:(CGSize)fitSize inRect:(CGRect)cutRect
{
	if(!photo) return nil;
	
	UIGraphicsBeginImageContext(cutRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	
    // full the color in the context
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0.0, 0.0, cutRect.size.width, cutRect.size.height));
    
    // draw source image on the context
	[photo drawInRect:CGRectMake(-cutRect.origin.x, -cutRect.origin.y, fitSize.width, fitSize.height)];
	
    UIImage* cutPhoto = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return cutPhoto;
}
-(UIImage*)imageFromLayer:(CALayer*)layer size:(CGSize)size
{
	if(layer == nil) return nil;
	
	UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0.0, 0.0, size.width, size.height));
    
	[layer renderInContext:UIGraphicsGetCurrentContext()];
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}
- (UIImage*)imageAddAlpha:(UIImage*)image
{
    CGImageRef CGImage = image.CGImage;
	if (!CGImage)
		return nil;
    
	
	size_t imgWidth	= CGImageGetWidth(CGImage);
	size_t imgHeight  = CGImageGetHeight(CGImage);
	UInt8* buffer = (UInt8*)malloc(imgWidth * imgHeight * 4);
	
	
	CGColorSpaceRef	desColorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bitmapContext = CGBitmapContextCreate(buffer,
													   imgWidth,imgHeight,
													   8, 4*imgWidth,
													   desColorSpace,
													   kCGImageAlphaPremultipliedLast);
	CGContextDrawImage(bitmapContext, CGRectMake(0.0, 0.0, (CGFloat)imgWidth, (CGFloat)imgHeight), image.CGImage);
	
	CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
	UIImage* resultImage = [UIImage imageWithCGImage:cgImage];
	
	CFRelease(desColorSpace);
	CFRelease(bitmapContext);
	CFRelease(cgImage);
	free(buffer);
	
	return resultImage;
}
- (UIImage*)imageCorrectOrientation:(UIImage*)image
{
    if(!image) return nil;
    
    CGFloat width = image.size.width;   
    CGFloat height = image.size.height; 
    
    CGFloat destW = width;
    CGFloat destH = height;
    CGFloat sourceW = width;
    CGFloat sourceH = height;
    
    if (image.imageOrientation == UIImageOrientationRight || image.imageOrientation == UIImageOrientationLeft) 
    {
        sourceW = height;
        sourceH = width;
    }
    
    
    CGImageRef imageRef = image.CGImage;
    CGContextRef bitmap = CGBitmapContextCreate(NULL, destW, destH,
                                                CGImageGetBitsPerComponent(imageRef), 4*destW, CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    if (image.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM(bitmap, sourceW, sourceH);
        CGContextRotateCTM(bitmap, 180 * (M_PI/180));
    } else if (image.imageOrientation == UIImageOrientationLeft) {
        CGContextTranslateCTM(bitmap, sourceH, 0);
        CGContextRotateCTM(bitmap, 90 * (M_PI/180));
    } else if (image.imageOrientation == UIImageOrientationRight) {
        CGContextTranslateCTM(bitmap, 0, sourceW);
        CGContextRotateCTM(bitmap, -90 * (M_PI/180));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0,0,sourceW,sourceH), imageRef);
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* result = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;
}







#pragma mark -
#pragma mark 类方法
+ (void)getAlbumPhotoAssets:(void (^)(NSMutableArray *results))completion
{
    //PS: result is ALAsset
    static NSMutableArray *photoResults = nil;
    static ALAssetsLibrary *libray = nil;  
    
    //如果图片已经取过了，就直接返回
    if(photoResults)
    {
        if(completion)
        {
            completion(photoResults);
        }
        return;
    }
    
    //如果没取过，就创建单实例取图片然后返回
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            photoResults = [[NSMutableArray alloc] init];
            libray = [[ALAssetsLibrary alloc] init];
            
            [libray enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {  
                
                if(group) 
                {                  
                    //设置过滤对象  
                    ALAssetsFilter *filter = [ALAssetsFilter allPhotos];  
                    [group setAssetsFilter:filter];  
                    
                    //通过文件夹枚举遍历所有的相片ALAsset对象，有多少照片，则调用多少次block  
                    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {  
                        if (result != nil) {  
                            //将result对象存储到数组中  
                            [photoResults addObject:result];    
                        }  
                    }];  
                }  
                else
                {      
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(completion)
                        {
                            completion(photoResults);
                        }
                    });
                }
                
            } failureBlock:^(NSError *error) {  
                
            }];  
        });
        
    });
    
}

+ (void)fetchARandomPhoto:(void (^)(UIImage *photo))completion
{
    [RImageManager getAlbumPhotoAssets:^(NSMutableArray *results) {
        
        if(!results || [results count] == 0) return;
        
        //随机选取一张照片
        int radm = (int)[RImageManager randomFrom:0 to:(results.count-1)];
        ALAsset *asset = [results objectAtIndex:radm];
        
        UIImage *photo = [RImageManager photoFromALAsset:asset];
        if(!photo) return;
        
        if(completion)
        {
            //返回给block
            completion(photo);
        }
    }];
    
    
    
//    //PS: result is ALAsset    
//    ALAssetsLibrary *libray = [[[ALAssetsLibrary alloc] init] autorelease];  
//    [libray enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {  
//        
//        if(!group) 
//        {
//            *stop = YES;
//            return;
//        }
//        
//        //设置过滤对象  
//        ALAssetsFilter *filter = [ALAssetsFilter allPhotos];  
//        [group setAssetsFilter:filter];  
//        
//        //如果没有照片
//        if(group.numberOfAssets == 0)
//        {
//            *stop = YES;
//            return;
//        }
//        
//        //取随机照片
//        int radm = (int)[DDFunction randomFrom:0 to:(group.numberOfAssets-1)];
//        
//        //通过文件夹枚举遍历所有的相片ALAsset对象，有多少照片，则调用多少次block  
//        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {  
//            
//            if(index == radm && result)
//            {
//                *stop = YES;
//                
//                UIImage *photo = [UIImage imageWithCGImage:[[result defaultRepresentation] fullScreenImage]];
//                if(completion)
//                {
//                    //返回给block
//                    completion(photo);
//                }
//            }   
//        }];  
//        
//    } failureBlock:^(NSError *error) {  
//        
//    }];  
}

+ (UIImage *)photoFromALAsset:(ALAsset*)asset
{
    if(!asset) return nil;
    
    UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
    return image;
}






@end
