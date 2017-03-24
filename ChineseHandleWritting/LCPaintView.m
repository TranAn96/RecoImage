//
//  LCPaintView.m
//  LCPaintView
//
//  Created by Leo on 03/02/2017.
//  Copyright © 2017 Leo. All rights reserved.
//

#import "LCPaintView.h"
#import "LCBezierPath.h"



@interface LCPaintView ()

@property (nonatomic, strong) NSMutableArray<UIBezierPath *> *paths;

@end

@implementation LCPaintView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    for (UIBezierPath *path in self.paths) {
        [path.lineColor set];
        [path stroke];
    }
}

- (NSMutableArray<UIBezierPath *> *)paths {
    if (!_paths) {
        _paths = [[NSMutableArray alloc] init];
    }
    return _paths;
}

- (void)clear {
    [self.paths removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)undo {
    NSLog(@"Now location is : %f - %f ",[_paths lastObject].bounds.origin.x,[_paths lastObject].bounds.origin.y);
    NSLog(@"Now location is : %@ ",[_paths lastObject]);

    [self.paths removeLastObject];
    //[self.paths.lastObject appendPath:[self.paths objectAtIndex:_paths.count - 2]];
    [self setNeedsDisplay];
    
}

#pragma mark - Handle Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint startPoint = [touch locationInView:touch.view];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    if (self.lineWidth != 0) {
        path.lineWidth = self.lineWidth;
    }
    if (self.lineColor) {
        path.lineColor = self.lineColor;
    }
    
    [path moveToPoint:startPoint];
    
    [self.paths addObject:path];
    [self.arrPath addObject:path];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:touch.view];
    
    UIBezierPath *path = [self.paths lastObject];
    
    [path addLineToPoint:currentPoint];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"touchEnd"
     object:self];

}

//+ (NSArray*)getRGBAsFor:(UIImage*)image atX:(float)x andY:(float)y
//{
//    int count = 8;
//    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
//    
//    // First get the image into your data buffer
//    CGImageRef imageRef = [image CGImage];
//    NSUInteger width = CGImageGetWidth(imageRef);
//    NSUInteger height = CGImageGetHeight(imageRef);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
//    NSUInteger bytesPerPixel = 4;
//    NSUInteger bytesPerRow = bytesPerPixel * width;
//    NSUInteger bitsPerComponent = 8;
//    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
//                                                 bitsPerComponent, bytesPerRow, colorSpace,
//                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
//    CGColorSpaceRelease(colorSpace);
//    
//    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
//    CGContextRelease(context);
//    
//    // Now your rawData contains the image data in the RGBA8888 pixel format.
//    NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
//    for (int i = 0 ; i < count ; ++i)
//    {
//        CGFloat alpha = ((CGFloat) rawData[byteIndex + 3] ) / 255.0f;
//        CGFloat red   = ((CGFloat) rawData[byteIndex]     ) / alpha;
//        CGFloat green = ((CGFloat) rawData[byteIndex + 1] ) / alpha;
//        CGFloat blue  = ((CGFloat) rawData[byteIndex + 2] ) / alpha;
//        byteIndex += bytesPerPixel;
//        
//        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
//        [result addObject:acolor];
//    }
//    
//    free(rawData);
//    
//    return result;
//}
//-(float)getResult : (UIImage *)image1 :(UIImage *)image2{
//    float numDifferences = 0.0f;
//    int width = 480;
//    int height = 320;
//    float totalCompares = width * height / 100.0f;
//    for (int yCoord = 0; yCoord < height; yCoord += 10) {
//        for (int xCoord = 0; xCoord < width; xCoord += 10) {
//            
//                int img1RGB[] =
//            
////            int img1RGB[] = getRGBFor : image1 : xCoord : yCoord;
////            int img2RGB[] = [image2 getRGBForX:xCoord andY: yCoord];
//            if (abs(img1RGB[0] - img2RGB[0]) > 25 || abs(img1RGB[1] - img2RGB[1]) > 25 || abs(img1RGB[2] - img2RGB[2]) > 25) {
//                //one or more pixel components differs by 10% or more
//                numDifferences++;
//            }
//        }
//    }
//    
//    if (numDifferences / totalCompares <= 0.1f) {
//        //images are at least 90% identical 90% of the time
//    }
//    else {
//        //images are less than 90% identical 90% of the time
//    }
//}
@end
