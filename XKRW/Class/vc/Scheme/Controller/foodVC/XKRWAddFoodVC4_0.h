//
//  XKRWAddFoodVC4_0.h
//  XKRW
//
//  Created by 忘、 on 14-11-20.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWBaseVC.h"
#import "XKRWFoodEntity.h"
#import "XKRWRecordFoodEntity.h"
#import "XKRWNaviRightBar.h"

#import "XKRWRecordService4_0.h"

@interface XKRWAddFoodVC4_0 : XKRWBaseVC<UITextFieldDelegate>

//食物对象

@property (nonatomic, strong) XKRWRecordFoodEntity *foodRecordEntity;

@property (nonatomic, weak) XKRWRecordEntity4_0 *recordEntity;

@property (nonatomic,strong)XKRWNaviRightBar *rightBar;

@property (nonatomic,assign) BOOL  isFromScheme;

//YES 为新记录   NO为修改
@property (nonatomic) BOOL isRecord;

@property BOOL isPresent;

+ (void)presentAddFoodVC:(XKRWAddFoodVC4_0 *)vc onViewController:(UIViewController *)onvc;

@end
