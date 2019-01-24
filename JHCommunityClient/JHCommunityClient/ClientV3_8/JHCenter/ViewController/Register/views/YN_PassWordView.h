//
//  YN_PassWordView.h
//  自己玩
//
//  Created by ijianghu on 2018/5/11.
//  Copyright © 2018年 杨楠. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^textBlock) (NSString *str);


@interface YN_PassWordView : UIView
@property(nonatomic,strong)UITextField *textF;
@property(nonatomic,strong)UIColor *tintColor;
@property(nonatomic, copy)textBlock textBlock;

-(void)cleanPassword;
@end
