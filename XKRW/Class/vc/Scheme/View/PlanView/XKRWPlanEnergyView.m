//
//  XKRWPlanEnergyView.m
//  XKRW
//
//  Created by Shoushou on 16/4/5.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWPlanEnergyView.h"
#import "XKRWFlashingTextView.h"
#import "XKRWUserService.h"

@interface XKRWPlanEnergyView()

@property (nonatomic, strong) UIButton *titleClickButton;
@property (nonatomic, assign) NSInteger currectHabitNumber;
@property (nonatomic, assign) NSInteger intakeNumber;
@property (nonatomic, assign) NSInteger expendNumber;

@end

@implementation XKRWPlanEnergyView
{
    NSInteger _exClickedIndex;
    XKRWFlashingTextView *_remindTextView;
    UILabel *_checkTodayAnalyze;
    CGFloat leastNum;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    CGFloat circleWidth = 95*(XKAppWidth/320.0);
    CGFloat separateWidth = (XKAppWidth - circleWidth * 3) / 4.0;
    
    if (self) {
        
        _exClickedIndex = 0;
        XKSex sex = [[XKRWUserService sharedService] getSex];
        if (sex == eSexMale) {
            leastNum = 1400.f;
        } else if (sex == eSexFemale) {
            leastNum = 1200.f;
        }
        
        _remindTextView = [[XKRWFlashingTextView alloc] initWithFrame:CGRectMake(0, 0, XKAppWidth, 12)];
        _remindTextView.foreColor = [UIColor colorFromHexString:@"000000"];
        _remindTextView.backColor = [UIColor colorFromHexString:@"c7c7c7"];
        _remindTextView.font = XKDefaultFontWithSize(12);
        _remindTextView.alignment = NSTextAlignmentCenter;
        _remindTextView.center = CGPointMake(XKAppWidth/2.0, self.height / 8.0);
        [self addSubview:_remindTextView];
        [_remindTextView textFlashingWithDuration:1.5];
        
        _titleClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleClickButton.size = CGSizeMake(200, 30);
        _titleClickButton.layer.cornerRadius = 5.0;
        _titleClickButton.clipsToBounds = YES;
        _titleClickButton.center = _remindTextView.center;
        _titleClickButton.titleLabel.font = XKDefaultFontWithSize(12);
        [_titleClickButton setTitleColor:colorSecondary_999999 forState:UIControlStateHighlighted];
        [_titleClickButton setTitleColor:XKMainSchemeColor forState:UIControlStateNormal];
        [_titleClickButton addTarget:self action:@selector(titleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _titleClickButton.hidden = YES;
        [self insertSubview:_titleClickButton aboveSubview:_remindTextView];
        
        _eatEnergyCircle = [[XKRWEnergyCircleView alloc] initCircleWithFrame:CGRectMake(separateWidth, 0, circleWidth, circleWidth) Style: XKRWEnergyCircleStyleOpened];
        _eatEnergyCircle.center = CGPointMake(separateWidth + circleWidth / 2.0, self.height / 2.0);
        _eatEnergyCircle.tag = 1;
        [self addSubview:_eatEnergyCircle];
        
        
        _sportEnergyCircle = [[XKRWEnergyCircleView alloc] initCircleWithFrame:CGRectMake(_eatEnergyCircle.right + separateWidth, _eatEnergyCircle.top, circleWidth, circleWidth) Style:XKRWEnergyCircleStyleOpened];
        _sportEnergyCircle.tag = 2;
        [self addSubview:_sportEnergyCircle];
        
        
        _habitEnergyCircle = [[XKRWEnergyCircleView alloc] initCircleWithFrame:CGRectMake(_sportEnergyCircle.right + separateWidth, _sportEnergyCircle.top, circleWidth, circleWidth) Style: XKRWEnergyCircleStyleOpened];
        _habitEnergyCircle.tag = 3;
        [self addSubview:_habitEnergyCircle];
        
        NSArray *titles = @[@"饮食",@"运动",@"习惯"];
        for (int i = 0; i < 3; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = XK_ASSIST_TEXT_COLOR;
            label.font = XKDefaultFontWithSize(14);
            label.text = titles[i];
            [label sizeToFit];
            label.center = CGPointMake(separateWidth *(i + 1) + circleWidth*(i*2 + 1)/2.0,0);
            label.top = _eatEnergyCircle.bottom + 15 * XKRWScaleHeight;
            [self addSubview:label];
        }
        
        
    }
    return self;
}

#pragma mark -- set meals、sports and habits' original state data
- (void)noneSelectedCircleStyle {
    
    if (_exClickedIndex != 1 && _exClickedIndex != 2 && _exClickedIndex != 3) return;
    
    XKRWEnergyCircleView *exCircle = (XKRWEnergyCircleView *)[self viewWithTag:_exClickedIndex];
    
    if (exCircle.style != XKRWEnergyCircleStylePerfect && exCircle) [exCircle setStyle:XKRWEnergyCircleStyleOpened];
    
}

- (void)setEatEnergyCircleGoalNumber:(NSInteger)goalNumber currentNumber:(NSInteger)currentNumber {
    _intakeNumber = currentNumber;
    __weak typeof(self) weakSelf = self;
    
    BOOL isBehaveCurrect = NO;
    if (currentNumber <= goalNumber && currentNumber >= leastNum) {
        isBehaveCurrect = YES;
    } else {
        isBehaveCurrect = NO;
    }
    [_eatEnergyCircle setOpenedViewTiltle:@"已摄入" currentNumber:[NSString stringWithFormat:@"%d",(int)currentNumber] goalNumber:goalNumber unit:@"kcal" isBehaveCurrect:isBehaveCurrect];
    _eatEnergyCircle.energyCircleViewClickBlock = ^(NSInteger index){
        [weakSelf resetCirclesStyle:index];
        
        [weakSelf runEatEnergyCircleWithNewCurrentNumber:weakSelf.intakeNumber];
        if ([weakSelf.delegate respondsToSelector:@selector(energyCircleView:clickedAtIndex:)]) {
            
            [weakSelf.delegate energyCircleView:weakSelf clickedAtIndex:1];
        }
        _selectedIndex = 1;
    };
    
}

- (void)setSportEnergyCircleGoalNumber:(NSInteger)goalNumber currentNumber:(NSInteger)currentNumber {
    _expendNumber = currentNumber;
    __weak typeof(self) weakSelf = self;
    
    if (goalNumber == 0 && _expendNumber == 0) {
        _sportEnergyCircle.style = XKRWEnergyCircleStylePerfect;
        [_sportEnergyCircle setOpenedViewTiltle:@"无需运动" currentNumber:[NSString stringWithFormat:@"%d",(int)currentNumber] goalNumber:goalNumber unit:@"kcal" isBehaveCurrect:YES];
        
    } else {
        BOOL isBehaveCurrect = NO;
        if (currentNumber >= goalNumber) {
            isBehaveCurrect = YES;
        } else {
            isBehaveCurrect = NO;
        }
        [_sportEnergyCircle setOpenedViewTiltle:@"已消耗" currentNumber:[NSString stringWithFormat:@"%d",(int)currentNumber] goalNumber:goalNumber unit:@"kcal" isBehaveCurrect:isBehaveCurrect];
    }
    
    _sportEnergyCircle.energyCircleViewClickBlock = ^(NSInteger index){
        
        [weakSelf resetCirclesStyle:index];
        
        [weakSelf runSportEnergyCircleWithNewCurrentNumber:weakSelf.expendNumber];
        
        if ([weakSelf.delegate respondsToSelector:@selector(energyCircleView:clickedAtIndex:)]) {
            
            [weakSelf.delegate energyCircleView:weakSelf clickedAtIndex:2];
        }
        _selectedIndex = 2;
    };
    
}

- (void)setHabitEnergyCircleGoalNumber:(NSInteger)goalNumber currentNumber:(NSInteger)currentNumber {
    _currectHabitNumber = currentNumber;
    __weak typeof(self) weakSelf = self;
    
    if (goalNumber == 0) {
        [_habitEnergyCircle setOpenedViewTiltle:@"无需改正" currentNumber:[NSString stringWithFormat:@"%d",(int)currentNumber] goalNumber:0 unit:@"个" isBehaveCurrect:YES];
        _habitEnergyCircle.style = XKRWEnergyCircleStylePerfect;
        _habitEnergyCircle.goalLabel.text = @"Perfect";
        _habitEnergyCircle.energyCircleViewClickBlock = ^(NSInteger index){
            [XKRWCui showInformationHudWithText:@"你的习惯很好，无需改正！"];
        };
    } else {
        
        BOOL isBehaveCurrect = NO;
        if (currentNumber == goalNumber) {
            isBehaveCurrect = YES;
        } else {
            isBehaveCurrect = NO;
        }
        [_habitEnergyCircle setOpenedViewTiltle:@"已改正" currentNumber:[NSString stringWithFormat:@"%d",(int)currentNumber] goalNumber:goalNumber unit:@"个" isBehaveCurrect:isBehaveCurrect];
        if (_habitEnergyCircle.style == XKRWEnergyCircleStylePerfect) {
            _habitEnergyCircle.style = XKRWEnergyCircleStyleOpened;
        }
        _habitEnergyCircle.energyCircleViewClickBlock = ^(NSInteger index){
            [weakSelf resetCirclesStyle:index];
            
            [weakSelf runHabitEnergyCircleWithNewCurrentNumber:weakSelf.currectHabitNumber];
            
            if ([weakSelf.delegate respondsToSelector:@selector(energyCircleView:clickedAtIndex:)]) {
                
                [weakSelf.delegate energyCircleView:weakSelf clickedAtIndex:3];
            }
            _selectedIndex = 3;
        };
    }
}

- (void)setTitle:(NSString *)title isflashing:(BOOL)isflashing {
    _remindTextView.text = title;
    if (isflashing) {
        _remindTextView.hidden = NO;
        _titleClickButton.hidden = YES;
        _remindTextView.backColor = [UIColor colorFromHexString:@"c7c7c7"];
        [_remindTextView startFlash];
        
    } else {
        [_remindTextView endFlash];
        _remindTextView.hidden = YES;
        _titleClickButton.hidden = NO;
        [_titleClickButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)titleButtonClicked {
    if ([_delegate respondsToSelector:@selector(energyCircleViewTitleClicked:)]) {
        [_delegate energyCircleViewTitleClicked:_remindTextView.text];
    }
}

#pragma mark -- reset meals、sports and habits' current number
- (void)runEatEnergyCircleWithNewCurrentNumber:(NSInteger)currentNumber {
    
    _intakeNumber = currentNumber;
    
    BOOL abool;
    if (_intakeNumber < leastNum || _intakeNumber > _eatEnergyCircle.goalNumber) {
        abool = NO;
    } else {
        abool = YES;
    }
    
    CGFloat percentage = (currentNumber / (CGFloat)_eatEnergyCircle.goalNumber) > 1 ? 1:(currentNumber / (CGFloat)_eatEnergyCircle.goalNumber);
    [_eatEnergyCircle runToCurrentNum:currentNumber duration:1.5 * percentage isBehaveCurrect:abool];
    [_eatEnergyCircle runProgressCircleWithColor:_eatEnergyCircle.progressCircleColor percentage:percentage duration:1.5 * percentage];
}

- (void)runSportEnergyCircleWithNewCurrentNumber:(NSInteger)currentNumber {
    
    _expendNumber = currentNumber;
    if (_sportEnergyCircle.style == XKRWEnergyCircleStylePerfect && _expendNumber) {
        _sportEnergyCircle.style = XKRWEnergyCircleStyleOpened;
        [_sportEnergyCircle setOpenedViewTiltle:@"已消耗" currentNumber:[NSString stringWithFormat:@"%d",(int)currentNumber] goalNumber:0 unit:@"kcal" isBehaveCurrect:YES];
    }
    
    CGFloat percentage;
    if (_sportEnergyCircle.goalNumber) {
        percentage = (currentNumber / (CGFloat)_sportEnergyCircle.goalNumber) > 1 ? 1:(currentNumber / (CGFloat)_sportEnergyCircle.goalNumber);
    } else {
        percentage = 1;
    }
    
    [_sportEnergyCircle runToCurrentNum:currentNumber duration:1.5 * percentage isBehaveCurrect:(percentage < 1 ? NO : YES)];
    [_sportEnergyCircle runProgressCircleWithColor:_sportEnergyCircle.progressCircleColor percentage:percentage duration:1.5 * percentage];
}

- (void)runHabitEnergyCircleWithNewCurrentNumber:(NSInteger)currentNumber {
    
    _currectHabitNumber = currentNumber;
    CGFloat percentage = (currentNumber / (CGFloat)_habitEnergyCircle.goalNumber) > 1 ? 1:(currentNumber / (CGFloat)_habitEnergyCircle.goalNumber);
    [_habitEnergyCircle runToNextNumber:currentNumber duration:1.5 * percentage resetIsBehaveCurrect: (percentage == 1)];
    [_habitEnergyCircle runProgressCircleWithColor:_habitEnergyCircle.progressCircleColor percentage:percentage duration:1.5 * percentage];
    //    [_habitEnergyCircle runToCurrentNum:currentNumber duration:1.5 * percentage];
}

- (void)resetCirclesStyle:(NSInteger)currentIndex {
    
    
    if ((_exClickedIndex != 1 && _exClickedIndex != 2 && _exClickedIndex != 3) || _exClickedIndex == currentIndex) {
        _exClickedIndex = currentIndex;
        return;
    }
    
    XKRWEnergyCircleView *circle = (XKRWEnergyCircleView *)[self viewWithTag:_exClickedIndex];
    
    if (circle && circle.style != XKRWEnergyCircleStylePerfect) {
        circle.style = XKRWEnergyCircleStyleOpened;
    }
    
    _exClickedIndex = currentIndex;
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
