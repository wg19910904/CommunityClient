//
//  AddressListCell.h
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddrListModel.h"
@interface AddressListCell : UITableViewCell
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *addressLabel;
@property (nonatomic,strong)UILabel *phoneLabel;
@property (nonatomic,strong)UIButton *operateBnt;
@property (nonatomic,strong)UIImageView *nameImg;
@property (nonatomic,strong)UIImageView *addressImg;
@property (nonatomic,strong)UIImageView *selectImg;
@property (nonatomic,assign)NSInteger index;
@property(nonatomic,assign)BOOL isCenter;
@property (nonatomic,strong)AddrListModel *addrListModel;
- (void)setAddrListModel:(AddrListModel *)addrListModel withIndex:(NSInteger)index;
@end
