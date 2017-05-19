//
//  TCContainerTextView.h
//  TCText
//
//  Created by tardis_cxx on 16/9/12.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCInputView.h"

@protocol TCContainerTextViewDelegate;

@interface TCContainerTextView : UIView

/**
 *  输入框
 */
@property (nonatomic, strong) TCInputView *tc_inputView;

@property (nonatomic, weak) id<TCContainerTextViewDelegate> delegate;

/**
 *  输入框为空时SVProgressHUD提示内容
 */
@property (nonatomic, copy) NSString *progressHUDTipIsNil;

/**
 *  输入框超出时SVProgressHUD提示内容
 */
@property (nonatomic, copy) NSString *progressHUDTipIsExtra;

/**
 *   最大字数
 */
@property (nonatomic, assign) NSInteger maxWordNumber;
   
/// 设置inputView（可选实现）
- (void)setInputViewWithPlaceholder:(NSString *)placeholder placeholderColor:(UIColor *)color maxNumberOfLines:(NSInteger)lines;

@end


@protocol TCContainerTextViewDelegate <NSObject>

@optional

/**
 *  发送content代理
 *
 *  @param containerTextView TCContainerTextView
 *  @param btn               UIButton
 *  @param content           要发送的内容
 */
- (void)containerTextView:(TCContainerTextView *)containerTextView clickSendButton:(UIButton *)btn content:(NSString *)content;

@end
