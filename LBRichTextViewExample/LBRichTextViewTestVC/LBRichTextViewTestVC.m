//
//  LBRichTextViewTestVC.m
//  test
//
//  Created by 刘彬 on 2019/9/10.
//  Copyright © 2019 刘彬. All rights reserved.
//

#import "LBRichTextViewTestVC.h"
#import "SVProgressHUD.h"
#import "TZImagePickerController.h"

#import "NoteImageView.h"
#import "NoteVoiceView.h"
#import "VideoView.h"
#import "LBRichTextView.h"


@interface LBRichTextViewTestVC ()
@property (nonatomic,strong)LBRichTextView *textView;

@property (nonatomic,strong)UIView *windowTopRecorderView;
@property (nonatomic,strong)UILabel *windowTopRecorderLabel;
@property (nonatomic, strong)AVAudioRecorder *audioRecorder;//音频录音机

@end

@implementation LBRichTextViewTestVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initAudioRecorder];
    
    LBRichTextView *textView = [[LBRichTextView alloc] initWithFrame:CGRectMake(15, 100, CGRectGetWidth(self.view.frame)-15*2, 500)];
    textView.font = [UIFont systemFontOfSize:15];
    textView.layer.cornerRadius = 10;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.borderWidth = 3;
    textView.contentSize = CGSizeMake(CGRectGetWidth(textView.frame), 2000);
    [self.view addSubview:textView];
    _textView = textView;
    
    
    typeof(self) __weak weakSelf = self;
    textView.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60)];

    NSArray<NSString *> *functionTitleArray = @[@"照片或视频",@"录音"];
    [functionTitleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *functionBtn = [[UIButton alloc] initWithFrame:CGRectMake(idx*CGRectGetWidth(textView.inputAccessoryView.frame)/functionTitleArray.count, 0, CGRectGetWidth(textView.inputAccessoryView.frame)/functionTitleArray.count, CGRectGetHeight(textView.inputAccessoryView.frame))];
        [functionBtn setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
        functionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [functionBtn setTitle:obj forState:UIControlStateNormal];
        [textView.inputAccessoryView addSubview:functionBtn];
        [functionBtn addTarget:weakSelf action:@selector(functionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    
    _windowTopRecorderView = [[UIView alloc] initWithFrame:CGRectMake(0, -84, CGRectGetWidth(self.view.bounds), 84)];
    _windowTopRecorderView.backgroundColor = [UIColor blueColor];
    
    UIButton *pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_windowTopRecorderView.frame)-40, 40, 40)];
    [pauseBtn setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
    [pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [pauseBtn addTarget:self action:@selector(audioRecordPause) forControlEvents:UIControlEventTouchUpInside];
    [_windowTopRecorderView addSubview:pauseBtn];
    
    UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_windowTopRecorderView.frame)-CGRectGetWidth(pauseBtn.frame), CGRectGetMinY(pauseBtn.frame), CGRectGetWidth(pauseBtn.frame), CGRectGetHeight(pauseBtn.frame))];
    [finishBtn setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(recorderFinish:) forControlEvents:UIControlEventTouchUpInside];
    [_windowTopRecorderView addSubview:finishBtn];
    
    _windowTopRecorderLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pauseBtn.frame), CGRectGetMinY(pauseBtn.frame), CGRectGetMinX(finishBtn.frame)-CGRectGetMaxX(pauseBtn.frame), CGRectGetHeight(finishBtn.frame))];
    _windowTopRecorderLabel.textColor = [UIColor whiteColor];
    _windowTopRecorderLabel.textAlignment = NSTextAlignmentCenter;
    _windowTopRecorderLabel.font = [UIFont systemFontOfSize:15];
    _windowTopRecorderLabel.text = @"正在录制 0:00";
    [_windowTopRecorderView addSubview:_windowTopRecorderLabel];
    
    [[UIApplication sharedApplication].delegate.window addSubview:_windowTopRecorderView];
    
}
-(void)initAudioRecorder{
    //创建录音文件保存路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingFormat:@"/audio.caf"];
    NSURL *url = [NSURL URLWithString: path];
    //创建录音格式设置***************************
    //LinearPCM 是iOS的一种无损编码格式,但是体积较为庞大
    //录音设置
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    //***************************
    //创建录音机
    NSError *error=nil;
    self.audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:recordSettings error:&error];
    //如果要监控声波则必须设置为YES
    self.audioRecorder.meteringEnabled=YES;
}


-(void)audioRecordPause{
    if (self.audioRecorder.isRecording) {
        [self.audioRecorder pause];
    }else{
        [self.audioRecorder record];
    }
}

-(void)functionBtnAction:(UIButton *)sender{
    NSString *currentTitle = sender.currentTitle;
    
    if ([currentTitle containsString:@"照片"]) {
        [self takePicture];
    }
    else if ([currentTitle containsString:@"录音"]){
        [self startRecordNotice];
    }
}

#pragma mark -- 选照片
-(void)takePicture{
    typeof(self) __weak weakSelf = self;
    TZImagePickerController *vc = [[TZImagePickerController alloc] initWithMaxImagesCount:4 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
    vc.isSelectOriginalPhoto = YES;
    // 设置是否可以选择视频/图片/原图
    vc.allowPickingVideo = YES;
    vc.allowPickingOriginalPhoto = NO;
    // 照片排列按修改时间降序且拍照按钮在第一个
    vc.sortAscendingByModificationDate = NO;
    vc.allowCrop = NO;
    vc.needCircleCrop = NO;
    [vc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        __block NSUInteger index = 0;//取当前输入的index位置
        [weakSelf.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, weakSelf.textView.selectedRange.location) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            index ++;
        }];
        
        CGFloat textViewContentWidth = CGRectGetWidth(weakSelf.textView.frame)-weakSelf.textView.contentInset.left-weakSelf.textView.contentInset.right;
        
        [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSData * imageData = UIImageJPEGRepresentation(obj,0.5);
            UIImage *image = [UIImage imageWithData:imageData];
            
            
            CGFloat imageWidth = textViewContentWidth-15;
            CGFloat imageHeight = image.size.height*(imageWidth/image.size.width);
            
            NoteImageView *noteImageV = [[NoteImageView alloc] init];
            noteImageV.lb_identifier = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            noteImageV.bounds = CGRectMake(0, 0, imageWidth, imageHeight);
            [noteImageV setImage:image forState:UIControlStateNormal];
            
            LBRichTextObject *richText = [[LBRichTextObject alloc] init];
            richText.attachmentView = noteImageV;
            [weakSelf.textView.richTextArray insertObject:richText atIndex:index];
            index ++;
            
            [weakSelf.textView reloadData];
            
        }];
    }];
    [vc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.networkAccessAllowed = YES;
            options.version = PHVideoRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            
            [SVProgressHUD showWithStatus:@"视频处理中..."];
            [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
                [SVProgressHUD dismiss];
                
                __block NSUInteger index = 0;//取当前输入的index位置
                [weakSelf.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, weakSelf.textView.selectedRange.location) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
                    index ++;
                }];
                
                CGFloat textViewContentWidth = CGRectGetWidth(weakSelf.textView.frame)-weakSelf.textView.contentInset.left-weakSelf.textView.contentInset.right;
                
                
                NSData * imageData = UIImageJPEGRepresentation(coverImage,0.5);
                UIImage *image = [UIImage imageWithData:imageData];
                
                
                CGFloat imageWidth = textViewContentWidth-15;
                CGFloat imageHeight = image.size.height*(imageWidth/image.size.width);
                if (imageHeight > imageWidth) {
                    imageHeight = imageWidth;
                }
                
                VideoView *videoView = [[VideoView alloc] init];
                videoView.lb_identifier = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                videoView.bounds = CGRectMake(0, 0, imageWidth, imageHeight);
                [videoView setImage:image forState:UIControlStateNormal];
                videoView.playerItem = playerItem;
                
                LBRichTextObject *richText = [[LBRichTextObject alloc] init];
                richText.attachmentView = videoView;
                [weakSelf.textView.richTextArray insertObject:richText atIndex:index];
                [weakSelf.textView reloadData];
                
                
            }];
            
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark -- 录音开始
- (void)startRecordNotice{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
    }
    // 删掉录音文件
    [self.audioRecorder deleteRecording];
    //创建音频会话对象
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置category
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    if (![self.audioRecorder isRecording]){
        // 首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        [self.audioRecorder record];
        
        typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.windowTopRecorderView.frame = CGRectMake(CGRectGetMinX(weakSelf.windowTopRecorderView.frame), 0, CGRectGetWidth(weakSelf.windowTopRecorderView.bounds), CGRectGetHeight(weakSelf.windowTopRecorderView.bounds));
        }];
        if (@available(iOS 10.0, *)) {
            [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                NSInteger currentTime = @(weakSelf.audioRecorder.currentTime).integerValue;
                weakSelf.windowTopRecorderLabel.text = [NSString stringWithFormat:@"%@ %lu:%02ld",weakSelf.audioRecorder.isRecording?@"正在录制":@"暂停录制",currentTime/60,currentTime%60];
            }];
        } else {
            // Fallback on earlier versions
        }
    }
}
-(void)recorderFinish:(UIButton *)sender{
    [self.audioRecorder stop];
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *tempPath = [documentDirectory stringByAppendingFormat:@"/audio.caf"];
    NSString *audioPath = [documentDirectory stringByAppendingFormat:@"/%f.caf",[[NSDate date] timeIntervalSince1970]];
    [[NSData dataWithContentsOfFile:tempPath] writeToFile:audioPath atomically:YES];
    
    typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.windowTopRecorderView.frame = CGRectMake(CGRectGetMinX(weakSelf.windowTopRecorderView.frame), -CGRectGetHeight(weakSelf.windowTopRecorderView.frame), CGRectGetWidth(weakSelf.windowTopRecorderView.frame), CGRectGetHeight(weakSelf.windowTopRecorderView.frame));
    }];
    
    __block NSUInteger index = 0;
    [self.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, weakSelf.textView.selectedRange.location) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        index ++;
    }];
    
    NoteVoiceView *voiceView = [[NoteVoiceView alloc] init];
    voiceView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.textView.bounds)-self.textView.contentInset.left*2-25, 50);
    voiceView.lb_identifier = audioPath;
    
    LBRichTextObject *richText = [[LBRichTextObject alloc] init];
    richText.attachmentView = voiceView;
    [self.textView.richTextArray insertObject:richText atIndex:index];
    [self.textView reloadData];
}

@end
