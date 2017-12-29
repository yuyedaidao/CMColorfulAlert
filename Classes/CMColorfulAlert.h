//
//  CMColorfulAlert.h
//  CMColorfulAlert
//
//  Created by Wang on 2017/12/25.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CMColorfulAlert : UIView

+(instancetype)createWithTitleIcon:(UIImage *)titleIcon title:(NSString *)title contentImage:(UIImage *)contentImage contentLabels:(NSArray<NSString *> *)texts buttonTitles:(NSArray<NSString *> *)buttonTitles buttonClickBlock: (void (^)(NSInteger index))buttonClickBlock cancelClickBlock:(void (^)(void))cancelClickBlock;
- (void)show;
- (void)showInView:(UIView *)view;

//@property (copy, nonatomic) void (^cancelClickBlock)(void);

@end
