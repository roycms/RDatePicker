//
//  RDatePicker.m
//  RDatePicker
//
//  Created by roycms on 2017/2/8.
//  Copyright © 2017年 杜耀辉. All rights reserved.
//

#import "RDatePicker.h"

@interface RDatePicker () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong)UIPickerView *pickerView;
//日期存储数组
@property (nonatomic,strong)NSMutableArray *yearArray;
@property (nonatomic,strong)NSMutableArray *monthArray;
@property (nonatomic,strong)NSMutableArray *dayArray;
@property (nonatomic,strong)NSMutableArray *hourArray;
@property (nonatomic,strong)NSMutableArray *minuteArray;
//记录位置
@property (nonatomic,assign)NSInteger yearIndex;
@property (nonatomic,assign)NSInteger monthIndex;
@property (nonatomic,assign)NSInteger dayIndex;
@property (nonatomic,assign)NSInteger hourIndex;
@property (nonatomic,assign)NSInteger minuteIndex;
@end

#define DATEPICKER_MAXDATE 2050
#define DATEPICKER_MINDATE 2010
#define MainScreenWidth  ([UIScreen mainScreen].bounds.size.width)

@implementation RDatePicker

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.pickerView];
        self.pickerView.frame = CGRectMake(0, 0,MainScreenWidth, 260);
        [self createDataSource]; //初始化数据
        [self setNowDate]; //设置默认选中是当前的时间
    }
    return self;
}

//创建数据源
- (void)createDataSource
{
    self.yearArray = [NSMutableArray array];
    self.monthArray = [NSMutableArray array];
    self.dayArray = [NSMutableArray array];
    self.hourArray = [NSMutableArray array];
    self.minuteArray = [NSMutableArray array];
    
    //进行数组的赋值
    for (int i= 0 ; i<60; i++)
    {
        if (i<32){
            if (i<24) {
                if (i<12) {
                    [self.monthArray addObject:[NSString stringWithFormat:@"%d月",i+1]];
                }
                [self.hourArray addObject:[NSString stringWithFormat:@"%02d时",i]];
            }
            [self.dayArray addObject:[NSString stringWithFormat:@"%02d日",i]];
        }
        [self.minuteArray addObject:[NSString stringWithFormat:@"%02d分",i]];
    }
    for (int i = DATEPICKER_MINDATE; i<=DATEPICKER_MAXDATE; i++) {
        [self.yearArray addObject:[NSString stringWithFormat:@"%d年",i]];
    }
}

#pragma mark --- 与DataSource有关的代理方法
//返回列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}

//返回每列里边的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.yearArray.count;
    }
    else if (component == 1){
        return self.monthArray.count;
    }
    else if (component == 2){
        return self.dayArray.count;
    }
    else if (component == 3){
        return self.hourArray.count;
    }
    else{
        return self.minuteArray.count;
    }
}
#pragma mark --- 与处理有关的代理方法
//设置组件的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return MainScreenWidth/5 + 20;
    }
    else{
        return MainScreenWidth/5 - 10;
    }
}
//设置组件中每行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
     return 48;
}

//设置组件中每行的标题row:行
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.yearArray[row];
    }
    else if (component == 1){
        return self.monthArray[row];
    }
    else if (component == 2){
        return self.dayArray[row];
    }
    else if (component == 3){
        return self.hourArray[row];
    }
    else{
        return self.minuteArray[row];
    }
}

//选中行的事件处理
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.yearIndex = row;
    }
    else if (component == 1){
        self.monthIndex = row;
    }
    else if (component == 2){
        self.dayIndex = row;
    }
    else if (component == 3){
        self.hourIndex = row;
    }
    else{
        self.minuteIndex = row;
    }
    
    NSLog(@"%ld - %ld - %ld - %ld - %ld",self.yearIndex,self.monthIndex,self.dayIndex,self.hourIndex,self.minuteIndex);
}

//创建pickerView
- (UIPickerView *)pickerView
{
    if(!_pickerView){
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = NO;
    }
    return _pickerView;
}

//通过年月求每月天数
- (NSInteger)daysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:{
            return 31;
        }
            break;
        case 4:
        case 6:
        case 9:
        case 11:{
            return 30;
        }
            break;
        case 2:{
            if (isrunNian) {
                return 29;
            }else{
                return 28;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

//设置当前时间对应选择的位置
- (void)setNowDate
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger yearIndex = [dateComponent year] - DATEPICKER_MINDATE;
    NSInteger monthIndex = [dateComponent month] -1 ;
    NSInteger dayIndex = [dateComponent day];
    NSInteger hourIndex = [dateComponent hour] -0 ;
    NSInteger minuteIndex = [dateComponent minute];
    
    self.yearIndex = yearIndex;
    self.monthIndex = monthIndex;
    self.dayIndex = dayIndex;
    self.hourIndex = hourIndex;
    self.minuteIndex = minuteIndex;
    
    [self.pickerView selectRow:yearIndex inComponent:0 animated:NO];
    [self.pickerView selectRow:monthIndex inComponent:1 animated:NO];
    [self.pickerView selectRow:dayIndex inComponent:2 animated:NO];
    [self.pickerView selectRow:hourIndex inComponent:3 animated:NO];
    [self.pickerView selectRow:minuteIndex inComponent:4 animated:NO];

}

//选中后的时间
- (void)getSelectDate{
      NSLog(@"%ld - %ld - %ld - %ld - %ld",self.yearIndex + DATEPICKER_MINDATE,self.monthIndex + 1,self.dayIndex,self.hourIndex,self.minuteIndex);
    
}

@end
