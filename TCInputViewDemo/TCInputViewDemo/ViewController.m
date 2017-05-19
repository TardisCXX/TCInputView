//
//  ViewController.m
//  TCInputViewDemo
//
//  Created by tardis_cxx on 2017-5-19.
//  Copyright © 2017年 tardis_cxx. All rights reserved.
//

#import "ViewController.h"
#import "TCContainerTextView.h"
#import <Masonry.h>

@interface ViewController ()
    
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/// 输入框
@property (nonatomic, strong) TCContainerTextView *textView;
@property (nonatomic, strong) NSLayoutConstraint *containerHCons;
@property (nonatomic, strong) NSLayoutConstraint *containerBCons;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupUI];
    [self configureNotification];
}
    
    
- (void)setupUI {
    [self.view addSubview:self.textView];
    
    NSArray *constraints = [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50.0);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    MASConstraint *consH = [constraints firstObject];
    MASConstraint *consB = [constraints lastObject];
    
    self.containerHCons = [consH valueForKey:@"layoutConstraint"];
    self.containerBCons = [consB valueForKey:@"layoutConstraint"];
    
    __weak typeof(self) weakSelf = self;
    self.textView.tc_inputView.textHeightChangedBlock = ^(NSString *text, CGFloat textHeight) {
        weakSelf.containerHCons.constant = textHeight + 10.0;
    };
    
}
    
- (void)configureNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
    
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
    
#pragma mark - action
    
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSLog(@"%s", __func__);
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    // 修改约束
    self.containerBCons.constant = endFrame.origin.y != screenH ? -endFrame.size.height : 0;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}


    
    
- (TCContainerTextView *)textView {
    if (!_textView) {
        _textView = [[TCContainerTextView alloc] init];
        _textView.maxWordNumber = 50;
    }
    
    return _textView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
