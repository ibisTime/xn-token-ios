//
// Copyright 1999-2015 MyApp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "MyVolumeMeter.h"

static const CGFloat kRefreshInterval = 0.1f;

@implementation MyVolumeMeter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _volumeLightView = [[UIImageView alloc]initWithFrame:self.bounds];
        _volumeLightView.image = [UIImage imageNamed:@"aio_voice_volume_light.png"];
        _volumeLightView.transform = CGAffineTransformMakeScale(0.3f, 1.f);
        [self addSubview:_volumeLightView];
        
        UIImageView *volumeDotView = [[UIImageView alloc]initWithFrame:self.bounds];
        volumeDotView.image = [UIImage imageNamed:@"aio_voice_volume_dot.png"];
        [self addSubview:volumeDotView];
    }
    return self;
}


- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    _volumeMeterDelegate = nil;
    
}


- (void)removeFromSuperview
{
    [_timer invalidate];
    _timer = nil;
    [super removeFromSuperview];
}

// 停止监听更新音量
- (void)endMonitor
{
    [_timer invalidate];
    _timer = nil;
    _volumeLightView.transform = CGAffineTransformMakeScale(0.3, 1.f);
}

// 启动定时器更新音量变化
- (void)startMonitor
{
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:kRefreshInterval target:self selector:@selector(updateVolumeLevel) userInfo:nil repeats:YES];
}

// 更新音量变化
- (void)updateVolumeLevel
{
    // 获取音量值
    if (_volumeMeterDelegate && [_volumeMeterDelegate respondsToSelector:@selector(peakPowerLevel)]) {
        CGFloat peakPower = [_volumeMeterDelegate peakPowerLevel];
        if (peakPower > 1)
        {
            peakPower = 1;
        }
        if (peakPower < 0)
        {
            peakPower = 0;
        }
        CGFloat scale = peakPower * 0.7 + 0.3;
        
        [UIView animateWithDuration:kRefreshInterval animations:^{
            
            _volumeLightView.transform = CGAffineTransformMakeScale(scale, 1.f);
            
        }];
    }
    
}

@end
