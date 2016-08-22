//
//  XKRWWeightPopView.m
//  XKRW
//
//  Created by ss on 16/4/7.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#define labelWidth 55.0
#define labelHeight 30.0
#define labelSpace 10.0

#import "XKRWWeightPopView.h"
@implementation XKRWWeightPopView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

-(void)awakeFromNib{
    
}
/**
 *  点击不同的按钮类型不同
 *
 *  @param type 0:记录体重
 *              1:记录围度
 */

- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type withDate:(NSDate *)date
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self = LOAD_VIEW_FROM_BUNDLE(@"XKRWWeightPopView");
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _arrLabels = @[@"体重",@"体脂率",@"胸围",@"臂围",@"腰围",@"臀围",@"大腿围",@"小腿围"];
        _dicIllegal = [NSMutableDictionary dictionary];
        
        _typeScrollView.delegate = self;
        _typeScrollView.bounces = true;
        _typeScrollView.clipsToBounds = true;
        _typeScrollView.showsHorizontalScrollIndicator = false;
        _typeScrollView.contentSize = CGSizeMake(labelWidth *_arrLabels.count + labelSpace *(_arrLabels.count + 2), labelHeight*2);
        _typeScrollView.contentOffset = CGPointMake(labelSpace*(type+1)+labelWidth*type, 0);
        
        for (int i = 0; i < _arrLabels.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(labelSpace*(i+1)+labelWidth*i, labelHeight/2, labelWidth, labelHeight)];
            [btn setTitle:[NSString stringWithFormat:@"%@",_arrLabels[i]] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn addTarget:self action:@selector(tapTypeLabel:) forControlEvents:UIControlEventTouchUpInside];
            if ((i == 0 && type == 0)||(i == 1 && type == 1)) {
                [btn setTitleColor:XKMainToneColor_29ccb1 forState:UIControlStateNormal];
                btn.layer.borderWidth = 1;
                btn.layer.cornerRadius = 5;
                btn.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
            }
            btn.tag = 88888 + i;
            [_typeScrollView addSubview:btn];
        }
        _typePageControl.numberOfPages = _arrLabels.count;
        _typePageControl.currentPage = type;
        
        _recordDates = [[XKRWRecordService4_0 sharedService] getUserRecordDateFromDB];
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, XKAppHeight-200, XKAppWidth, 200)];
        
        _datePicker.backgroundColor = [UIColor whiteColor];
        
        _datePicker.calendar = [NSCalendar currentCalendar];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(calendarSelectedDate:) forControlEvents:UIControlEventValueChanged];
        _datePicker.minimumDate = [self getRegisterDate];
        _datePicker.maximumDate = [NSDate today];
        
        for (UIView *view in _datePicker.subviews) {
            if ([view isKindOfClass:[UIPickerView class]]) {
                UIPickerView *pickView = (UIPickerView *)view;
                pickView.transform =CGAffineTransformMakeScale(1.35, 1.2);
            }
        }
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapdateLabel)];
        _dateLabel.userInteractionEnabled = YES;
        [_dateLabel addGestureRecognizer:tapgesture];
        
        _datePicker.date = date;
        [[UIApplication sharedApplication].keyWindow addSubview:_datePicker];
        _datePicker.alpha = 0;
        
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
        _dicAll = tmpDic;
        
        _textField.delegate = self;
        [self reloadReocrdOfDay:date];
        _currentIndex = [NSNumber numberWithInteger:_typePageControl.currentPage];
    }
    return self;
}

-(NSDate *)getRegisterDate{
    NSString *registerDateStr = [[XKRWUserService sharedService] getREGDate];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc ]init];
    formatter1.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    formatter1.dateFormat = @"yyyy-MM-dd";
    NSDate *registerDate  = [formatter1 dateFromString:registerDateStr];
    return registerDate;
}

-(void)setCurrentIndex:(NSNumber *)currentIndex{
    if (_currentIndex != currentIndex) {
        UIButton *btn = [_typeScrollView viewWithTag:88888 + _currentIndex.integerValue];
        btn.layer.borderWidth = 0;
        btn.layer.borderColor = [UIColor clearColor].CGColor;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _currentIndex = currentIndex;
    }
    if (_currentIndex.integerValue == 0) {
        _recordType = XKRWRecordTypeWeight;
    }else if (_currentIndex.integerValue == 1) {
        _recordType = XKRWRecordTypefat;
    }else{
        _recordType = XKRWRecordTypeCircumference;
    }
    [self showCurrentText];
}

-(void)setSelectedDate:(NSDate *)selectedDate{
    if (_selectedDate != selectedDate) {
        _selectedDate = selectedDate;
        _selectDateStr =[selectedDate stringWithFormat:@"yyyy-MM-dd"];
        _dateLabel.text = [selectedDate stringWithFormat:@"MM月dd日"];
    }
}

-(void)setSchemeReocrds:(XKRWRecordSchemeEntity *)schemeReocrds{
    if (!_schemeReocrds) {
        _schemeReocrds = [[XKRWRecordSchemeEntity alloc] init];
    }
    if (_schemeReocrds != schemeReocrds) {
        _schemeReocrds = schemeReocrds;
    }
}

-(void)setOldRecord:(XKRWRecordEntity4_0 *)oldRecord{
    if (_oldRecord != oldRecord) {
        _oldRecord = oldRecord;
    }
    [self makeEntityConvertToDicall];
    [self showCurrentText];
}

-(void)makeEntityConvertToDicall{
    NSMutableDictionary *dayDiction = [NSMutableDictionary dictionary];
    
    [dayDiction setObject:[NSNumber numberWithFloat: _oldRecord.weight] forKey:_arrLabels[0]];
    [dayDiction setObject:[NSNumber numberWithFloat: _oldRecord.fatPercent] forKey:_arrLabels[1]];
    [dayDiction setObject:[NSNumber numberWithFloat: _oldRecord.circumference.bust ] forKey:_arrLabels[2]];
    [dayDiction setObject:[NSNumber numberWithFloat: _oldRecord.circumference.arm ] forKey:_arrLabels[3]];
    [dayDiction setObject:[NSNumber numberWithFloat: _oldRecord.circumference.waistline ] forKey:_arrLabels[4]];
    [dayDiction setObject:[NSNumber numberWithFloat: _oldRecord.circumference.hipline ] forKey:_arrLabels[5]];
    [dayDiction setObject:[NSNumber numberWithFloat: _oldRecord.circumference.thigh ] forKey:_arrLabels[6]];
    [dayDiction setObject:[NSNumber numberWithFloat: _oldRecord.circumference.shank ] forKey:_arrLabels[7]];
    
    [_dicAll setObject:dayDiction forKey:_selectDateStr];
}

#pragma -mark calender module & Delegate method
-(void)tapdateLabel{
    [self showCalendar:!_isCalendarShown];
}

-(void)removeCalendar{
    [self showCalendar:false];
}

- (void)calendarSelectedDate:(UIDatePicker *)datePicker{
    if ([self checkSelectedDate:datePicker.date]) {
        [self reloadReocrdOfDay:datePicker.date];
    }
//    [self showCalendar:NO];
}

-(void)showCalendar:(BOOL)isShowCalendar{
    _isCalendarShown = isShowCalendar;
    if (isShowCalendar) {
        [MobClick event:@"clk_calendar"];
         [_textField resignFirstResponder];
        [UIView animateWithDuration:.3 animations:^{
            _datePicker.alpha = 1;
        }];
    }else{
         [_textField becomeFirstResponder];
        [UIView animateWithDuration:.1 animations:^{
            _datePicker.alpha = 0;
        }];
    }
}

-(BOOL)checkSelectedDate:(NSDate *)date{
    if ([date originTimeOfADay] > [[NSDate date] originTimeOfADay]) {
        [XKRWCui showInformationHudWithText:@"不能查看今天以后的日期哦~"];
        return false;
    }
    
    NSTimeInterval regDateInterval = [[NSDate dateFromString:[[XKRWUserService sharedService] getREGDate] withFormat:@"yyyy-MM-dd"] timeIntervalSince1970];
    
    if ([date originTimeOfADay] < regDateInterval) {
        
//        [self.calendar outerSetSelectedDate:self.selectedDate andNeedReload:false];
         [_datePicker setDate:_selectedDate animated:YES];
        
        [XKRWCui showInformationHudWithText:@"不能查看注册以前的日期哦~"];
        return false;
    }
    return true;
}

-(void)reloadReocrdOfDay:(NSDate *)date{
    self.selectedDate = date;
    [XKTaskDispatcher downloadWithTaskID:@"getAllRecord" task:^{
        self.schemeReocrds = (XKRWRecordSchemeEntity *)[[XKRWRecordService4_0 sharedService] getSchemeRecordWithDate:self.selectedDate];
        self.oldRecord = (XKRWRecordEntity4_0 *)[[XKRWRecordService4_0 sharedService] getAllRecordOfDay:self.selectedDate];
    }];
}

- (IBAction)actBefore:(id)sender {
    if (_selectedDate) {
        NSDate *dateBefore = [_selectedDate offsetDay:-1];
        if ([self checkSelectedDate:dateBefore]) {
            [_textField resignFirstResponder];
            [self reloadReocrdOfDay:dateBefore];
//            [_calendar outerSetSelectedDate:_selectedDate andNeedReload:true];
             [_datePicker setDate:_selectedDate animated:YES];
            [self showCurrentText];
        }
    }
}

- (IBAction)actLater:(id)sender {
    if (_selectedDate) {
        NSDate *dateAfter = [_selectedDate offsetDay:1];
        if ([self checkSelectedDate:dateAfter]) {
            [_textField resignFirstResponder];
            [self reloadReocrdOfDay:dateAfter];
//            [_calendar outerSetSelectedDate:_selectedDate andNeedReload:true];
            [_datePicker setDate:_selectedDate animated:YES];
            [self showCurrentText];
        }
    }
}

-(void)showCurrentText{
    CGFloat str = [_dicAll[_selectDateStr][[self getCurrentType:_currentIndex]] floatValue];
    NSString *txt = str == 0 ? @"" : [NSString stringWithFormat:@"%.01f",str];
    _textField.text = txt;
    UIButton *btn = [(UIButton *)_typeScrollView viewWithTag:88888 + self.currentIndex.integerValue];
    [btn setTitleColor:XKMainToneColor_29ccb1 forState:UIControlStateNormal];
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 5;
    btn.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
    [_typeScrollView setContentOffset:CGPointMake(btn.frame.size.width -_typeScrollView.frame.size.width/2, 0) animated:true];
    
    if ([btn.titleLabel.text isEqualToString:@"体重"])
    {
        _labInput.text = @"kg";
    }
    else if ([btn.titleLabel.text isEqualToString:@"体脂率"])
    {
        _labInput.text = @"%";
    }
    else{
        _labInput.text = @"cm";
    }
}

-(NSString *)getCurrentType:(NSNumber *)indexNum{
    NSString *type = [NSString stringWithFormat:@"%@",[_arrLabels objectAtIndex:[indexNum integerValue]]];
    return type;
}

#pragma -mark carousel module & Delegate method
-(void)saveTheData{
    NSMutableDictionary *dic = [_dicAll objectForKey:_selectDateStr];
    NSMutableDictionary *dayDiction = [NSMutableDictionary dictionary];
    if (dic) {
        dayDiction = dic;
    }
    
    [dayDiction setObject:_textField.text forKey:[self getCurrentType:_currentIndex]];
    [_dicAll setObject:dayDiction forKey:_selectDateStr];
}

//EffectFoodAndSportCircle
-(void)saveRemote{
    _oldRecord.circumference.uid = (int)[XKRWUserDefaultService getCurrentUserId];
    NSDictionary *dic = [_dicAll objectForKey:_selectDateStr];
    
    _oldRecord.weight =[dic[_arrLabels[0]] floatValue];
    _oldRecord.fatPercent =[dic[_arrLabels[1]] floatValue];
    _oldRecord.circumference.bust = [dic[_arrLabels[2]] floatValue];
    _oldRecord.circumference.arm = [dic[_arrLabels[3]] floatValue];
    _oldRecord.circumference.waistline = [dic[_arrLabels[4]] floatValue];
    _oldRecord.circumference.hipline = [dic[_arrLabels[5]] floatValue];
    _oldRecord.circumference.thigh = [dic[_arrLabels[6]] floatValue];
    _oldRecord.circumference.shank = [dic[_arrLabels[7]]floatValue];
    
    _oldRecord.circumference.date = _selectedDate;
    _oldRecord.date = _selectedDate;
    
    if (_currentIndex.integerValue == 0) {
        _recordType = XKRWRecordTypeWeight;
    }else if (_currentIndex.integerValue == 1) {
        _recordType = XKRWRecordTypefat;
    }else{
        _recordType = XKRWRecordTypeCircumference;
    }
    
    if ([self.delegate respondsToSelector:@selector(saveSurroundDegreeOrWeightDataToServer:andEntity:)]) {
        [self.delegate saveSurroundDegreeOrWeightDataToServer:_recordType andEntity:_oldRecord];
    }
    
//    [[XKRWRecordService4_0 sharedService] saveRecord:_oldRecord ofType:XKRWRecordTypeCircumference];
//    [[XKRWRecordService4_0 sharedService] saveRecord:_oldRecord ofType:XKRWRecordTypeWeight];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self showCalendar:NO];
    if (_typePageControl.currentPage != [_currentIndex integerValue]) {
        [self saveTheData];
        _currentIndex = [NSNumber numberWithInteger:_typePageControl.currentPage];
        [self showCurrentText];
    }
}

- (void)tapTypeLabel:(UIButton *)btn{
    NSString *str = btn.titleLabel.text;
    NSInteger index = [_arrLabels indexOfObject:str];
    _typePageControl.currentPage = index;
    if (_typePageControl.currentPage != [_currentIndex integerValue]) {
        [self saveTheData];
        self.currentIndex = [NSNumber numberWithInteger:_typePageControl.currentPage];
        [self showCurrentText];
    }
}

//- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
//    for (UIView *item in carousel.visibleItemViews) {
//        for (UILabel *lab in item.subviews) {

//        }
//    }
//    
//    for (UIView *view in carousel.currentItemView.subviews) {
//        if ([view isKindOfClass:[UILabel class]] ) {
//            UILabel *lab = (UILabel *)view;
//            lab.textColor = XKMainToneColor_29ccb1;
//            lab.layer.borderWidth = 1;
//            lab.layer.cornerRadius = 5;
//            lab.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
//            
//            if ([lab.text isEqualToString:@"体重"])
//            {
//                 _labInput.text = @"kg";
//            }
//            else if ([lab.text isEqualToString:@"体脂率"])
//            {
//                _labInput.text = @"%";
//            }
//            else{
//                _labInput.text = @"cm";
//            }
//        }
//    }
//}

//- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
//{
//    return _arrLabels.count;
//}
//
//- (CGFloat)carouselItemWidth:(iCarousel *)carousel
//{
//    return 55;
//}

//- (UIView *)carousel:(iCarousel *)carousel
//  viewForItemAtIndex:(NSUInteger)index
//         reusingView:(UIImageView *)view
//{
//    if (view == nil) {
//        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
//        view.contentMode = UIViewContentModeScaleToFill; //图片拉伸模式
//        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 26)];
//       
//        lab.text = [NSString stringWithFormat:@"%@",_arrLabels[index]];
//        lab.textAlignment = NSTextAlignmentCenter;
//        
//        if (isInit && index == 0) {
//            lab.textColor = XKMainToneColor_29ccb1;
//            lab.layer.borderWidth = 1;
//            lab.layer.cornerRadius = 5;
//            lab.layer.borderColor = XKMainToneColor_29ccb1.CGColor;
//            isInit = NO;
//        }
//        [view addSubview:lab];
//    }
//    return view;
//}

//- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
//{
//    //customize carousel display
//    switch (option)
//    {
//        case iCarouselOptionWrap:
//        {
//            return NO;
//        }
//        case iCarouselOptionSpacing:
//        {
//            //add a bit of spacing between the item views
//            return value * 1.10f;
//        }
//        case iCarouselOptionFadeMax:
//        {
//            if (_carousel.type == iCarouselTypeCustom)
//            {
//                //set opacity based on distance from camera
//                return 1.3f;
//            }
//            return value;
//        }
//        case iCarouselOptionFadeMin:
//        {
//            if (_carousel.type == iCarouselTypeCustom)
//            {
//                //set opacity based on distance from camera
//                return -1.3f;
//            }
//            return value;
//        }
//        default:
//        {
//            return value;
//        }
//    }
//}

#pragma -mark textfiled delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return true;
    }
    
    if ([self isTopest:[_arrLabels objectAtIndex:_currentIndex.integerValue] withText:textField.text]){
        return false;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newString isEqualToString:@"00"] && [string isEqualToString:@"0"]) {
        return false;
    }
    
    BOOL res = true;
    if (![self judgeTypeTopLegal:[_arrLabels objectAtIndex:_currentIndex.integerValue] withText:newString]) {
        [self showInfoText:_currentIndex.integerValue];
        res = false;
    }
    return res;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    BOOL res = true;
    if (![self judgeTypeLowLegal:[_arrLabels objectAtIndex:_currentIndex.integerValue] withText:textField.text]) {
        [self showInfoText:_currentIndex.integerValue];
        res = false;
    }
    return res;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self saveTheData];
}

#pragma -mark sure btn & cancle btn
- (IBAction)pressCancle:(id)sender {
    [_datePicker removeFromSuperview];
    _datePicker = nil;
    [_textField resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(pressPopViewCancle)]) {
        [self.delegate pressPopViewCancle];
    }
}
/*** 用户达到目标体重*/
- (void)userReachTargetWeight{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"已达成目标体重" message:@"已达成目标体重，是否重新制定计划？" delegate:self cancelButtonTitle:@"没有，记录错了"  otherButtonTitles:@"是的，去重新制定", nil];
    
    alertView.tag = 10001;
    [alertView show];
}

#pragma --mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10001){
        if (buttonIndex == 1) {
            if(![XKUtil isNetWorkAvailable])
            {
                [XKRWCui showInformationHudWithText:@"网络未连接,请检查网络"];
                
                return;
            }
            [MobClick event:@"clk_reset"];
            
            if ([self.delegate respondsToSelector:@selector(resetWeightPlan)]) {
                [self.delegate resetWeightPlan];
            }
        }else{
            [MobClick event:@"clk_NoRest"];
        }
    }
}

- (IBAction)pressSure:(id)sender {
    [self saveTheData];
    if ([self saveDataislegal]) {
        float target_weight = [[XKRWUserService sharedService] getUserDestiWeight]/1000.0;
        float record_weight = [[[_dicAll objectForKey:_selectDateStr] objectForKey:@"体重"] floatValue];
        BOOL weightIsLegal = [self judgeWeightisLegal:record_weight];
        
        if (record_weight <= target_weight && weightIsLegal) {
            [self userReachTargetWeight];
        }else{
            CGFloat weight = [[XKRWWeightService shareService] getNearestWeightRecordOfDate:_selectedDate];
            [_datePicker removeFromSuperview];
            _datePicker = nil;
            [_textField resignFirstResponder];
            [self saveRemote];
            
            if ([self.delegate respondsToSelector:@selector(pressPopViewSure:date:)]){
                [self.delegate pressPopViewSure:weight date:_selectedDate];
            }
        }
    }else{
        NSArray *keys = [_dicIllegal allKeys];
        NSNumber *index = [keys firstObject];
        _typePageControl.currentPage = index.integerValue;
        _currentIndex = index;
        [self showInfoText:index.integerValue];
    }
}

-(BOOL)saveDataislegal{
    int j = 0;
    [_dicIllegal removeAllObjects];
    NSDictionary *dic = [_dicAll objectForKey:_selectDateStr] ;
    
    for (NSString *type in _arrLabels) {
        if (![self judgeTypeTopLegal:type withText:[dic objectForKey:type]] || ![self judgeTypeLowLegal:type withText:[dic objectForKey:type]]) {
            j++;
        }
    }
    return !(j > 0);
}

-(BOOL)judgeWeightisLegal:(CGFloat)weight{
    BOOL res = true;
    if (weight > 200 || weight < 20) {
        res = false;
    }
    return res;
}

-(BOOL)judgeTypeTopLegal:(NSString *)type withText:(NSString *)text{
    BOOL res = true;
    CGFloat num = [text floatValue];
    int limit;
    if ([type isEqualToString:@"体重"]) {
        if (num > 200) {
            limit = 200;
            res = false;
        }
    }
    if ([type isEqualToString:@"体脂率"]) {
        if (num > 100) {
            limit = 100;
            res = false;
        }
    }
    if ([type isEqualToString:@"胸围"] || [type isEqualToString:@"腰围"] || [type isEqualToString:@"臀围"] || [type isEqualToString:@"大腿围"]) {
        if (num > 150) {
            limit = 150;
            res = false;
        }
    }
    if ([type isEqualToString:@"臂围"] || [type isEqualToString:@"小腿围"]) {
        if (num > 100) {
            limit = 100;
            res = false;
        }
    }
    if (!res) {
        [_dicIllegal removeObjectForKey:[NSNumber numberWithInteger:[_arrLabels indexOfObject:type]]];
        [_dicIllegal setObject:[NSString stringWithFormat:@"%@值最大不能大于%d",type,limit] forKey:[NSNumber numberWithInteger:[_arrLabels indexOfObject:type]]];
    }
    return res;
}

-(BOOL)judgeTypeLowLegal:(NSString *)type withText:(NSString *)text{
    BOOL res = true;
    CGFloat num = [text floatValue];
    int limit;
    
    if ([type isEqualToString:@"体重"]) {
        if (num != 0 && num < 20) {
            limit = 20;
            res = false;
        }
    }
    if ([type isEqualToString:@"体脂率"]) {
        if (num != 0 && num < 0) {
            limit = 0;
            res = false;
        }
    }
    if ([type isEqualToString:@"胸围"] || [type isEqualToString:@"腰围"] || [type isEqualToString:@"臀围"]) {
        if (num != 0 && num < 50) {
            limit = 50;
            res = false;
        }
    }
    if ([type isEqualToString:@"臂围"] || [type isEqualToString:@"小腿围"]) {
        if (num != 0 && num < 15) {
            limit = 15;
            res = false;
        }
    }
    if ([type isEqualToString:@"大腿围"]) {
        if (num != 0 && num < 30) {
            limit = 30;
            res = false;
        }
    }
    if (!res) {
        [_dicIllegal setObject:[NSString stringWithFormat:@"%@值最小不能小于%d",type,limit] forKey:[NSNumber numberWithInteger:[_arrLabels indexOfObject:type]]];
    }
    return res;
}

-(void)showInfoText:(NSInteger)index{
    [XKRWCui showInformationHudWithText:[_dicIllegal objectForKey:[NSNumber numberWithInteger:index]]];
}

-(BOOL)isTopest:(NSString *)type withText:(NSString *)text{
    BOOL res = false;
    int limit;
    CGFloat num = [text floatValue];
    if ([type isEqualToString:@"体重"]) {
        if (num == 200) {
            limit = 200;
            res = true;
        }
    }
    if ([type isEqualToString:@"体脂率"]) {
        if (num == 100) {
            limit = 100;
            res = true;
        }
    }
    if ([type isEqualToString:@"胸围"] || [type isEqualToString:@"腰围"] || [type isEqualToString:@"臀围"] || [type isEqualToString:@"大腿围"]) {
        if (num == 150) {
            limit = 150;
            res = true;
        }
    }
    if ([type isEqualToString:@"臂围"] || [type isEqualToString:@"小腿围"]) {
        if (num == 100) {
            limit = 100;
            res = true;
        }
    }
    if (res) {
        [XKRWCui showInformationHudWithText:[NSString stringWithFormat:@"%@值最大不能大于%d",type,limit]];
    }
    return  res;
}
@end