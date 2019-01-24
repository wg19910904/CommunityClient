//
//  XHQRCodeVC.h
//  JHCommunityBiz
//
//  Created by xixixi on 2017/5/16.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface XHQRCodeVC : UIViewController
/**
 *  是不是扫描条形码(默认扫描二维码)
 */
@property(nonatomic,assign)BOOL is_barcode;

@property (copy, nonatomic) void (^completionBlock) (NSString *result);

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock;

@end
