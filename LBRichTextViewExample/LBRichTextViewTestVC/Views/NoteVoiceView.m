//
//  NoteVoiceView.m
//  PerpetualCalendar
//
//  Created by 刘彬 on 2019/7/19.
//  Copyright © 2019 BIN. All rights reserved.
//

#import "NoteVoiceView.h"
#import <AVFoundation/AVFoundation.h>

@interface NoteVoiceView()
@property (nonatomic,strong)UITableViewCell *cell;
@property (nonatomic,strong)AVPlayer *player;
@end
@implementation NoteVoiceView
- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        self.clipsToBounds = YES;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;
        self.paragraphStyle = paragraphStyle;
        
        self.cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        
        self.cell.userInteractionEnabled = NO;
        self.cell.textLabel.enabled = YES;
        self.cell.detailTextLabel.enabled = YES;
        
        self.cell.textLabel.textColor = [UIColor whiteColor];
        self.cell.detailTextLabel.textColor = [UIColor whiteColor];
        
        self.cell.textLabel.text = @"录音";
        
        UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        timeLable.textAlignment = NSTextAlignmentCenter;
        timeLable.textColor = [UIColor whiteColor];
        
        self.cell.accessoryView = timeLable;
        
        
        [self addSubview:self.cell];
        
        [self addTarget:self action:@selector(pauseOrPlay) forControlEvents:UIControlEventTouchUpInside];
        
        
        //默认远离耳朵
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        //监听是否靠近耳朵
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    return self;
}

-(void)pauseOrPlay{
    if (!self.player) {
        self.player = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:self.lb_identifier isDirectory:YES]];
        //监听 timeControlStatus
        [self.player addObserver:self forKeyPath:NSStringFromSelector(@selector(timeControlStatus)) options:NSKeyValueObservingOptionNew context:nil];
    }
    
    if (@available(iOS 10.0, *)) {
        if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
            [self.player pause];
        }else{
            [self.player play];
        }
    } else {
        // Fallback on earlier versions
    }
}


-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.layer.cornerRadius = CGRectGetHeight(frame)/2;

    self.cell.frame = CGRectMake(15, 15, CGRectGetWidth(frame)-15, CGRectGetHeight(frame)-15*2);
}
        
-(void)setLb_identifier:(NSString *)lb_identifier{
    _lb_identifier = lb_identifier;
    NSString *fileName = [lb_identifier componentsSeparatedByString:@"/"].lastObject;
    NSTimeInterval timeInterval = [fileName doubleValue];
    
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:lb_identifier] options:opts]; // 初始化视频媒体文件
    NSUInteger second = 0;
    second = ceil(urlAsset.duration.value / urlAsset.duration.timescale); // 获取视频总时长,单位秒
    ((UILabel *)self.cell.accessoryView).text = [NSString stringWithFormat:@"%lu:%02ld",second/60,second%60];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"yyyyMMddHHmmss";
    self.cell.detailTextLabel.text = [f stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
}


#pragma mark - 监听是否靠近耳朵
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        //靠近耳朵
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }else{
        //远离耳朵
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(timeControlStatus))]) {
        if (@available(iOS 10.0, *)) {
            if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
                [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
            }else{
                [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player removeObserver:self forKeyPath:NSStringFromSelector(@selector(timeControlStatus))];
}
@end
