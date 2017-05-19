//
//  TCInputView.m
//  TCText
//
//  Created by tardis_cxx on 16/9/9.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "TCInputView.h"

@interface TCInputView ()

@property (nonatomic, strong) UITextView *placeholderView;

/**
 *  文字高度
 */
@property (nonatomic, assign) NSInteger textH;

/**
 *  文字最大高度
 */
@property (nonatomic, assign) NSInteger maxTextH;

@end

@implementation TCInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

// 如果从SB或XIB加载
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

#pragma mark - UI

- (void)setupUI {
    [self addSubview:self.placeholderView];
    
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 5.0;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_firstBaselineOffsetFromTop {}
- (void)_baselineOffsetFromBottom {}

#pragma mark - action

- (void)textDidChange {
    self.placeholderView.hidden = self.text.length > 0;
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    if (self.textH != height) {
        
        if ([UIDevice currentDevice].systemVersion.floatValue < 9.0) {
            self.scrollEnabled = height > self.maxTextH && self.maxTextH > 0;
        }else {
            self.scrollEnabled = height > self.maxTextH && self.maxTextH > 0;
        }
        self.textH = height;
        
        if (self.textHeightChangedBlock && self.scrollEnabled == NO) {
            self.textHeightChangedBlock(self.text, height);
            [self.superview layoutIfNeeded];
            self.placeholderView.frame = self.bounds;
        }else {}
    }
}

#pragma mark - setter

- (void)setMaxNumberOfLines:(NSInteger)maxNumberOfLines {
    if (_maxNumberOfLines == maxNumberOfLines) {
        return;
    }
    _maxNumberOfLines = maxNumberOfLines;
    self.maxTextH = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top +self.textContainerInset.bottom);
}

- (void)setCornerRadius:(NSUInteger)cornerRadius {
    if (_cornerRadius == cornerRadius) {
        return;
    }
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}

- (void)setTextHeightChangedBlock:(TCTextHeightChangedBlock)textHeightChangedBlock {
    if (_textHeightChangedBlock == textHeightChangedBlock) {
        return;
    }
    _textHeightChangedBlock = textHeightChangedBlock;
    [self textDidChange];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if ([_placeholderColor isEqual:placeholderColor]) {
        return;
    }
    _placeholderColor = placeholderColor;
    self.placeholderView.textColor = _placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder {
    if ([_placeholder isEqualToString:placeholder]) {
        return;
    }
    _placeholder = placeholder;
    self.placeholderView.text = _placeholder;
}

#pragma mark - getter

- (UITextView *)placeholderView {
    if (!_placeholderView) {
        _placeholderView = [[UITextView alloc] init];
        _placeholderView.scrollEnabled = NO;
        _placeholderView.showsHorizontalScrollIndicator = NO;
        _placeholderView.showsVerticalScrollIndicator = NO;
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.font = [UIFont systemFontOfSize:17.0];
        _placeholderView.textColor = [UIColor lightGrayColor];
        _placeholderView.backgroundColor = [UIColor clearColor];
    }
    return _placeholderView;
}


@end
