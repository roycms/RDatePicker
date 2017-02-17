//
//  RDatePicker.h
//  RDatePicker
//
//  Created by roycms on 2017/2/8.
//  Copyright © 2017年 杜耀辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDatePicker : UIView
/**
 选择日历时间成功后 complete block
 */
@property (nonatomic,copy) void(^complete)(NSInteger minute,NSInteger hour,NSInteger day, NSInteger month, NSInteger year ,NSDate *date);

@end
