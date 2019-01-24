//
//  WaiMaiShopperCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/3/27.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "WaiMaiShopperCell.h"
#import "StarView.h"
#import <UIImageView+WebCache.h>
#import "YFTypeBtn.h"
#import "ActivityImgCell.h"
#import <YFCollectionViewAutoFlowLayout.h>

@interface WaiMaiShopperCell ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,YFCollectionViewAutoFlowLayoutDelegate>
@property(nonatomic,weak)WaiMaiShopperModel *model;

@property(nonatomic,weak)UIImageView *iconImgVew;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UIView *starView;
@property(nonatomic,weak)UILabel *scoreLab;// 评分
@property(nonatomic,weak)UILabel *countLab;
@property(nonatomic,weak)UILabel *sendPriceLab;// 起送价 与 配送费
@property(nonatomic,weak)UILabel *distanceLab;
@property(nonatomic,weak)UILabel *sendTypeLab;// 平台送
@property(nonatomic,weak)UILabel *timeLab;// 配送时间

@property(nonatomic,weak)UIView *lineView;
@property(nonatomic,weak)UITableView *tableView;

@property(nonatomic,strong)NSArray *youhuiArr;

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UILabel *statusLabel;//展示打样中还是营业中

@end

@implementation WaiMaiShopperCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIView *view = [UIView new];
    [self.contentView addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.bottom.offset=-10;
    }];
    self.contentView.backgroundColor = BACK_COLOR;
    
    
    UIImageView *iconImgView = [UIImageView new];
    [self.contentView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=10;
        make.top.offset=10;
        make.width.offset=70;
        make.height.offset=70;
    }];
    self.iconImgVew = iconImgView;
    
    UILabel *statusLab = [[UILabel alloc]init];
    statusLab.text = NSLocalizedString(@"打烊了", nil);
    statusLab.backgroundColor = HEX(@"000000", 0.5);
    statusLab.font = FONT(13);
    statusLab.textColor = [UIColor whiteColor];
    statusLab.textAlignment = NSTextAlignmentCenter;
    statusLab.hidden = YES;
    [iconImgView addSubview:statusLab];
    [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.right.offset=-0;
        make.bottom.offset=-0;
        make.height.offset=20;
    }];
    self.statusLabel = statusLab;
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset=10;
        make.top.offset=10;
//        make.right.offset = -70;
        make.height.offset=20;
    }];
    titleLab.font = FONT(14);
    titleLab.textColor = HEX(@"222222", 1.0);
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLab = titleLab;
    
    UIView *starView = [StarView addEvaluateViewWithStarNO:0.0 withStarSize:10 withBackViewFrame:CGRectMake(90, 35, 60, 20)];
    [self.contentView addSubview:starView];
    starView.centerY = 45;
    self.starView = starView;
    
    UILabel *scoreLab = [UILabel new];
    [self.contentView addSubview:scoreLab];
    [scoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=155;
        make.centerY.equalTo(iconImgView.mas_centerY).offset=0;
        make.height.offset=20;
    }];
    scoreLab.font = FONT(11);
    scoreLab.textColor = HEX(@"999999", 1.0);
    self.scoreLab = scoreLab;
    
    UILabel *countLab = [UILabel new];
    [self.contentView addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scoreLab.mas_right).offset=10;
        make.centerY.equalTo(iconImgView.mas_centerY).offset=0;
        make.height.offset=20;
    }];
    countLab.font = FONT(11);
    countLab.textColor = HEX(@"999999", 1.0);
    self.countLab = countLab;
    
    UILabel *timeLab = [UILabel new];
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(iconImgView.mas_centerY).offset=0;
        make.width.offset=60;
        make.height.offset=15;
    }];
    timeLab.layer.borderColor=THEME_COLOR.CGColor;
    timeLab.layer.borderWidth=0.5;
    timeLab.font = FONT(11);
    self.timeLab = timeLab;
    
    UILabel *sendTypeLab = [UILabel new];
    [self.contentView addSubview:sendTypeLab];
    [sendTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.bottom.equalTo(timeLab.mas_top).offset=0;
        make.width.offset=60;
        make.height.offset=15;
    }];
    sendTypeLab.textColor = [UIColor whiteColor];
    sendTypeLab.font = FONT(11);
    sendTypeLab.text = NSLocalizedString(@"平台专送", nil);
    sendTypeLab.textAlignment = NSTextAlignmentCenter;
    sendTypeLab.backgroundColor = THEME_COLOR;
    sendTypeLab.hidden = YES;
    self.sendTypeLab = sendTypeLab;
    
    UILabel *sendPriceLab = [UILabel new];
    [self.contentView addSubview:sendPriceLab];
    [sendPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset=10;
        make.bottom.equalTo(iconImgView.mas_bottom).offset=0;
        make.height.offset=20;
    }];
    sendPriceLab.font = FONT(12);
    sendPriceLab.textColor = HEX(@"666666", 1.0);
    self.sendPriceLab = sendPriceLab;
    
    UILabel *distanceLab = [UILabel new];
    [self.contentView addSubview:distanceLab];
    [distanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(sendPriceLab.mas_centerY).offset=0;
        make.height.offset=20;
        make.width.offset = 60;
    }];
    distanceLab.textAlignment = NSTextAlignmentCenter;
    distanceLab.font = FONT(12);
    distanceLab.textColor = HEX(@"999999", 1.0);
    self.distanceLab = distanceLab;
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=90;
        make.top.offset=89;
        make.right.offset=-10;
        make.height.offset=1;
    }];
    lineView.backgroundColor=LINE_COLOR;
    self.lineView = lineView;
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.contentView addSubview:tableView];
    tableView.backgroundColor= [UIColor whiteColor];
    tableView.showsVerticalScrollIndicator=NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView=tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=90;
        make.top.equalTo(lineView.mas_bottom).offset=0;
        make.width.offset=WIDTH-90;
        make.bottom.offset= -10;
    }];

    self.clipsToBounds = YES;
}

-(void)reloadCellWithModel:(WaiMaiShopperModel *)model isFliterList:(BOOL)is_fliter{
    _model = model;
    NSString *url = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.logo];
    [self.iconImgVew sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:IMAGE(@"defaultimg")];
    self.titleLab.text = model.title;
    
    if (self.starView) {
        [self.starView removeFromSuperview];
        UIView *starView = [StarView addEvaluateViewWithStarNO:[model.score floatValue] withStarSize:10 withBackViewFrame:CGRectMake(90, 30, 80, 20)];
        starView.centerY = 45;
        [self.contentView addSubview:starView];
        self.starView = starView;
    }
    
    self.scoreLab.text = [NSString stringWithFormat:NSLocalizedString(@"%.1f分", nil),[model.score floatValue]];
    if (self.isHomePage) {
          self.countLab.text = [NSString stringWithFormat:NSLocalizedString(@"人均:¥%@", nil),model.avg_amount];
    }else{

        if ([model.yysj_status isEqualToString:@"0"]) {
            self.statusLabel.hidden = NO;
            self.statusLabel.text = NSLocalizedString(@"打烊中", nil);
        }else if ([model.yy_status isEqualToString:@"2"]) {
            self.statusLabel.hidden = NO;
            self.statusLabel.text = NSLocalizedString(@"繁忙中", nil);
        }else{
            self.statusLabel.hidden = YES;
        }
        
        self.countLab.text = [NSString stringWithFormat:NSLocalizedString(@"月售%@份", nil),model.orders];
    }
    if(is_fliter){
        
        self.sendPriceLab.text = [NSString stringWithFormat:@"%@ %@ %@",model.shop_cate_title,model.business_name.length?@"|":@"",model.business_name];

    }else{
        if ([model.freight_price floatValue] == 0) {
            self.sendPriceLab.text = [NSString stringWithFormat:NSLocalizedString(@"起送¥%@ | 免配送费", nil),model.min_amount];
        }else{
            self.sendPriceLab.text = [NSString stringWithFormat:NSLocalizedString(@"起送¥%@ | 配送¥%@", nil),model.min_amount,model.freight_price];
        }
    }
   
    self.distanceLab.text = model.juli_label;
    if (model.pei_type == 1) {
        self.sendTypeLab.hidden = NO;
    }else{
        self.sendTypeLab.hidden = YES;
    }

    NSString *str = [NSString stringWithFormat:@"⚡️%@",model.pei_time_lable];
    NSAttributedString * attStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:THEME_COLOR}];
    self.timeLab.attributedText = attStr;
    self.timeLab.textAlignment = NSTextAlignmentCenter;

    if (is_fliter) {
        self.collectionView.hidden = NO;
        NSInteger count = model.subtitle.count;
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 20 * count;
        }];
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -(20 * count + 5 + 10);
        }];
        [self.collectionView reloadData];
        self.timeLab.hidden = YES;
        self.sendTypeLab.hidden = YES;
    }else{
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -70;
        }];
        self.timeLab.hidden = NO;
        _collectionView.hidden = YES;
    }
    
    self.youhuiArr = model.activity_list;

    self.lineView.hidden = model.activity_list.count == 0;
    self.clipsToBounds = YES;
    [self.tableView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.youhuiArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"ShopYouHuiCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        YFTypeBtn *btn = [YFTypeBtn new];
//        [cell addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.offset=0;
//            make.centerY.offset=0;
//            make.height.offset=20;
//        }];
//        btn.titleLabel.font = FONT(11);
//        [btn setTitleColor:HEX(@"666666", 1.0) forState:UIControlStateNormal];
//        btn.tag = 200;
//        btn.btnType = LeftImage;
//        btn.titleMargin = 5;
        
        UILabel *kindLab = [UILabel new];
        [cell addSubview:kindLab];
        [kindLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=0;
            make.centerY.offset=0;
            make.height.offset=15;
            make.width.offset=15;
        }];
        kindLab.textColor = [UIColor whiteColor];
        kindLab.font = FONT(12);
        kindLab.tag = 200;
        kindLab.textAlignment = NSTextAlignmentCenter;
        kindLab.layer.cornerRadius=6;
        kindLab.clipsToBounds=YES;
        
        UILabel *desLab = [UILabel new];
        [cell addSubview:desLab];
        [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=20;
            make.centerY.offset=0;
            make.height.offset=20;
            make.right.offset = -70;
        }];
        desLab.textColor = HEX(@"666666", 1.0);
        desLab.font = FONT(11);
        desLab.tag = 201;
        
        YFTypeBtn *youhuiCountBtn = [YFTypeBtn new];
        [cell addSubview:youhuiCountBtn];
        [youhuiCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset=-20;
            make.centerY.offset=0;
            make.height.offset=20;
        }];
        youhuiCountBtn.tag = 202;
        youhuiCountBtn.titleLabel.font = FONT(11);
        [youhuiCountBtn setTitleColor:HEX(@"666666", 1.0) forState:UIControlStateNormal];
        youhuiCountBtn.btnType = RightImage;
        youhuiCountBtn.imageMargin = 5;
        [youhuiCountBtn setImage:IMAGE(@"icon-arrowD") forState:UIControlStateNormal];
        [youhuiCountBtn setImage:IMAGE(@"icon-arrowUp") forState:UIControlStateSelected];
        [youhuiCountBtn addTarget:self action:@selector(showMoreYouhui:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
//    YFTypeBtn *btn = (YFTypeBtn *)[cell viewWithTag:200];
    UILabel *kindLab = (UILabel *)[cell viewWithTag:200];
    UILabel *desLab = (UILabel *)[cell viewWithTag:201];
    NSDictionary *dic = self.youhuiArr[indexPath.row];
    
    kindLab.backgroundColor = HEX([dic[@"color"] isEqualToString:@"FFFFFF"]? @"fa6720":dic[@"color"], 1.0);
    kindLab.text = dic[@"title"];
    desLab.text = dic[@"activity"];
    
    YFTypeBtn *youhuiCountBtn = (YFTypeBtn *)[cell viewWithTag:202];
    if (self.youhuiArr.count <= 3 || indexPath.row != 0) { // 复用导致显示的位置不对
        youhuiCountBtn.hidden = YES;
    }else{
        youhuiCountBtn.hidden = NO;
    }
    youhuiCountBtn.selected = _model.showYouHui;
    [youhuiCountBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"%ld个活动", nil),self.youhuiArr.count] forState:UIControlStateNormal];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.myBlock) {
        self.myBlock(self.index);
    }
}
// 点击活动
-(void)showMoreYouhui:(YFTypeBtn *)btn{
    btn.selected = !btn.isSelected;
    _model.showYouHui = btn.selected;
    if (self.reloadYouhuiCell) {
        self.reloadYouhuiCell();
    }
}

#pragma mark ======UICollectionView=======
-(UICollectionView *)collectionView{
    
    if (_collectionView==nil) {
        YFCollectionViewAutoFlowLayout * flowLayout=[[YFCollectionViewAutoFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.delegate = self;
        flowLayout.interSpace = 0;
        flowLayout.numberOfItemsInLine = 8;
        flowLayout.numberOfLines = 1;
        flowLayout.itemSizeType = ItemSizeEqualAll;
        
        UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,0,0,20) collectionViewLayout:flowLayout];
        collectionView.dataSource=self;
        collectionView.delegate=self;
        collectionView.backgroundColor=[UIColor whiteColor];
        [collectionView registerClass:[ActivityImgCell class] forCellWithReuseIdentifier:@"ActivityImgCell"];
        
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.userInteractionEnabled = NO;
        _collectionView = collectionView;
        [self.contentView addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset=-10;
            make.top.offset=10;
            make.width.offset = 0;
            make.height.offset=20;
        }];

    }
    return _collectionView;
}

#pragma mark --UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(20, 20);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _model.subtitle.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ActivityImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityImgCell" forIndexPath:indexPath];
    [cell reloadCellWith:_model.subtitle[indexPath.row]];
    
    return cell;
}

@end
