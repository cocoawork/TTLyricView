//
//  ViewController.m
//  TTLyricView
//
//  Created by cocoawork on 2017/10/19.
//  Copyright © 2017年 cocoawork. All rights reserved.
//

#import "TTLyricViewController.h"
#import "TTLyricFile.h"
#import "TTLyricView.h"


@interface TTLyricViewController ()

@property (nonatomic, assign)NSInteger duration;
@property (nonatomic, strong)TTLyricView *lyricView;

@end

@implementation TTLyricViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"2079147" ofType:@"lrc"];
    NSURL *url = [NSURL fileURLWithPath:path];
    TTLyricFile *file = [[TTLyricFile alloc] initWithURL:url];
    self.lyricView = [[TTLyricView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_lyricView];
    [_lyricView setLyricFile:file];


    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(refresh)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

}


- (void)refresh {
    [_lyricView refreshStateWithCurrentDuration:_duration];
    _duration += 10;
}


@end
