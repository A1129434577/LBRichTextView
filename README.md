# LBRichTextView
```objc
//初始化
LBRichTextView *textView = [[LBRichTextView alloc] initWithFrame:CGRectMake(15, 100, CGRectGetWidth(self.view.frame)-15*2, 500)];
[self.view addSubview:textView];

//一个遵循LBTextAttachmentViewProtocol的View
NoteVoiceView *voiceView = [[NoteVoiceView alloc] init];
voiceView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.textView.bounds)-self.textView.contentInset.left*2-25, 50);//设置其bounds
//voiceView.paragraphStyle可以通过设置该属性定位该view的相对位置
voiceView.lb_identifier = audioPath;//唯一标识

//便利textView，定位当前输入点的index
__block NSUInteger index = 0;
[self.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, weakSelf.textView.selectedRange.location) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
    index ++;
}];
//一个遵循LBRichTextProtocol的对象
LBRichTextObject *richText = [[LBRichTextObject alloc] init];
richText.attachmentView = voiceView;
[self.textView.richTextArray insertObject:richText atIndex:index];//插入当前输入点
[self.textView reloadData];//重要的一步：刷新
```
![](https://github.com/A1129434577/LBRichTextView/blob/master/LBRichTextView.gif?raw=true)
