//
//  XKRWWeekAnalysisView.m
//  XKRW
//
//  Created by ss on 16/5/3.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWWeekAnalysisView.h"
#import "Masonry.h"

@implementation XKRWWeekAnalysisView

- (instancetype)initWithFrame:(CGRect)frame withBussiness:(XKRWStatiscBussiness5_3 *)bussiness
{
    self = [super initWithFrame:frame];
    if (self) {
        _bussiness = bussiness;
    }
    return self;
}

-(XKRWStatiscHeadView *)headView{
    if (!_headView) {
        CGRect frame = CGRectMake(0, 0, XKAppWidth, HeadViewHeight);
        _headView = [[XKRWStatiscHeadView alloc] initWithFrame:frame type:1 withBussiness:_bussiness];
        _headView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_headView];
    }
    return _headView;
}

-(XKRWStatisticDetailView *)eatDecreaseView{
    if (!_eatDecreaseView) {
        _eatDecreaseView = [[XKRWStatisticDetailView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, StatisticAnalysisViewHeight) type:analysizeEat statisType:1 withBussiness:_bussiness];
        _eatDecreaseView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_eatDecreaseView];
    }
    return _eatDecreaseView;
}

-(XKRWStatisticDetailView *)sportDecreaseView{
    if (!_sportDecreaseView) {
        _sportDecreaseView = [[XKRWStatisticDetailView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, StatisticAnalysisViewHeight) type:analysizeSport statisType:1 withBussiness:_bussiness];
        _sportDecreaseView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_sportDecreaseView];
    }
    return _sportDecreaseView;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints {
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.width.mas_equalTo(XKAppWidth);
        make.height.mas_equalTo(HeadViewHeight);
    }];
    [self.eatDecreaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(XKAppWidth);
        make.height.mas_equalTo(StatisticAnalysisViewHeight);
        make.top.mas_equalTo(self.headView.mas_bottom).offset(10);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
    [self.sportDecreaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(XKAppWidth);
        make.height.mas_equalTo(StatisticAnalysisViewHeight);
        make.top.mas_equalTo(self.eatDecreaseView.mas_bottom).offset(10);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
     [super updateConstraints];
}
@end
