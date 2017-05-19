//
//  TCContainerTextView.m
//  TCText
//
//  Created by tardis_cxx on 16/9/12.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "TCContainerTextView.h"
#import <Masonry.h>
#import <SVProgressHUD.h>

#define COLOR_RGB(r, g, b) [UIColor colorWithRed:r /255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0]

static const NSTimeInterval kSVProgressHUDDismissTime = 1.5;

@interface TCContainerTextView () <UITextViewDelegate>

@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation TCContainerTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI 

- (void)setupUI {
    [self addSubview:self.tc_inputView];
    [self addSubview:self.sendBtn];
    
    [self.tc_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(5.0);
        make.bottom.equalTo(self).offset(-5.0);
        make.right.equalTo(self.sendBtn.mas_left).offset(-5.0);
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self).offset(-5.0);
        make.width.mas_equalTo(60.0);
        make.height.mas_equalTo(45.0);
    }];
}
    
#pragma mark - public
    
- (void)setInputViewWithPlaceholder:(NSString *)placeholder placeholderColor:(UIColor *)color maxNumberOfLines:(NSInteger)lines {
    self.tc_inputView.placeholder = placeholder;
    self.tc_inputView.placeholderColor = color;
    self.tc_inputView.maxNumberOfLines = lines;
}


#pragma mark - action

- (void)onSendBtnTap:(UIButton *)btn {
    NSLog(@"%s", __func__);
    NSString *content = self.tc_inputView.text;
    if (content.length <= 0) {
        [SVProgressHUD showErrorWithStatus:self.progressHUDTipIsNil ?: @"请输入评论"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kSVProgressHUDDismissTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        return;
    }
    
    NSInteger maxWordNumber = self.maxWordNumber ?: 50;
    if (content.length > maxWordNumber) {
        [SVProgressHUD showErrorWithStatus:self.progressHUDTipIsExtra ?: [NSString stringWithFormat:@"评论不能大于%@字", @(maxWordNumber)]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kSVProgressHUDDismissTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(containerTextView:clickSendButton:content:)]) {
        [self.delegate containerTextView:self clickSendButton:btn content:content];
    }
}

#pragma mark - getter

- (TCInputView *)tc_inputView {
    if (!_tc_inputView) {
        _tc_inputView = [[TCInputView alloc] init];
        _tc_inputView.font = [UIFont systemFontOfSize:17.0];
        _tc_inputView.maxNumberOfLines = 5;
    }
    return _tc_inputView;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:20.0];
        _sendBtn.userInteractionEnabled = YES;
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:COLOR_RGB(29, 169, 158) forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(onSendBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}


@end
