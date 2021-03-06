
#import "RCTBridgeModule.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
@interface ReadImageData : NSObject <RCTBridgeModule>
@end

@implementation ReadImageData

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(readImage:(NSString *)input callback:(RCTResponseSenderBlock)callback)
{
  
  // Create NSURL from uri
  NSURL *url = [[NSURL alloc] initWithString:input];
  
  // Create an ALAssetsLibrary instance. This provides access to the
  // videos and photos that are under the control of the Photos application.
  ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
  
  // Using the ALAssetsLibrary instance and our NSURL object open the image.
  [library assetForURL:url resultBlock:^(ALAsset *asset) {
    
    // Create an ALAssetRepresentation object using our asset
    // and turn it into a bitmap using the CGImageRef opaque type.
    CGImageRef imageRef = [asset thumbnail];
    // Create UIImageJPEGRepresentation from CGImageRef
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], 0.1);
    
    // Convert to base64 encoded string
    NSString *base64Encoded = [imageData base64EncodedStringWithOptions:0];
    
    callback(@[base64Encoded]);
    
  } failureBlock:^(NSError *error) {
    NSLog(@"that didn't work %@", error);
  }];
  
  
  
}






RCT_EXPORT_METHOD(readImageFull:(NSString *)input callback:(RCTResponseSenderBlock)callback)
{
  
  // Create NSURL from uri
  NSURL *url = [[NSURL alloc] initWithString:input];
  
  // Create an ALAssetsLibrary instance. This provides access to the
  // videos and photos that are under the control of the Photos application.
  ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
  
  // Using the ALAssetsLibrary instance and our NSURL object open the image.
  [library assetForURL:url resultBlock:^(ALAsset *asset) {
    
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    CGImageRef imageRef = [representation fullResolutionImage];
    
    // Create UIImageJPEGRepresentation from CGImageRef
//    NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], 0.1);
    // resize image
    UIImage *actualImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsBeginImageContext(CGSizeMake(800, 800));
    [actualImage drawInRect:CGRectMake(0,0,800, 800)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.1);
    
    // Convert to base64 encoded string
    NSString *base64Encoded = [imageData base64EncodedStringWithOptions:0];
    
    callback(@[base64Encoded]);
    
  } failureBlock:^(NSError *error) {
    NSLog(@"that didn't work %@", error);
  }];
  
  
  
}




@end
