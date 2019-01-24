//
//  XHCodeTF.h
//  JHCommunityClient
//
//  Created by xixixi on 2018/4/8.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHCodeTF : UITextField

@property(nonatomic,assign)BOOL showCode; //是否显示区号
@property(nonatomic,readonly,copy)NSString *code; //获取区号
@property(nonatomic,weak)UIViewController *fatherVC;
//获取后台需要的格式化之后的字符串
@property(nonatomic,readonly,copy)NSString *format_content;
@end
