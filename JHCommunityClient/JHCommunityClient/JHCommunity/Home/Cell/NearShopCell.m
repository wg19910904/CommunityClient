//
//  NearShopCell.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/6.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "NearShopCell.h"
#import "XHStarView.h"
#import <UIImageView+WebCache.h>

@interface NearShopCell ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)UITableView *youHuiTable;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,weak)UIImageView *leftIV;
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)XHStarView *starView;
@property(nonatomic,weak)UILabel *numLabel;
@property(nonatomic,weak)UILabel *infoLabel;
@property(nonatomic,weak)UILabel *distanceLab;
@end

@implementation NearShopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加子控件
        [self createSubViews];
    }
    return self;
}

#pragma mark - 添加子控件
- (void)createSubViews
{
    UIImageView *leftIV=[UIImageView new];
    self.leftIV =leftIV;
    UILabel *titleLabel=[UILabel new];
    self.titleLabel = titleLabel;
    UILabel *numLabel=[UILabel new];
    self.numLabel = numLabel;
    UILabel *infoLabel=[UILabel new];
    self.infoLabel = infoLabel;

    [self addSubview:self.leftIV];
    [self addSubview:self.titleLabel];
    [self addSubview:self.numLabel];
    [self addSubview:self.infoLabel];

    self.leftIV.frame = FRAME(5, 12.5, 55, 55);
    self.titleLabel.frame = FRAME(70, 5, WIDTH - 80, 20);
    self.titleLabel.font = FONT(15);
    self.titleLabel.textColor = HEX(@"333333", 1.0f);
    
    XHStarView *starView= [XHStarView addEvaluateViewWithStarNO:0 withFrame:FRAME(70,34, 70, 11)];
    self.starView =starView;
    [self addSubview:starView];
    
    self.numLabel.frame = FRAME(150, 30, 80, 20);
    self.numLabel.font = FONT(11);
    self.numLabel.textColor = HEX(@"999999", 1.0f);
    
    self.infoLabel.frame = FRAME(70, 53, WIDTH, 20);
    self.infoLabel.textAlignment = NSTextAlignmentLeft;
    self.infoLabel.font = FONT(11);
    self.infoLabel.textColor = HEX(@"999999", 1.0f);
    
    UIView *distanceView = [[UIView alloc] initWithFrame:FRAME(WIDTH - 75, 33, 70, 12)];
    UIImageView *zuobiaoIV = [[UIImageView alloc] initWithFrame:FRAME(0, 0.5, 8, 11)];
    zuobiaoIV.image = IMAGE(@"zuobaio2");
    UILabel *distanceLab=[[UILabel alloc] initWithFrame:FRAME(13, 0, 57, 12)];
    self.distanceLab =distanceLab;
    distanceLab.font = FONT(12);
    distanceLab.textColor = [UIColor lightGrayColor];
    distanceLab.textAlignment = NSTextAlignmentLeft;
    [distanceView addSubview:zuobiaoIV];
    [distanceView addSubview:distanceLab];
    [self addSubview:distanceView];
    
    
    UITableView *youhuiTab=[[UITableView alloc] initWithFrame:CGRectMake(65, 80, WIDTH-65, 0)];
    youhuiTab.delegate=self;
    youhuiTab.dataSource=self;
    [self.contentView addSubview:youhuiTab];
    youhuiTab.separatorStyle=UITableViewCellSeparatorStyleNone;
    youhuiTab.showsVerticalScrollIndicator=NO;
    youhuiTab.scrollEnabled=NO;
    youhuiTab.userInteractionEnabled=NO;
    self.youHuiTable=youhuiTab;
    [self addSubview:youhuiTab];
}

-(void)reloadCellWithModel:(NearShopModel *)shop{

    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:shop.logo]];
    [self.leftIV sd_setImageWithURL:url placeholderImage:IMAGE(@"shopDefault")];
    
    self.titleLabel.text = shop.title;

    self.starView.startNum=[shop.score floatValue];
    
    self.numLabel.text = [NSString stringWithFormat:NSLocalizedString(@"销量:%d", nil),shop.orders];
    NSString * pei;
    if ([shop.freight_price floatValue] <= 0) {
        pei = NSLocalizedString(@"免", nil);
    }else{
        pei = [NSString stringWithFormat:@"%.2f",[shop.freight_price floatValue]];
    }
    self.infoLabel.text = [NSString stringWithFormat:@"¥ %.2f起送 | ¥ %@配送费 | %@分钟送达",shop.min_amount,pei,shop.pei_time];
    
    //距离标签
    self.distanceLab.text =shop.juli_label;
    self.youHuiTable.height=30*shop.youhuiArr.count;
    self.dataSource=shop.youhuiArr;
    [self.youHuiTable reloadData];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"NearShopYouHuiCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        UILabel *kindLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 7.5, 15, 15)];
        [cell.contentView addSubview:kindLab];
        kindLab.textColor=[UIColor whiteColor];
        kindLab.font=FONT(12);
        kindLab.textAlignment=NSTextAlignmentCenter;
        kindLab.tag=100;
        
        UILabel *desLab=[[UILabel alloc] initWithFrame:CGRectMake(30, 7.5, cell.width-30, 15)];
        [cell.contentView addSubview:desLab];
        desLab.textColor=HEX(@"999999", 1.0);
        desLab.font=FONT(12);
        desLab.tag=101;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    UILabel *kindLab=(UILabel *)[cell viewWithTag:100];
    UILabel *desLab=(UILabel *)[cell viewWithTag:101];
    
    NSDictionary *dic=self.dataSource[indexPath.row];
    kindLab.text=dic[@"title"];
    kindLab.backgroundColor=HEX(dic[@"color"], 1.0);
    desLab.text=dic[@"des"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

#pragma mark ======画虚线=======
- (void)drawRect:(CGRect)rect
{
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context,0.5);//线宽度
    CGContextSetStrokeColorWithColor(context,LINE_COLOR.CGColor);
    CGFloat lengths[] = {4,2};//先画4个点再画2个点
    CGContextSetLineDash(context,0, lengths,2);//注意2(count)的值等于lengths数组的长度
    CGContextMoveToPoint(context,65,80);
    CGContextAddLineToPoint(context,WIDTH,80);
    CGContextStrokePath(context);
    CGContextDrawPath(context, kCGPathEOFillStroke);
    
}

@end
