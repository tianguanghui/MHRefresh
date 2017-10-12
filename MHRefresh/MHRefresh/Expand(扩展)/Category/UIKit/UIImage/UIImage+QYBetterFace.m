//
//  UIImage+QYBetterFace.m
//  MHRefresh
//
//  Created by developer on 2017/10/11.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UIImage+QYBetterFace.h"

#define GOLDEN_RATIO (0.618)

@implementation UIImage (QYBetterFace)

- (UIImage *)betterFaceImageForSize:(CGSize)size accuracy:(QYBFAccuracy)accurary; {
    
    NSArray *features = [[self class] faceFeaturesInImage:self accuracy:accurary];
    
    if ([features count] == 0) {
        return self;
    } else {
        return [self subImageForFaceFeatures:features size:size];
    }
}

- (UIImage *)subImageForFaceFeatures:(NSArray *)faceFeatures size:(CGSize)size {
    
    CGRect fixedRect = CGRectMake(MAXFLOAT, MAXFLOAT, 0, 0);
    CGFloat rightBorder = 0, bottomBorder = 0;
    for (CIFaceFeature *faceFeature in faceFeatures){
        CGRect oneRect = faceFeature.bounds;
        oneRect.origin.y = size.height - oneRect.origin.y - oneRect.size.height;
        
        fixedRect.origin.x = MIN(oneRect.origin.x, fixedRect.origin.x);
        fixedRect.origin.y = MIN(oneRect.origin.y, fixedRect.origin.y);
        
        rightBorder = MAX(oneRect.origin.x + oneRect.size.width, rightBorder);
        bottomBorder = MAX(oneRect.origin.y + oneRect.size.height, bottomBorder);
    }
    
    fixedRect.size.width = rightBorder - fixedRect.origin.x;
    fixedRect.size.height = bottomBorder - fixedRect.origin.y;
    
    CGPoint fixedCenter = CGPointMake(fixedRect.origin.x + fixedRect.size.width / 2.0,
                                      fixedRect.origin.y + fixedRect.size.height / 2.0);
    CGPoint offset = CGPointZero;
    CGSize finalSize = size;
    if (size.width / size.height > self.size.width / self.size.height) {
        //move horizonal
        finalSize.height = self.size.height;
        finalSize.width = size.width/size.height * finalSize.height;
        fixedCenter.x = finalSize.width / size.width * fixedCenter.x;
        fixedCenter.y = finalSize.width / size.width * fixedCenter.y;
        
        offset.x = fixedCenter.x - self.size.width * 0.5;
        if (offset.x < 0) {
            offset.x = 0;
        } else if (offset.x + self.size.width > finalSize.width) {
            offset.x = finalSize.width - self.size.width;
        }
        offset.x = - offset.x;
    } else {
        //move vertical
        finalSize.width = self.size.width;
        finalSize.height = size.height/size.width * finalSize.width;
        fixedCenter.x = finalSize.width / size.width * fixedCenter.x;
        fixedCenter.y = finalSize.width / size.width * fixedCenter.y;
        
        offset.y = fixedCenter.y - self.size.height * (1 - GOLDEN_RATIO);
        if (offset.y < 0) {
            offset.y = 0;
        } else if (offset.y + self.size.height > finalSize.height){
            offset.y = finalSize.height = self.size.height;
        }
        offset.y = - offset.y;
    }
    
    CGRect finalRect = CGRectApplyAffineTransform(CGRectMake(offset.x, offset.y, finalSize.width, finalSize.height),
                                                  CGAffineTransformMakeScale(self.scale, self.scale));
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], finalRect);
    UIImage *subImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return subImage;
}

#pragma mark - Util

+ (NSArray *)faceFeaturesInImage:(UIImage *)image accuracy:(QYBFAccuracy)accurary {
    
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    NSString *accuraryStr = (accurary == QYBFAccuracyLow) ? CIDetectorAccuracyLow : CIDetectorAccuracyHigh;
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:@{CIDetectorAccuracy: accuraryStr}];
    
    return [detector featuresInImage:ciImage];
}

@end
