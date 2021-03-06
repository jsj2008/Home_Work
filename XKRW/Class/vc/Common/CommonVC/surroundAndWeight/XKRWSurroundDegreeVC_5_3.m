//
//  XKRWSurroundDegreeVC_5_3.m
//  XKRW
//
//  Created by 忘、 on 16/4/14.
//  Copyright © 2016年 XiKang. All rights reserved.
//

#import "XKRWSurroundDegreeVC_5_3.h"
#import "XKRWRecordService4_0.h"
#import "XKRWAlgolHelper.h"

#define kDaySeconds 86400
#define LABELHEIGHT  30
#define CELLWIDTH    64
#define FatStandardValue 18

@interface XKRWSurroundDegreeVC_5_3 () <UITableViewDelegate ,UITableViewDataSource>{
    UIView *customView;
    UITableView *surroundTableView;
    UIButton *currentSelectBuuton;
    NSMutableArray *tempArray;
    NSString *maxValue;     //最大值
    NSString *minValue;     //最小值
    UILabel *promptLabel;   //提示Label
    
    CGFloat showHeight ;
    CGFloat showWidth;
    UILabel *standardFatLabel;
}

@end

@implementation XKRWSurroundDegreeVC_5_3

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIView *view = [[UIView alloc] init];;
    CGRect frame = CGRectMake(XKAppWidth-100, XKAppHeight - 110, 50, 50);
    view.frame = frame;
    view.layer.cornerRadius = 25;
    view.backgroundColor = [UIColor colorFromHexString:@"#c8c8c8"];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(0, 10, view.frame.size.width, 15);
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"BMI";
    [view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(0, label1.frame.origin.y + label1.frame.size.height, view.frame.size.width, 15);
    label2.font = [UIFont systemFontOfSize:10];
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    float BMI = [XKRWAlgolHelper BMI];
    label2.text = [NSString stringWithFormat:@"%.1f",BMI];
    [view addSubview:label2];
    
//    CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI *.5);
//    [view setTransform:transform];
    [self.view addSubview:view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
//    if (IOS_9_OR_LATER) {
//        showHeight = XKAppHeight;
//        showWidth = XKAppWidth;
//    }else{
        showHeight = XKAppWidth;
        showWidth = XKAppHeight;
//    }
    [self initData];
    [self initView];
    [self AdjustSurroundTableViewUI];
}

#pragma --mark UI
- (void) initView {
    customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, XKAppWidth)];
    customView.backgroundColor = [UIColor whiteColor];
    UIView *rightLine  = [[UIView alloc]initWithFrame:CGRectMake(63, 0, 0.5, XKAppWidth)];
    rightLine.backgroundColor = XK_ASSIST_LINE_COLOR;
    [customView addSubview:rightLine];
    
    [XKRWUtil addViewUpLineAndDownLine:customView andUpLineHidden:YES DownLineHidden:NO];
    [self.view addSubview:customView];
    UIButton *popButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    popButton.frame = CGRectMake(0, 0, 64, 64);
    [popButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [popButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [popButton setBackgroundImage:[UIImage imageNamed:@"back_p"] forState:UIControlStateHighlighted];
    [customView addSubview:popButton];
    
    NSArray *array = @[@"体重",@"体脂率",@"胸围",@"臂围",@"腰围",@"臀围",@"大腿围",@"小腿围"];
    
    for (NSInteger i = 0; i <[array count] ; i++) {
        UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        typeButton.tag = 1000 + i;
        typeButton.titleLabel.font = XKDefaultFontWithSize(14);
        [typeButton setTitle: [array objectAtIndex:i] forState:UIControlStateNormal];
        [typeButton setTitleColor:colorSecondary_666666 forState:UIControlStateNormal];
        [typeButton setTitleColor:XKMainSchemeColor forState:UIControlStateHighlighted];
        [typeButton setTitleColor:XKMainSchemeColor forState:UIControlStateSelected];
        [typeButton addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
        
        typeButton.frame = CGRectMake(0, 50 + i*(XKAppWidth - 50*2)/([array count]-1), 64, (XKAppWidth - 50*2)/([array count]-1) );
        [customView addSubview:typeButton];
        if(i == 0) {
            typeButton.selected = YES;
            currentSelectBuuton = typeButton;
        }
    }
    
    surroundTableView = [[UITableView alloc] initWithFrame:CGRectMake((XKAppHeight -64 - XKAppWidth) /2 + 64, -(XKAppHeight -64 - XKAppWidth) /2, XKAppWidth, XKAppHeight- 64) style:UITableViewStylePlain];
    surroundTableView.delegate = self;
    surroundTableView .dataSource = self ;
    surroundTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    surroundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    surroundTableView.showsHorizontalScrollIndicator = NO;

    surroundTableView.showsVerticalScrollIndicator = NO;
    XKLog(@"%@",surroundTableView);
    [self.view addSubview:surroundTableView];

    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake((surroundTableView.height -200)/2, (surroundTableView.width -20)/2, 200, 20)];
    promptLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.textColor = colorSecondary_666666;
    promptLabel.text = @"还没有记录数据哦!";
    promptLabel.font = XKDefaultFontWithSize(14.f);
    promptLabel.hidden  = YES;
    [surroundTableView addSubview:promptLabel];

}

/**
 *  调整UI
 */
- (void)AdjustSurroundTableViewUI {
    if (tempArray.count == 0) {
        promptLabel.hidden = NO;
    }else{
        promptLabel.hidden = YES;
    }
    if (tempArray.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tempArray.count - 1 inSection:0];
        [surroundTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    }
 }

#pragma --mark Data
- (void) initData {
    NSDictionary *dic = [[XKRWRecordService4_0 sharedService] getAllCircumferenceAndWeightRecord];
    if (_dataType == eWeightType) {
        tempArray = [[dic objectForKey:@"weight"] objectForKey:@"content"];
    }else if(_dataType == efatType ){
        tempArray = [[dic objectForKey:@"fat"] objectForKey:@"content"];
    }else if(_dataType == eBustType ){
        tempArray = [[dic objectForKey:@"bust"] objectForKey:@"content"];
    }else if (_dataType == eArmType){
        tempArray = [[dic objectForKey:@"arm"] objectForKey:@"content"];
    }else if (_dataType == eThighType){
        tempArray = [[dic objectForKey:@"thigh"] objectForKey:@"content"];
    }else if(_dataType ==eWaistType ){
        tempArray = [[dic objectForKey:@"waistline"] objectForKey:@"content"];
    }else if (_dataType ==eHipType){
        tempArray = [[dic objectForKey:@"hipline"] objectForKey:@"content"];
    }else{
        tempArray = [[dic objectForKey:@"shank"] objectForKey:@"content"];
    }
    
    if ([tempArray count] == 0) {
        maxValue = minValue ;
    }else{
        NSArray * orderlyArray = [self dateSortFromMinToMax:[NSMutableArray arrayWithArray:tempArray]];
        maxValue = [[orderlyArray lastObject] objectForKey:@"value"];
        minValue = [[orderlyArray firstObject] objectForKey:@"value"];
    }
    
    if (_dataType == efatType) {
        float min = 0;
        float max = 10 * ceilf(maxValue.floatValue/10);
        if (min > FatStandardValue) {
            min = 10 * floorf(minValue.floatValue/10) - 10;
        }
        if (max < FatStandardValue) {
            max = 10 * ceilf(maxValue.floatValue/10) + 10;
        }
        minValue = [NSString stringWithFormat:@"%.0f",min];
        maxValue = [NSString stringWithFormat:@"%.0f",max];
    }
    
    [surroundTableView reloadData];
    
}


#pragma  --mark Action
- (void)popAction {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)changeType:(UIButton *)button {
    currentSelectBuuton.selected = NO;
    button.selected = YES;
    currentSelectBuuton = button;
    standardFatLabel.hidden = true;
    switch (button.tag) {
        case 1000:
            _dataType = eWeightType;
            break;
        case 1001:
            _dataType = efatType;
            break;
        case 1002:
            _dataType = eBustType;
            break;
        case 1003:
            _dataType = eArmType;
            break;
        case 1004:
            _dataType = eWaistType;
            break;
        case 1005:
            _dataType = eHipType;
            break;
        case 1006:
            _dataType = eThighType;
            break;
        case 1007:
            _dataType = ecalfType;
            break;
        default:
            break;
    }
    
    [self initData];
    
   
    [self AdjustSurroundTableViewUI];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma --mark Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tempArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"check";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.transform = CGAffineTransformMakeRotation(M_PI_2);
        UILabel * dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 64, LABELHEIGHT)];
        dateLabel.tag = 100;
        
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.font = XKDefaultFontWithSize(14.f);
        dateLabel.textColor = colorSecondary_666666;
        dateLabel.backgroundColor = [UIColor whiteColor];
        
        [cell.contentView addSubview:dateLabel];
     
        UILabel * dataLabel ;
     
        dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, showHeight - LABELHEIGHT, 64, LABELHEIGHT)];
        
        
        dataLabel.tag = 101;
        dataLabel.textAlignment = NSTextAlignmentCenter;
        dataLabel.font = XKDefaultFontWithSize(14.f);
        dataLabel.textColor = XKMainToneColor_29ccb1;
        dataLabel.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:dataLabel];
    }
    
    UILabel *dateLabel  = (UILabel *)[cell viewWithTag:100];

    NSLog(@"%@",[[tempArray objectAtIndex:indexPath.row] objectForKey:@"date"]);
    NSString *showDate = [XKRWUtil dateFormateWithDate:[[tempArray objectAtIndex:indexPath.row] objectForKey:@"date"] format:@"MM-dd"];
    dateLabel.text = [NSString stringWithFormat:@"%@",showDate];
    
    UILabel *dataLabel = (UILabel *)[cell viewWithTag:101];
    if (_dataType == eWeightType) {
        dataLabel.text = [NSString stringWithFormat:@"%@kg",[[tempArray objectAtIndex:indexPath.row] objectForKey:@"value"]];
    }else if (_dataType == efatType) {
        dataLabel.text = [NSString stringWithFormat:@"%@%%",[[tempArray objectAtIndex:indexPath.row] objectForKey:@"value"]];
    }else {
        dataLabel.text = [NSString stringWithFormat:@"%@cm",[[tempArray objectAtIndex:indexPath.row] objectForKey:@"value"]];
    }
    
    NSString *currentValue = [[tempArray objectAtIndex:indexPath.row] objectForKey:@"value"];
    
    [self drawImageViewInCell:currentValue And:indexPath andCell:cell];
    
    if (indexPath.row%2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorFromHexString:@"#F9F9F9"];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    return cell;

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

#pragma --mark 横屏
- (BOOL)shouldAutorotate
{
    //是否支持转屏
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //支持哪些转屏方向
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

#pragma --mark Util
//数组进行排序  找出最大以及最小值
- (NSMutableArray *)dateSortFromMinToMax:(NSMutableArray *)array
{
    for (int i =0; i < array.count-1; i++) {
        for (int j =i+1; j< array.count; j++) {
            if([[[array objectAtIndex:i] objectForKey:@"value"] floatValue] > [[[array objectAtIndex:j] objectForKey:@"value"] floatValue])
            {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return array;
}


#pragma --mark drawAction
- (void)drawImageViewInCell:(NSString *)currentValue And:(NSIndexPath *) indexPath andCell:(UITableViewCell *)cell
{
    CGPoint prevPoint;
    CGPoint currentPoint;
    CGPoint nextPoint;
    CGFloat fatValue = 18;
    CGPoint fatStartPoint;
    CGPoint fatEndPoint;
    NSString *nextValue;
    NSString *prevValue;
    UIImageView *imageView = [[UIImageView alloc]init];
    
    imageView.image = [UIImage imageNamed:@"girth_btn_point_mark_640"];
    
    if ((maxValue.floatValue - minValue.floatValue) < 0.000001) {
        currentPoint = CGPointMake((CELLWIDTH)/2 ,LABELHEIGHT + 6 + (showHeight - 2*LABELHEIGHT)/2 );
        fatStartPoint = CGPointMake(0, currentPoint.y);
    }else {
        currentPoint = CGPointMake((CELLWIDTH)/2, (LABELHEIGHT +10) + ((showHeight - 2*(LABELHEIGHT +10)) -((currentValue.floatValue - minValue.floatValue) *(showHeight - 2*(LABELHEIGHT +10) ) /(maxValue.floatValue - minValue.floatValue))));
        fatStartPoint = CGPointMake(0, (LABELHEIGHT +10) + ((showHeight - 2*(LABELHEIGHT +10)) -((fatValue - minValue.floatValue) *(showHeight - 2*(LABELHEIGHT +10) ) /(maxValue.floatValue - minValue.floatValue))));
    }
    
    imageView.frame = CGRectMake(currentPoint.x-12/2, currentPoint.y-12/2, 12, 12);
    
    if (indexPath.row != 0) {
        prevValue = [[tempArray objectAtIndex:indexPath.row -1] objectForKey:@"value"];

        if ((maxValue.floatValue - minValue.floatValue) < 0.000001) {
            prevPoint = CGPointMake(0, LABELHEIGHT + 6 + (showHeight - 2*LABELHEIGHT)/2  );
            fatStartPoint = prevPoint;
        }else{
            prevPoint = CGPointMake(0, (LABELHEIGHT +10) + ((showHeight - 2*(LABELHEIGHT +10)) -( (prevValue.floatValue +(currentValue.floatValue -prevValue.floatValue)/2  - minValue.floatValue) *(showHeight - 2*(LABELHEIGHT +10) ) /(maxValue.floatValue - minValue.floatValue)) ));
            fatStartPoint = CGPointMake(0, (LABELHEIGHT +10) + ((showHeight - 2*(LABELHEIGHT +10)) -((fatValue - minValue.floatValue) *(showHeight - 2*(LABELHEIGHT +10) ) /(maxValue.floatValue - minValue.floatValue)) ));
        }
        [self drawLineInView:cell.contentView fromPoint:prevPoint toTargetPoint:currentPoint];
    }
    
    if (tempArray.count > indexPath.row +1) {
        nextValue = [[tempArray objectAtIndex:indexPath.row+1] objectForKey:@"value"];

        if ((maxValue.floatValue - minValue.floatValue) < 0.000001) {
            nextPoint = CGPointMake(CELLWIDTH, LABELHEIGHT + 6 + (showHeight - 2*LABELHEIGHT)/2 );
        }else{
            nextPoint = CGPointMake(CELLWIDTH, (LABELHEIGHT +10) + ((showHeight - 2*(LABELHEIGHT +10)) -( (nextValue.floatValue +(currentValue.floatValue -nextValue.floatValue)/2  - minValue.floatValue) *(showHeight - 2*(LABELHEIGHT +10) ) /(maxValue.floatValue - minValue.floatValue))));
        }
        [self drawLineInView:cell.contentView fromPoint:currentPoint toTargetPoint:nextPoint];
    }
    if (_dataType == efatType) {
        fatEndPoint = CGPointMake(CELLWIDTH , fatStartPoint.y);
        [self drawDottedLineInView:cell.contentView fromPoint:fatStartPoint toTargetPoint:fatEndPoint];
        if (indexPath.row == tempArray.count - 1) {
            CGRect frame = CGRectMake(XKAppWidth - 135, fatEndPoint.y - 30, 120, 20);
            standardFatLabel = [[UILabel alloc] initWithFrame:frame];
            standardFatLabel.text = [NSString stringWithFormat:@"标准体脂率为%.1f%%",fatValue];
            standardFatLabel.textColor = colorSecondary_999999;
            standardFatLabel.font = [UIFont systemFontOfSize:12];
            [self.view addSubview:standardFatLabel];
        }
    }
    [cell.contentView addSubview:imageView];
}


- (void)drawLineInView:(UIView *)view fromPoint:(CGPoint) currentPoint toTargetPoint:(CGPoint) targetPoint
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(currentPoint.x, currentPoint.y)];
    [path addLineToPoint:CGPointMake(targetPoint.x, targetPoint.y)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = view.bounds;
    pathLayer.bounds = view.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = XKMainToneColor_29ccb1.CGColor;//粗线的颜色
    
    pathLayer.lineWidth = 1;
    
    pathLayer.lineJoin = kCALineJoinRound;
    [view.layer addSublayer:pathLayer];
    
}

- (void)drawDottedLineInView:(UIView *)view fromPoint:(CGPoint) currentPoint toTargetPoint:(CGPoint) targetPoint
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:view.bounds];
    [shapeLayer setPosition:view.center];
    [shapeLayer setFillColor:[[UIColor whiteColor] CGColor]];
    [shapeLayer setStrokeColor:[colorSecondary_999999 CGColor]];
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:
    [NSArray arrayWithObjects:[NSNumber numberWithInt:11],
    [NSNumber numberWithInt:5],nil]];

    CGMutablePathRef path    = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, currentPoint.x, currentPoint.y);
    CGPathAddLineToPoint(path, NULL, targetPoint.x, targetPoint.y);
    [shapeLayer setPath:path];
    [[view layer] addSublayer:shapeLayer];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
