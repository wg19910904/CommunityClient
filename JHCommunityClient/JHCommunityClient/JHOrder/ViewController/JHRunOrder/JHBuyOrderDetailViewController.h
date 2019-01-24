//
//  JHBuyOrderDetailViewController.h
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHBuyOrderDetailViewController : JHBaseVC
@property(nonatomic,copy)NSString * order_id;
//@property(nonatomic,copy)NSString * danbao_amount;
//@property(nonatomic,copy)NSString * paotui_amount;
//@property(nonatomic,copy)NSString * jifen;
//@property(nonatomic,copy)NSString * chajia;
@property(nonatomic,copy)void(^myBlock)(void);
@property(nonatomic,assign)BOOL isPayCome;//是否从支付界面跳转过来
@end
