//
//  JHSubNavClassifyVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/2/27.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSubNavAddressVC.h"
#import "JHShareModel.h"
 
@interface JHSubNavAddressVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation JHSubNavAddressVC
{
    NSMutableArray *commercialDataArray;
    //点击了左侧cell
    NSInteger _rightTable_rowNum;
    //右侧表视图数据源
    NSArray *rightDataArray;
    NSInteger leftIndex;
    NSInteger rightIndex;
    NSInteger oldIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.hidden = YES;
    self.view.frame = FRAME(0, (NAVI_HEIGHT+40), WIDTH, HEIGHT - (NAVI_HEIGHT+40));
    self.view.backgroundColor = HEX(@"000000", 0.3);
    [self createLeftTable];
    [self createRightTable];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLeftIndex) name:@"changeLeftIndex" object:nil];
}
-(void)changeLeftIndex{
    if (!_isRightStartSelector || leftIndex == 0) {
        return;
    }
    leftIndex = oldIndex;
    if (leftIndex - 1 == 0) {
        rightDataArray = @[@{@"business_name":NSLocalizedString(@"附近", nil),
                             @"range":@"0.5"},
                           @{@"business_name":@"1km",
                             @"range":@"1"},
                           @{@"business_name":@"3km",
                             @"range":@"3"},
                           @{@"business_name":@"5km",
                             @"range":@"5"},
                           @{@"business_name":@"10km",
                             @"range":@"10"},
                           @{@"business_name":NSLocalizedString(@"全城", nil),
                             @"range":@"100"}];
        _rightTable_rowNum = [rightDataArray count];
        [_rightTable reloadData];
    }else{
        rightDataArray = commercialDataArray[leftIndex - 2][@"business"];
        _rightTable_rowNum = [rightDataArray count];
        [_rightTable reloadData];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    //请求新数据
    oldIndex = leftIndex;
    [self loadNewData];
}
#pragma mark - 请求新数据
- (void)loadNewData
{
   // commercialDataArray = [JHShareModel shareModel].commercialDataArray;
//    if (!commercialDataArray) {
        SHOW_HUD
        //请求数据
        NSString *cityCode = [JHShareModel shareModel].cityCode;
        [HttpTool postWithAPI:@"client/shop/business"
                   withParams:@{@"city_code":(cityCode.length == 0 || cityCode == nil) ? @"0551":cityCode}
                      success:^(id json) {
                          NSLog(@"client/shop/business---%@",json);
                          [commercialDataArray removeAllObjects];
                          commercialDataArray = json[@"data"][@"items"];
                          //[JHShareModel shareModel].commercialDataArray = commercialDataArray;
                          [self createLeftTable];
                          [self createRightTable];
                          HIDE_HUD
                      }failure:^(NSError *error) {
                          HIDE_HUD
                          NSLog(@"%@",error.localizedDescription);
                      }];
//    }else{
//        [self createLeftTable];
//        [self createRightTable];
//    }
    
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
        _rightTable = [[UITableView alloc] initWithFrame:FRAME(WIDTH / 5 * 2, 0, WIDTH / 5 * 3, 360)
                                                   style:(UITableViewStylePlain)];
        _rightTable.delegate = self;
        _rightTable.dataSource = self;
        _rightTable.showsVerticalScrollIndicator = NO;
        _rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTable.tag = 200;
        _rightTable.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];
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
            return commercialDataArray.count + 1;
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
            titleLabel.tag = 100;
            UIImageView *dirImg = [[UIImageView alloc] init];
            dirImg.image = IMAGE(@"jiantou_1");
            dirImg.frame = FRAME(width - 27, 14, 7, 12);
            dirImg.tag = 200;
            [cell.contentView addSubview:dirImg];
            if (row == 0) {
                titleLabel.text = NSLocalizedString(@"附近", nil);
            }else{
                titleLabel.text = commercialDataArray[row - 1][@"area_name"];
            }
            //添加下边线
            UIView *line = [UIView new];
            line.frame = FRAME(0, 0, width, 0.5);
            line.backgroundColor = LINE_COLOR;
            if(indexPath.row != 0){
                [cell.contentView addSubview:line];
            }
            [cell addSubview:titleLabel];
            if (leftIndex - 1 == indexPath.row) {
                titleLabel.textColor = THEME_COLOR;
                dirImg.hidden = YES;
            }
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
            titleLabel.text = rightDataArray[row][@"business_name"];
            titleLabel.tag = 100;
            UIImageView *dirImg = [[UIImageView alloc] init];
            dirImg.image = IMAGE(@"selected-0");
            dirImg.frame = FRAME(width - 25, 15, 15,10);
            dirImg.tag = 200;
            [cell.contentView addSubview:dirImg];
            dirImg.hidden = YES;
//            //添加下边线
            UILabel *line = [UILabel new];
            line.frame = FRAME(0, 0, width, 0.5);
            line.backgroundColor = LINE_COLOR;
            if(indexPath.row != 0){
                [cell.contentView addSubview:line];
            }
            [cell addSubview:titleLabel];
            if (rightIndex - 1 == indexPath.row && _isStartSelector) {
                titleLabel.textColor = THEME_COLOR;
                dirImg.hidden = NO;
            }
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
    if (_isStartSelector  && tableView == _leftTable) {
        [self tableView:tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:leftIndex-1 inSection:indexPath.section]];
        _isStartSelector = NO;
    }
    if (_isRightStartSelector  && tableView == _rightTable) {
        _isRightStartSelector = NO;
        [self tableView:tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:rightIndex-1 inSection:indexPath.section]];
    }
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.textColor = THEME_COLOR;
    if (tableView == _leftTable) {
        if (row == 0) {
            rightDataArray = @[@{@"business_name":NSLocalizedString(@"附近", nil),
                                 @"range":@"0.5"},
                               @{@"business_name":@"1km",
                                 @"range":@"1"},
                               @{@"business_name":@"3km",
                                 @"range":@"3"},
                               @{@"business_name":@"5km",
                                 @"range":@"5"},
                               @{@"business_name":@"10km",
                                 @"range":@"10"},
                               @{@"business_name":NSLocalizedString(@"全城", nil),
                                 @"range":@"100"}];
            _rightTable_rowNum = [rightDataArray count];
            leftIndex = indexPath.row + 1;
            [_rightTable reloadData];
            
        }else{
            rightDataArray = commercialDataArray[row - 1][@"business"];
            _rightTable_rowNum = [rightDataArray count];
            if (_rightTable_rowNum == 0) {
                //获取要添加的字典
                NSDictionary *temDic = commercialDataArray[row-1];
                NSDictionary *paramDic = @{@"area_id":temDic[@"area_id"]};
                //block回调
                
                _refreshBlock(paramDic);
                _refreshBtnTitleBlock(temDic[@"area_name"]);
                [self touch_BackView];
            }
            leftIndex = indexPath.row + 1;
            [_rightTable reloadData];
        }
        
        UIImageView *dirImg = [cell.contentView viewWithTag:200];
        dirImg.hidden = YES;
    }else{ // 点击了右侧表视图cell
       
        UITableViewCell *cell = [_rightTable cellForRowAtIndexPath:indexPath];
        UIImageView *dirImg = [cell.contentView viewWithTag:200];
        dirImg.hidden = NO;
        rightIndex = indexPath.row + 1;
            //获取分类id
        NSDictionary *temDic = rightDataArray[row];
        NSDictionary *paramDic;
        NSArray *temArray = [temDic allKeys];
        if ([temArray containsObject:@"business_id"]) {
                paramDic = @{@"business_id":temDic[@"business_id"]};
        }else{
                paramDic = @{@"range":temDic[@"range"]};
        }
        //block回调
        _refreshBlock(paramDic);
        _refreshBtnTitleBlock(temDic[@"business_name"]);
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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeLeftIndex" object:nil];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"JHDeleteNavVCNotificationName" object:self userInfo:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
