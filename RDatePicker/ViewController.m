//
//  ViewController.m
//  RDatePicker
//
//  Created by roycms on 2017/2/8.
//  Copyright © 2017年 杜耀辉. All rights reserved.
//

#import "ViewController.h"
#import "RDatePicker.h"
@interface ViewController ()
@property (nonatomic,strong)UITextField *textField;
@end

@implementation ViewController
- (IBAction)startBt:(id)sender {
    [self.textField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.textField isExclusiveTouch]) {
        [self.textField resignFirstResponder];
    }
}

- (UITextField *)textField {
    if (_textField == nil) {
        RDatePicker *pickview = [[RDatePicker alloc]init];
        pickview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 260);

        _textField = [[UITextField alloc] init];
        _textField.inputView = pickview;
        //_textField.inputAccessoryView = self.accessoryView;
        [self.view addSubview:_textField];
    }
    return _textField;
}


@end
