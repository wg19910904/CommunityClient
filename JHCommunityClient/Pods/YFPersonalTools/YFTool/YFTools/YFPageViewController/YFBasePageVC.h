//
//  YFBasePageVC.h
//  YFPageViewControllerVC
//
//  Created by ios_yangfei on 2017/12/20.
//  Copyright © 2017年 jianghu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFBasePageVC : UIViewController
@property(nonatomic,weak)UIViewController *superVC;
@property(nonatomic,assign)NSInteger yf_base_index;

// 界面第一次创建
-(void)viewAppearToDoThing;

@end
