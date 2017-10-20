//
//  TTLyricView.h
//  TTLyricView
//
//  Created by cocoawork on 2017/10/19.
//  Copyright © 2017年 cocoawork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTLyricFile, TTLyricView;

@protocol TTLyricViewDelegate<NSObject>

- (void)lyricView:(TTLyricView *)lyricView didShowLyricAtIndex:(NSInteger)index;

@end


@interface TTLyricView : UIView

@property (nonatomic, assign)id<TTLyricViewDelegate> delegate;
@property (nonatomic, strong)TTLyricFile *lyricFile;

- (void)refreshStateWithCurrentDuration:(NSInteger)duration;

@end
