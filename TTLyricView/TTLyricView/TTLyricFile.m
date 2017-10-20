//
//  TTLyricParser.m
//  TTLyricView
//
//  Created by cocoawork on 2017/10/19.
//  Copyright © 2017年 cocoawork. All rights reserved.
//

#import "TTLyricFile.h"


@interface TTLyricFile ()

@property (nonatomic, strong)NSMutableArray *timeArray;
@property (nonatomic, strong)NSMutableDictionary *lyrics;
@property (nonatomic, strong)NSURL *lyricURL;


@end


@implementation TTLyricFile

- (instancetype)initWithURL:(NSURL *)fileURL
{
    self = [super init];
    if (self) {
        self.timeArray = [@[] mutableCopy];
        self.lyrics = [NSMutableDictionary dictionaryWithCapacity:0];
        self.lyricURL = fileURL;
        self.lyricContents = @[];
        [self parser];
    }
    return self;
}


- (void)parser {
    //读取歌词文件
    NSError *fileError;
    NSString *content = [NSString stringWithContentsOfURL:_lyricURL encoding:NSUTF8StringEncoding error:&fileError];
    if (fileError) {
        return;
    }
    NSArray *temp = [content componentsSeparatedByString:@"\n"];
    for (NSString *c in temp) {
        NSString *tmp = [[c stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        if ([tmp hasPrefix:@"["] && [tmp hasSuffix:@"]"]) {
            tmp = [[tmp stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
            NSArray *keyValues = [tmp componentsSeparatedByString:@":"];
            if ([[keyValues firstObject] isEqualToString:@"ti"]) {
                _title = [keyValues lastObject];
            }
            if ([[keyValues firstObject] isEqualToString:@"ar"]) {
                _artist = [keyValues lastObject];
            }
            if ([[keyValues firstObject] isEqualToString:@"al"]) {
                _album = [keyValues lastObject];
            }
        }else {
            NSArray *keyValues = [tmp componentsSeparatedByString:@"]"];
            NSString *timeStamp;
            NSString *lyric;
            for (NSString *k in keyValues) {
                NSString *tmp = [k stringByReplacingOccurrencesOfString:@" " withString:@""];
                if ([tmp hasPrefix:@"["]) {   //时间标签
                    //将时间标签转换为时间戳
                    tmp = [tmp stringByReplacingOccurrencesOfString:@"[" withString:@""];
                    NSArray *timeComponent1 = [tmp componentsSeparatedByString:@":"];
                    NSArray *timeComponent2 = [[timeComponent1 lastObject] componentsSeparatedByString:@"."];
                    NSString *minute = [timeComponent1 firstObject];
                    NSString *second = [timeComponent2 firstObject];
                    NSString *miscroSecond = [timeComponent2 lastObject];
                    //将时间转换为微秒
                    NSInteger time = [minute integerValue] * 60 * 100 + [second integerValue] * 100 + [miscroSecond integerValue];
                    timeStamp = [NSString stringWithFormat:@"%ld", time];
                    lyric = [keyValues lastObject];
                }
                NSLog(@"%@ ==> %@", timeStamp, lyric);
                if (timeStamp) {
                    [_lyrics setObject:lyric forKey:timeStamp];
                }
            }


        }
    }
    //获取歌词数据字典中所有时间戳key
    NSArray *keys = [_lyrics allKeys];
    //将所有时间戳排序
    _stamps = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        int a = [obj1 intValue];
        int b = [obj2 intValue];
        if (a <= b) {
            return NSOrderedAscending;
        }else {
            return NSOrderedDescending;
        }
    }];
    NSMutableArray *t = [@[] mutableCopy];
    for (NSString *time in _stamps) {
        NSString *content = [_lyrics objectForKey:time];
        [t addObject:content];
    }
    self.lyricContents = [NSArray arrayWithArray:t];
}


- (NSInteger)lyricIndexForCurrentDuration:(NSInteger)duration {
    NSInteger currentTime = 0;
    for (int i = 0; i < [_stamps count]; i++) {
        NSInteger time = [_stamps[i] integerValue];
        if (duration < time) {
            currentTime = [_stamps[i] integerValue];
            break;
        }
    }
//    NSLog(@"%ld || %ld, %ld", duration, currentTime, [_stamps indexOfObject:[NSString stringWithFormat:@"%ld", currentTime]]);
    return [_stamps indexOfObject:[NSString stringWithFormat:@"%ld", currentTime]];
}

- (NSString *)lyricForMicrosecond:(double)microsecond {
    NSInteger currentTime = 0;
    for (int i = 0; i < [_stamps count]; i++) {
        NSInteger time = [_stamps[i] integerValue];
        if (microsecond < time) {
            currentTime = [_stamps[i] integerValue];
            break;
        }
    }
    NSString *key = [NSString stringWithFormat:@"%ld", currentTime];
    return [_lyrics objectForKey:key];
}








@end
