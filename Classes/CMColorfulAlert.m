//
//  CMColorfulAlert.m
//  CMColorfulAlert
//
//  Created by Wang on 2017/12/25.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import "CMColorfulAlert.h"
#import <Masonry/Masonry.h>

static CGFloat const kPadding = 20.0;
static CGFloat const kTopMargin = 35.0f;
static CGFloat const kLabelSpace = 8.0f;
static CGFloat const kButtonSpace = 12.0f;

@interface CMColorfulAlert()
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *containerView;

@property (copy ,nonatomic) void (^buttonClickBlock)(NSInteger);


@end

@implementation CMColorfulAlert

+ (instancetype)createWithTitleIcon:(UIImage *)titleIcon title:(NSString *)title contentImage:(UIImage *)contentImage contentLabels:(NSArray<NSString *> *)contentLabels buttonTitles:(NSArray<NSString *> *)buttonTitles buttonClickBlock:(void (^)(NSInteger))buttonClickBlock {
    CMColorfulAlert *alert = [[CMColorfulAlert alloc] initWithTitleIcon:titleIcon title:title contentImage:contentImage contentLabels:contentLabels buttonTitles:buttonTitles buttonClickBlock:buttonClickBlock];
    
    return alert;
}

- (instancetype)initWithTitleIcon:(UIImage *)titleIcon title:(NSString *)title contentImage:(UIImage *)contentImage contentLabels:(NSArray<NSString *> *)contentLabels buttonTitles:(NSArray<NSString *> *)buttonTitles buttonClickBlock:(void (^)(NSInteger))buttonClickBlock {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = ({
            UIView *view = [[UIView alloc] init];
            [self addSubview:view];
            view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            view;
        });
        
        self.containerView = ({
            UIView *view = [[UIView alloc] init];
            [self addSubview:view];
            view.backgroundColor = [UIColor whiteColor];
            view.clipsToBounds = YES;
            view.layer.cornerRadius = 5.0f;
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.width.equalTo(self).multipliedBy(0.7);
            }];
            
            UIButton *cancelBtn = [[UIButton alloc] init];
            [cancelBtn setImage:[UIImage imageNamed:@"cm_ca_close"] forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:cancelBtn];
            cancelBtn.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
            [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(2));
                make.trailing.equalTo(@(-kPadding));
            }];
            view;
        });
        __block UIView *referView = _containerView;
        
        //Title
        NSInteger flag = 0;
        UIImageView *iconImgView = nil;
        UILabel *titleLabel = nil;
        if (titleIcon) {
            flag = flag | 1;
            iconImgView = [[UIImageView alloc] initWithImage:titleIcon];
        }
        if (title) {
            flag = flag | (1 << 1);
            titleLabel = [[UILabel alloc] init];
            titleLabel.text = title;
            titleLabel.font = [UIFont boldSystemFontOfSize:17];
            titleLabel.textColor = [UIColor colorWithWhite: 33.0 / 255 alpha:1];
        }
        
        switch (flag) {
            case 1: {
                [_containerView addSubview:iconImgView];
                [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(referView).offset(kTopMargin);
                    make.centerX.equalTo(referView);
                    make.width.equalTo(@(titleIcon.size.width));
                    make.height.equalTo(@(titleIcon.size.width));
                }];
                referView = iconImgView;
            }
                break;
            case 2: {
                [_containerView addSubview:titleLabel];
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(referView).offset(kTopMargin);
                    make.centerX.equalTo(referView);
                }];
                referView = titleLabel;
            }
                break;
            case 3: {//当时这样设计是为了让标题和icon组成的视图居中,现在的话要求标题居中即可
            
                [_containerView addSubview:iconImgView];
                [_containerView addSubview:titleLabel];
            
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(referView).offset(kTopMargin);
                    make.centerX.equalTo(referView);
                }];
                [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(titleLabel);
                    make.width.equalTo(@(titleIcon.size.width));
                    make.height.equalTo(@(titleIcon.size.width));
                    make.trailing.equalTo(titleLabel.mas_leading).offset(-kPadding/2);
                }];
                
                referView = titleLabel;
            }
                break;
            default:
                break;
        }
        
        //ContentImage
        if (contentImage) {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:contentImage];
            [_containerView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(referView.mas_bottom).offset(kPadding);
                make.width.equalTo(@(contentImage.size.width));
                make.height.equalTo(@(contentImage.size.height));
                make.centerX.equalTo(_containerView);
            }];
            referView = imgView;
        }
        
        //ContentLabel
        if (contentLabels.count) {
            [contentLabels enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UILabel *label = [[UILabel alloc] init];
                label.text = obj;
                label.textColor = [UIColor colorWithRed:121.0/255 green:140.0/255 blue:167.0/255 alpha:1];
                label.textAlignment = NSTextAlignmentCenter;
                label.numberOfLines = 0;
                label.font = [UIFont systemFontOfSize:15];
                [_containerView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(@(kPadding));
                    make.trailing.equalTo(@(-kPadding));
                    make.top.equalTo(referView.mas_bottom).offset(idx == 0 ? kPadding : kLabelSpace);
                }];
                referView = label;
            }];
        }
        //Buttons
        if (buttonTitles.count) {
            [buttonTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:obj forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [button setBackgroundImage:[UIImage imageNamed:@"btn_background"] forState:UIControlStateNormal];
                button.tag = idx;
                button.titleLabel.font = [UIFont systemFontOfSize:16];
                [_containerView addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(@(kPadding));
                    make.trailing.equalTo(@(-kPadding));
                    make.height.equalTo(@(30));
                    make.top.equalTo(referView.mas_bottom).offset(idx == 0 ? kPadding : kButtonSpace);
                }];
                referView = button;
            }];
        }
        
        [referView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_containerView).offset(-kPadding);
        }];
        
    }
    return self;
}


- (void)cancelAction:(UIButton *)sender {
    [self hide];
}

- (void)clickButtonAction:(UIButton *)sender {
    !_buttonClickBlock ? : _buttonClickBlock(sender.tag);
    [self hide];
}

- (void)show {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    self.frame = [UIScreen mainScreen].bounds;
    [window addSubview:self];
}

- (void)showInView:(UIView *)view {
    UIView *containerView = view;
    if (containerView == nil) {
        containerView = UIApplication.sharedApplication.keyWindow;
    }
    self.frame = containerView.bounds;
    [containerView addSubview:self];
}

- (void)hide {
    [UIView animateWithDuration:0.05 animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.backgroundView.alpha = 0;
            self.containerView.alpha = 0;
            self.containerView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        } completion:^(BOOL finished) {
            self.backgroundView.alpha = 1;
            self.containerView.alpha = 1;
            self.containerView.transform = CGAffineTransformIdentity;
            [self removeFromSuperview];
        }];
    }];
    
}

@end
