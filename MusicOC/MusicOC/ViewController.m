//
//  ViewController.m
//  MusicOC
//
//  Created by 陈少文 on 16/7/24.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "ViewController.h"
#import <QqqssaMusicEngine/QqqssaMusicEngine.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    QqqssaMusicPlayer *q = [QqqssaMusicPlayer sharedInstance];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@"http://yinyueshiting.baidu.com/data2/music/58804985/58804985.mp3?xcode=981be538a9dadbcf59dc68219d22c373"]];
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:playerItem];
    q.playerItems = arr;
    [q playAtIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
