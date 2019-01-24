//
//  JHIntegrationCancelMengBan.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/30.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHIntegrationCancelMengBan : UIControl<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic,strong)JHIntegrationCancelMengBan *cancelMengBan;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)void(^(cancelSuccessBlock))();
+ (void)createIntegrationMengBanWithOrder_id:(NSString *)order_id cancelSuccess:(void(^)())cancelSuccessBlock;
@end
