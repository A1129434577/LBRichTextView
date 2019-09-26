//
//  NoteImageView.m
//  PerpetualCalendar
//
//  Created by 刘彬 on 2019/7/22.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "NoteImageView.h"
//#import "LBPhotoPreviewController.h"

@implementation NoteImageView
- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;
        self.paragraphStyle = paragraphStyle;
        
        UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageReview)];
        g.numberOfTapsRequired = 2;
        [self addGestureRecognizer:g];
        
    }
    return self;
}

-(void)imageReview{
    UIViewController *selfVC = (UIViewController *)self.nextResponder;
    while (![selfVC isKindOfClass:UIViewController.self]) {
        selfVC = (UIViewController *)selfVC.nextResponder;
    }
    
//    LBPhotoPreviewController *photoPreviewC = [[LBPhotoPreviewController alloc] init];
//    photoPreviewC.deleteBtn.hidden = YES;
//    LBImageObject *image = [[LBImageObject alloc] init];
//    image.image = self.currentImage;
//    photoPreviewC.imageObjectArray = @[image].mutableCopy;
//    [selfVC presentViewController:photoPreviewC animated:YES completion:NULL];
    
}
@end
