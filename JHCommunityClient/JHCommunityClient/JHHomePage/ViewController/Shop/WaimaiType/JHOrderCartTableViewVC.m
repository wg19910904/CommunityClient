//
//  JHOrderCartTableViewVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/4/18.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHOrderCartTableViewVC.h"
#import "JHOrderInfoModel.h"
#import "JHCartCell.h"
#import "DSToast.h"
#define OrderCartTableCell_height  (40.0f)
#define OrderCartTable_Max_Height  (HEIGHT - 180.0f - 99.0f)

@interface JHOrderCartTableViewVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)NSArray *dataArray;
@property(nonatomic,assign)CGFloat tableView_height;
@end
@implementation JHOrderCartTableViewVC
{
    DSToast *toast;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self handleData];
    [self createMainTabelView];
}
#pragma mark - 处理数据
- (void)handleData
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    JHOrderInfoModel *model = [JHOrderInfoModel shareModel];
    NSDictionary *cartInfo = [model getCartInfoWithShop_id:_shop_id];
    _dataArray = cartInfo[@"products"];
    [self handleSelf_frame];
}
#pragma mark - 计算self.view的frame
- (void)handleSelf_frame
{
    if (_dataArray.count * OrderCartTableCell_height + 35 > OrderCartTable_Max_Height) {
        
        _tableView_height = OrderCartTable_Max_Height;
        
    }else{
        
        _tableView_height = _dataArray.count * OrderCartTableCell_height + 35;
    }
    
    self.view.frame = FRAME(0, HEIGHT - _tableView_height - 50 - _interval, WIDTH, _tableView_height);
}
#pragma mark - 创建表视图
- (void)createMainTabelView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, _tableView_height)
                                                     style:(UITableViewStylePlain)];
        _mainTableView.separatorInset = UIEdgeInsetsZero;
        _mainTableView.layoutMargins = UIEdgeInsetsZero;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [self.view addSubview:_mainTableView];
    }
}
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 35)];
    headerView.backgroundColor = BACKGROUND_COLOR;
    //添加清空购物车按钮
    UIButton *cleanBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 100, 2.5, 90, 30)];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7.5, 20, 20)];
    iv.image = [UIImage imageNamed:@"clean"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 7.5, 60, 20)];
    label.text = NSLocalizedString(@"清空所有", nil);
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:135/255.0
                                      green:135/255.0
                                       blue:135/255.0
                                      alpha:1.0];
    [cleanBtn addSubview:iv];
    [cleanBtn addSubview:label];
    //为清空按钮添加方法
    [cleanBtn addTarget:self action:@selector(clickCleanBtn) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cleanBtn];
    return headerView;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return OrderCartTableCell_height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHCartCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"JHCartCellID"];
    if (!cell) {
        cell = [[JHCartCell alloc]initWithStyle:(UITableViewCellStyleDefault)
                                reuseIdentifier:@"JHCartCellID"];
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.dataDic = (NSDictionary *)_dataArray[indexPath.row];
    //为加减号添加方法
    [cell.subBtn addTarget:self action:@selector(clickCellSubBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.addBtn addTarget:self action:@selector(clickCellAddBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}
#pragma mark - 点击cell内减号
- (void)clickCellSubBtn:(UIButton *)sender
{
    //获取相应的cell
    JHCartCell *cell = (JHCartCell *)[sender superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    //获获取相应的产品信息
    NSDictionary *productDic = _dataArray[indexPath.row];
    //减去相应的产品
    JHOrderInfoModel *model = [JHOrderInfoModel shareModel];
    [model removeShopCartInfoWithShop_id:_shop_id
                          withProduct_id:productDic[@"product_id"]
                             withSpec_id:productDic[@"spec_id"]];
    
    
    [self handleData];
    if (_dataArray.count == 0) {
        //点击清空按钮
        [self clickCleanBtn];
    }else{
        _mainTableView.frame = FRAME(0, 0, WIDTH, _tableView_height);
    }
    
    //刷新购物车表视图和menu
    _refreshCartAndMenuBlock();
}
#pragma mark - 点击cell内加号
- (void)clickCellAddBtn:(UIButton *)sender
{
    //获取相应的cell
    JHCartCell *cell = (JHCartCell *)[sender superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    //获获取相应的产品信息
    NSDictionary *productDic = _dataArray[indexPath.row];
    NSInteger current_num = [cell.num.text integerValue];
    NSInteger max_num = [productDic[@"max_num"] integerValue];
    if (current_num >= max_num) {
        [self showMaxNum];
        return;
    }
    //增加相应的产品
    JHOrderInfoModel *model = [JHOrderInfoModel shareModel];
    [model addShopCartInfoWithShop_id:_shop_id
                       withProduct_id:productDic[@"product_id"]
                    withProduct_title:productDic[@"product_title"]
                          withSpec_id:productDic[@"spec_id"]
                       withSpec_title:productDic[@"spec_title"]
                            withPrice:productDic[@"price"]
                    withPackage_price:productDic[@"package_price"]
                           withMaxNum:productDic[@"max_num"]];
    //刷新购物车表视图和menu
    _refreshCartAndMenuBlock();
}
#pragma mark - 点击清空购物车按钮
- (void)clickCleanBtn
{
    
    JHOrderInfoModel *model = [JHOrderInfoModel shareModel];
    [model removeShopCartInfoWithShop_id:_shop_id];
    //刷新购物车表视图和menu
    _clickCleanBtnBlock();                           
}
#pragma mark - 没有数据时展示
- (void)showMaxNum
{
    if (toast == nil) {
        toast = [[DSToast alloc] initWithText:NSLocalizedString(@"很抱歉\n已经达到最大购买数量", nil)];
        [toast showInView:self.view.superview showType:(DSToastShowTypeCenter) withBlock:^{
            toast = nil;
        }];
    }
}
@end
