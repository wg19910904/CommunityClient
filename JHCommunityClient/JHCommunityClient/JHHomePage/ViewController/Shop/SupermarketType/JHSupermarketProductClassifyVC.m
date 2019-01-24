//
//  JHSupermarketProductClassifyVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/4.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSupermarketProductClassifyVC.h"
 
@interface JHSupermarketProductClassifyVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,copy)NSArray *dataArray;
@property(nonatomic,strong)NSMutableDictionary *selectRowDic; //@{leftRow:x,rightRow:y}
@end

@implementation JHSupermarketProductClassifyVC
{
    //点击了左侧cell
    NSInteger _rightTable_rowNum;
    //右侧表视图数据源
    NSArray *leftDataArray;
    NSArray *rightDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden = YES;
    self.view.frame = FRAME(0, (NAVI_HEIGHT+40), WIDTH, HEIGHT - (NAVI_HEIGHT+40));
    self.view.backgroundColor = HEX(@"000000", 0.3);
    [self createLeftTable];
    [self createRightTable];
    //请求新数据
    [self loadNewData];
}
#pragma mark - 请求新数据
- (void)loadNewData
{
   
    if (!_goosCateArray) {
         SHOW_HUD
        //请求数据
        [HttpTool postWithAPI:@"client/waimai/product/marketgoodscate"
                   withParams:@{@"shop_id":_shop_id}
                      success:^(id json) {
                          NSLog(@"client/waimai/product/marketgoodscate---%@",json);
                          _goosCateArray = json[@"data"][@"items"];
                          [self createLeftTable];
                          [self createRightTable];
                          HIDE_HUD
                      }failure:^(NSError *error) {
                           HIDE_HUD
                          NSLog(@"%@",error.localizedDescription);
                      }];
       
    }else{
        [self createLeftTable];
        [self createRightTable];
    }
    
}
#pragma mark - 创建左侧表视图
- (void)createLeftTable
{
    if (!_leftTable) {
        _leftTable = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH / 5 * 2, 360)
                                                  style:(UITableViewStylePlain)];
        _leftTable.delegate = self;
        _leftTable.dataSource = self;
        _leftTable.showsVerticalScrollIndicator = YES;
        _leftTable.tag = 100;
        _leftTable.backgroundColor = [UIColor whiteColor];
        _leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTable.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_leftTable];
    }else{
        [_leftTable reloadData];
    }
}
#pragma mark - 创建右侧表视图
- (void)createRightTable
{
    if (!_rightTable) {
        _rightTable = [[UITableView alloc] initWithFrame:FRAME( WIDTH / 5 * 2, 0,  WIDTH / 5 * 3, 360)
                                                   style:(UITableViewStylePlain)];
        _rightTable.delegate = self;
        _rightTable.dataSource = self;
        _rightTable.showsVerticalScrollIndicator = NO;
        _rightTable.tag = 200;
        _rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];
        UIImageView *backView = [UIImageView new];
        [view addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 0;
            make.right.offset = 0;
            make.bottom.offset = 0;
            make.height.offset = 90;
        }];
        backView.image = IMAGE(@"pic_shop_cateBg");
        _rightTable.backgroundView = view;
        [self.view addSubview:_rightTable];
    }else{
        [_rightTable reloadData];
    }
}
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case 100:  //左
            return _goosCateArray.count + 1;
            break;
        case 200:  //右
            return _rightTable_rowNum;
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    CGFloat width = CGRectGetWidth(tableView.bounds);
    switch (tableView.tag) {
        case 100:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.backgroundColor = [UIColor whiteColor];
            UIView *selectedBV = [[UIView alloc] initWithFrame:cell.bounds];
            selectedBV.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0f];
            cell.selectedBackgroundView = selectedBV;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(20, 0, width-20, 40)];
            titleLabel.font = FONT(12);
            titleLabel.textColor = HEX(@"333333", 1.0f);
            if ([[_selectRowDic allKeys] containsObject:@"leftRow"] &&
                indexPath.row == [_selectRowDic[@"leftRow"] integerValue]) {
                titleLabel.textColor = THEME_COLOR;
            }
            UIImageView *dirImg = [[UIImageView alloc] init];
            dirImg.image = IMAGE(@"jiantou_1");
            dirImg.frame = FRAME(width - 27, 14, 7, 12);
            dirImg.tag = 200;
            titleLabel.tag = 100;
            if (row == 0) {
                 titleLabel.text = NSLocalizedString(@"全部", nil);
                [dirImg removeFromSuperview];
            }else{
                titleLabel.text = _goosCateArray[row - 1][@"title"];
                [cell.contentView addSubview:dirImg];
            }
//            //添加下边线
            UIView *line = [[UIView alloc] initWithFrame:FRAME(0, 0, width, 0.5)];
            line.backgroundColor = LINE_COLOR;
            if(indexPath.row != 0){
                [cell.contentView addSubview:line];
            }
            [cell addSubview:titleLabel];
            return cell;
        }
            break;
        case 200:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, width, 40)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, width - 45, 40)];
            titleLabel.font = FONT(12);
            titleLabel.textColor = HEX(@"333333", 1.0f);
            if ([[_selectRowDic allKeys] containsObject:@"rightRow"] &&
                indexPath.row == [_selectRowDic[@"rightRow"] integerValue]) {
                titleLabel.textColor = THEME_COLOR;
            }

            titleLabel.text = rightDataArray[row][@"title"];
            titleLabel.tag = 100;
            UIImageView *dirImg = [[UIImageView alloc] init];
            dirImg.image = IMAGE(@"selected-0");
            dirImg.frame = FRAME(width - 25, 15, 15,10);
            dirImg.tag = 200;
            [cell.contentView addSubview:dirImg];
            dirImg.hidden = YES;
            //添加下边线
            UIView *line = [[UIView alloc] initWithFrame:FRAME(0, 0, width, 0.5)];
            line.backgroundColor = LINE_COLOR;
            if(indexPath.row != 0){
                [cell.contentView addSubview:line];
            }
            [cell addSubview:titleLabel];
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.textColor = THEME_COLOR;
    if (tableView == _leftTable) {
        if (row == 0) {
            //刷新商家列表
            _rightTable_rowNum = 0;
            [_rightTable reloadData];
            //block回调
            _refreshBlock(@"0");
             _refreshBtnTitleBlock(NSLocalizedString(@"全部", nil));
            [self touch_BackView];
        }else{
            UITableViewCell *cell = [_leftTable cellForRowAtIndexPath:indexPath];
            UIImageView *dirImg = [cell.contentView viewWithTag:200];
            dirImg.hidden = YES;
            rightDataArray = _goosCateArray[row - 1][@"childrens"];
            _rightTable_rowNum = [rightDataArray count];
            if (_rightTable_rowNum == 0) {
                //获取要添加的字典
                NSDictionary *temDic = _goosCateArray[row-1];
                //block回调
                _refreshBlock(temDic[@"cate_id"]);
                _refreshBtnTitleBlock(temDic[@"title"]);
                [self touch_BackView];
            }
             [_rightTable reloadData];
        }
#pragma mark---存储点击的行数,左
        _selectRowDic = [@{} mutableCopy];
        [_selectRowDic addEntriesFromDictionary:@{@"leftRow":@(indexPath.row)}];
        
    }else{
        
#pragma mark---存储点击的行数,右
        UITableViewCell *cell = [_rightTable cellForRowAtIndexPath:indexPath];
        UIImageView *dirImg = [cell.contentView viewWithTag:200];
        dirImg.hidden = NO;
        [_selectRowDic addEntriesFromDictionary:@{@"rightRow":@(indexPath.row)}];
        //获取分类id
        NSDictionary *temDic = rightDataArray[row];
        //block回调
        _refreshBlock(temDic[@"cate_id"]);
        _refreshBtnTitleBlock(temDic[@"title"]);
        [self touch_BackView];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.textColor = HEX(@"333333", 1.0f);
    UIImageView *dirImg = [cell.contentView viewWithTag:200];
    if(tableView == _leftTable){
        dirImg.hidden = NO;
    }else{
        dirImg.hidden =  YES;
    }
}
- (void)touch_BackView
{
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"JHDeleteNavVCNotificationName" object:self userInfo:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
