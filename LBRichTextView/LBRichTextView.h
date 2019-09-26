//
//  LBRichTextView.h
//  PerpetualCalendar
//
//  Created by 刘彬 on 2019/7/18.
//  Copyright © 2019 BIN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LBTextAttachmentViewProtocol <NSObject>//自定义view协议
@required
@property (nonatomic,strong)NSString *lb_identifier;//自定义View的唯一标识
@optional
@property (nonatomic,strong)NSParagraphStyle *paragraphStyle;
@end


@protocol LBRichTextProtocol <NSObject>//富文本对象协议
//attachmentView优先使用，也就是当attachmentView不为空的时候attributedString无效。
//属性必须有一个不为空
@required
@property (nonatomic,strong)NSAttributedString *attributedString;
@property (nonatomic,strong)UIView<LBTextAttachmentViewProtocol> *attachmentView;
@end


#pragma mark 自定义便利View,你不是必须用该类，只是提供给我们比较懒的程序员用
@interface LBTextAttachmentView : UIButton<LBTextAttachmentViewProtocol>
@property (nonatomic,strong)NSString *lb_identifier;
@property (nonatomic,strong)NSParagraphStyle *paragraphStyle;
@end

@interface LBRichTextObject : NSObject<LBRichTextProtocol>
@property (nonatomic,strong)NSAttributedString *attributedString;
@property (nonatomic,strong)UIView<LBTextAttachmentViewProtocol> *attachmentView;
@end

#pragma mark

@interface LBRichTextView : UITextView
@property (nonatomic,strong)NSMutableArray<NSObject<LBRichTextProtocol> *> *richTextArray;
-(void)reloadData;
@end

NS_ASSUME_NONNULL_END
