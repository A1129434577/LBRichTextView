//
//  LBRichTextView.m
//  PerpetualCalendar
//
//  Created by 刘彬 on 2019/7/18.
//  Copyright © 2019 BIN. All rights reserved.

#import "LBRichTextView.h"
#import <AVFoundation/AVFoundation.h>

@interface LBTextAttachment : NSTextAttachment
@property (nonatomic,copy)NSString *lb_identifier;
@end
@implementation LBTextAttachment
@end

@interface LBRichTextView ()<UITextViewDelegate>
@end

@implementation LBRichTextView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.richTextArray = [NSMutableArray array];
    }
    return self;
}

-(void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    //此处不会走textViewDidChange方法，所以手动调一次
    [self textViewDidChange:self];
}

-(void)reloadData{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [_richTextArray enumerateObjectsUsingBlock:^(NSObject<LBRichTextProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.attachmentView) {
            LBTextAttachment *textAttachment = [[LBTextAttachment alloc] init];
            textAttachment.image = [[UIImage alloc] init];//设置一个空的image去掉系统NSTextAttachment自带图标
            textAttachment.lb_identifier = obj.attachmentView.lb_identifier;
            textAttachment.bounds = CGRectMake(0, 0, CGRectGetWidth(obj.attachmentView.bounds), CGRectGetHeight(obj.attachmentView.bounds));
            NSMutableAttributedString *attachmentAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
            if (obj.attachmentView.paragraphStyle) {
                [attachmentAttributedString addAttributes:@{NSParagraphStyleAttributeName:obj.attachmentView.paragraphStyle} range:NSMakeRange(0, attachmentAttributedString.length)];
            }
            [attributedString appendAttributedString:attachmentAttributedString];
            
        }else if (obj.attributedString){
            [attributedString appendAttributedString:obj.attributedString];
        }
    }];
    self.attributedText = attributedString;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    Class RichTextObjectClass;
    if (_richTextArray.count) {
        RichTextObjectClass = _richTextArray.firstObject.class;
    }else{
        RichTextObjectClass = LBRichTextObject.self;
    }
    
     typeof(self) __weak weakSelf = self;
    
    NSMutableArray<NSObject<LBRichTextProtocol> *> *aNewRichTextArray = [[NSMutableArray alloc] init];
    NSMutableArray<UIView<LBTextAttachmentViewProtocol> *> *subViews = [NSMutableArray array];
    [textView.attributedText enumerateAttributesInRange:NSMakeRange(0, textView.attributedText.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        NSObject<LBRichTextProtocol> *richText;
        
        LBTextAttachment *attachment = attrs[NSAttachmentAttributeName];
        if ([attachment isKindOfClass:LBTextAttachment.self] && attachment.lb_identifier) {//如果有lb_identifier则是自定义view
            //取该range所在textView的frame
            UITextPosition *beginning = weakSelf.beginningOfDocument;
            UITextPosition *start = [weakSelf positionFromPosition:beginning offset:range.location];
            UITextPosition *end = [weakSelf positionFromPosition:start offset:range.length];
            UITextRange *textRange = [weakSelf textRangeFromPosition:start toPosition:end];
            CGRect rect = [weakSelf firstRectForRange:textRange];
            
            richText = [weakSelf.richTextArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSObject<LBRichTextProtocol> *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                return [evaluatedObject.attachmentView.lb_identifier isEqual:attachment.lb_identifier];
            }]].firstObject;
            if (richText.attachmentView) {
                rect.size.width = CGRectGetWidth(richText.attachmentView.bounds);
                rect.size.height = CGRectGetHeight(richText.attachmentView.bounds);
                richText.attachmentView.frame = rect;
                
                if (!richText.attachmentView.superview) {
                    [weakSelf addSubview:richText.attachmentView];
                }
                [subViews addObject:richText.attachmentView];
            }
        }else{
            richText = [[RichTextObjectClass alloc] init];
            richText.attributedString = [weakSelf.attributedText attributedSubstringFromRange:range];
        }
        if (richText) {
            [aNewRichTextArray addObject:richText];
        }
        
    }];
    
    _richTextArray = aNewRichTextArray;
    
    
    [textView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(lb_identifier)]) {//先要判定是自定义view
            if (![subViews containsObject:obj]) {
                [obj removeFromSuperview];
            }
        }
    }];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self textViewDidChange:self];
}
@end

@implementation LBTextAttachmentView
@end
@implementation LBRichTextObject
@end


