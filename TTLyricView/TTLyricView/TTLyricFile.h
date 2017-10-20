//
//  TTLyricParser.h
//  TTLyricView
//
//  Created by cocoawork on 2017/10/19.
//  Copyright © 2017年 cocoawork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTLyricFile : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *artist;
@property (nonatomic, copy)NSString *album;
@property (nonatomic, strong)NSArray *stamps;
@property (nonatomic, strong)NSArray *lyricContents;

- (instancetype)initWithURL:(NSURL *)fileURL;

- (NSString *)lyricForMicrosecond:(double)microsecond;

- (NSInteger)lyricIndexForCurrentDuration:(NSInteger)duration;

@end
