//
//  AddMessageVC.h
//  Lunch
//
//  Created by jianghu1 on 15/12/17.
//  Copyright © 2015年 jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMessageVC : UIViewController
@property (nonatomic, copy)NSString *msgString;
@property (nonatomic, copy)void(^block)(NSString *text);

@end