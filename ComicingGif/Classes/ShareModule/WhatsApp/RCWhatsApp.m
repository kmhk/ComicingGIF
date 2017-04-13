//
//  RCWhatsApp.m
//  RCWhatsAppDemo
//
//  Created by Mark Glagola on 10/20/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "RCWhatsApp.h"

@interface RCWhatsApp ()

@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@end

@implementation RCWhatsApp

NSString* const kWhatsAppAppURLString = @"whatsapp://app";
NSString* const kWhatsAppOnlyPhotoFileName = @"tmptmpimg.wai";

- (instancetype)init {
    if (self = [super init]) {
        self.photoFileName = kWhatsAppOnlyPhotoFileName;
    }
    return self;
}

+ (BOOL)isAppInstalled {
    NSURL *appURL = [NSURL URLWithString:kWhatsAppAppURLString];
    return [[UIApplication sharedApplication] canOpenURL:appURL];
}

//Technically the WhatsApp allows for photos to be published under the size of 612x612
//BUT if you want nice quality pictures, I recommend checking the image size.
+ (BOOL)isImageCorrectSize:(UIImage*)image {
    CGImageRef cgImage = [image CGImage];
    return (CGImageGetWidth(cgImage) >= 612 && CGImageGetHeight(cgImage) >= 612);
}

- (NSString*)photoFilePath {
    return [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],self.photoFileName];
}

- (void)postImage:(UIImage*)image inView:(UIView*)view {
    [self postImage:image withCaption:nil inView:view];
}
- (void)postImage:(UIImage*)image withCaption:(NSString*)caption inView:(UIView*)view {
    [self postImage:image withCaption:caption inView:view delegate:nil];
}

- (void)postImage:(UIImage*)image withCaption:(NSString*)caption inView:(UIView*)view delegate:(id<UIDocumentInteractionControllerDelegate>)delegate {
    NSParameterAssert(image);
    
    if (!image) {
        return;
    }
    
    [UIImagePNGRepresentation(image)/*UIImageJPEGRepresentation(image, 1.0)*/ writeToFile:[self photoFilePath] atomically:YES];
    
    NSURL *fileURL = [NSURL fileURLWithPath:[self photoFilePath]];
    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    self.documentInteractionController.UTI = @"net.whatsapp.image";
    self.documentInteractionController.delegate = delegate;
    if (caption) {
        self.documentInteractionController.annotation = @{@"WhatsAppCaption" : caption};
    }
    [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:view animated:YES];
}


@end
