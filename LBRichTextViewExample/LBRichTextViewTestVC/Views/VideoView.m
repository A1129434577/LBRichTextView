//
//  VideoView.m
//  test
//
//  Created by 刘彬 on 2019/9/10.
//  Copyright © 2019 刘彬. All rights reserved.
//

#import "VideoView.h"
@interface VideoView()
@property (nonatomic,strong)UIButton *playBtn;
@property (nonatomic,strong)AVPlayer *player;
@property (nonatomic,strong)AVPlayerLayer *avLayer;
@end

@implementation VideoView
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
        
        _playBtn = [[UIButton alloc] init];
        _playBtn.backgroundColor = [UIColor whiteColor];
        [_playBtn setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
        [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
        
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        //显示画面
        _avLayer = [[AVPlayerLayer alloc] init];
        _avLayer.frame = window.bounds;

        //视频填充模式
        _avLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [window.layer addSublayer:_avLayer];
        
        
        
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureCallback)];
        doubleTap.numberOfTapsRequired = 2;
        [window addGestureRecognizer:doubleTap];
        
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    _playBtn.frame = CGRectMake((CGRectGetWidth(frame)-60)/2, (CGRectGetHeight(frame)-60)/2, 60, 60);
    
    [self addSubview:_playBtn];
    
    [_playBtn addTarget:self action:@selector(pauseOrPlay) forControlEvents:UIControlEventTouchUpInside];

}

-(void)doubleTapGestureCallback{
    _avLayer.hidden = YES;
}

-(void)pauseOrPlay{
    if (!self.player) {
        self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
        self.avLayer.player = self.player;
    }
    
    if (@available(iOS 10.0, *)) {
        if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
            [self.player pause];
        }else{
            [self.player play];
            self.avLayer.hidden = NO;
        }
    } else {
        // Fallback on earlier versions
    }
}
@end
