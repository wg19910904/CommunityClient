//
//  JHSupermarketProductClassifyVC.h
//  JHCommunityClient
//
//  Created by xixixi on 16/3/4.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^RefreshBlock)(NSString *cate_id);
//回调所选分类行数
typedef void(^RefreshBtnTitleBlock)(NSString *btnTitle);
@interface JHSupermarketProductClassifyVC : JHBaseVC
@property(nonatomic, strong)UITableView *leftTable;
@property(nonatomic, strong)UITableView *rightTable;
@property(nonatomic,copy)NSString *shop_id;
//上个界面传递的商超商品分类
@property(nonatomic,copy)NSArray *goosCateArray;
@property(nonatomic,copy)RefreshBlock refreshBlock;
//传递选中的title
@property(nonatomic,copy)RefreshBtnTitleBlock refreshBtnTitleBlock;
@end
