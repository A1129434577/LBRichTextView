//
//  NoteVoiceView.h
//  PerpetualCalendar
//
//  Created by 刘彬 on 2019/7/19.
//  Copyright © 2019 BIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBRichTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteVoiceView : UIButton<LBTextAttachmentViewProtocol>
@property (nonatomic,strong)NSString *lb_identifier;
@property (nonatomic,strong)NSParagraphStyle *paragraphStyle;
@end

NS_ASSUME_NONNULL_END
