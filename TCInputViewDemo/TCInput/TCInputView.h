//
//  TCInputView.h
//  TCText
//
//  Created by tardis_cxx on 16/9/9.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TCTextHeightChangedBlock)(NSString *text, CGFloat textHeight);

@interface TCInputView : UITextView

@property (nonatomic, copy) TCTextHeightChangedBlock textHeightChangedBlock;
@property (nonatomic, assign) NSInteger maxNumberOfLines;
@property (nonatomic, assign) NSUInteger cornerRadius;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

// 当文字改变时应该调用该方法
- (void)textDidChange;

@end
