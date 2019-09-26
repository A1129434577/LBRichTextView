//
//  VideoView.h
//  test
//
//  Created by 刘彬 on 2019/9/10.
//  Copyright © 2019 刘彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBRichTextView.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoView : UIButton<LBTextAttachmentViewProtocol>
@property (nonatomic,strong)NSString *lb_identifier;
@property (nonatomic,strong)NSParagraphStyle *paragraphStyle;

@property (nonatomic,strong)AVPlayerItem *playerItem;
@end

NS_ASSUME_NONNULL_END
