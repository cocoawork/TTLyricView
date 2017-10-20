//
//  TTLyricRow.m
//  TTLyricView
//
//  Created by cocoawork on 2017/10/20.
//  Copyright © 2017年 cocoawork. All rights reserved.
//

#import "TTLyricRow.h"

@implementation TTLyricRow

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.textLabel.textColor = [UIColor redColor];
        self.textLabel.font = [UIFont systemFontOfSize:15];
    }else {
        self.textLabel.textColor = [UIColor grayColor];
        self.textLabel.font = [UIFont systemFontOfSize:12];
    }
}



@end
