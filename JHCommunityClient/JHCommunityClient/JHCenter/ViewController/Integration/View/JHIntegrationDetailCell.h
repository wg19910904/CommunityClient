//
//  JHIntegrationDetailCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/30.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHIntegrationOrderListModel.h"
@interface JHIntegrationDetailCell : UITableViewCell
@property (nonatomic,strong)UILabel *orderID;//订单号
@property (nonatomic,strong)UILabel *contact;//联系人
@property (nonatomic,strong)UILabel *addr;//地址
@property (nonatomic,strong)UILabel *payType;//支付方式
@property (nonatomic,strong)JHIntegrationOrderListModel *detailModel;
@end
