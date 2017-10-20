//
//  TTLyricView.m
//  TTLyricView
//
//  Created by cocoawork on 2017/10/19.
//  Copyright © 2017年 cocoawork. All rights reserved.
//

#import "TTLyricView.h"
#import "TTLyricFile.h"
#import "TTLyricRow.h"

@interface TTLyricView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, assign)NSInteger cotentOffsetY;

@end

@implementation TTLyricView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 40;
    [self addSubview:_tableView];
    [_tableView setScrollEnabled:NO];
    [_tableView setContentInset:UIEdgeInsetsMake((self.bounds.size.height) / 2, 0, 0, 0)];
}


- (void)setLyricFile:(TTLyricFile *)lyricFile {
    _lyricFile = lyricFile;
    [_tableView reloadData];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [_tableView reloadData];
}


- (void)refreshStateWithCurrentDuration:(NSInteger)duration {
    NSInteger idx = [_lyricFile lyricIndexForCurrentDuration:duration];
    if (_currentIndex != idx) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
        NSLog(@"%@", NSStringFromUIEdgeInsets(_tableView.contentInset));
        if (([_lyricFile lyricContents].count - idx - 1) * [_tableView rowHeight] <= _tableView.frame.size.height / 2) {
            _cotentOffsetY -= [_tableView rowHeight];
            UIEdgeInsets inset = UIEdgeInsetsMake(_cotentOffsetY, 0, 0, 0);
            _tableView.contentInset = inset;
        }
    }
    _currentIndex = idx;

}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_lyricFile) {
        return [[_lyricFile stamps] count];
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTLyricRow *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TTLyricRow alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [[_lyricFile lyricContents] objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == [_lyricFile lyricContents].count - 1) {
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(lyricView:didShowLyricAtIndex:)]) {
        [_delegate lyricView:self didShowLyricAtIndex:indexPath.row];
    }
}

@end
