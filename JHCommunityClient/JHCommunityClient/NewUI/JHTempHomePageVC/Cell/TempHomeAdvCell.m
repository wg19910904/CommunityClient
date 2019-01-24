//
//  TempHomeAdvCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 17/3/25.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "TempHomeAdvCell.h"
#import <UIImageView+WebCache.h>
#import "JHTempAdvModel.h"
@interface TempHomeAdvCell(){
    NSMutableArray *imgVArr;//保存图片的
}
@property(nonatomic,strong)UIView *line_bootom;//底部的线
@property(nonatomic,strong)UIView *line_right;//右边的线
@end
@implementation TempHomeAdvCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        imgVArr = @[].mutableCopy;
        //底部的线
        [self line_bootom];
        //右边的线
        [self line_right];
    }
    return self;
}
//底部的线
-(UIView *)line_bootom{
    if (!_line_bootom) {
        _line_bootom = [[UIView alloc]init];
        _line_bootom.backgroundColor = HEX(@"dedede", 1);
        [self addSubview:_line_bootom];
        [_line_bootom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset = -90*(WIDTH/375);
            make.left.offset = 0;
            make.right.offset = -0;
            make.height.offset = 0.5;
        }];
    }
    return _line_bootom;
}
//右边的线
-(UIView *)line_right{
    if (!_line_right) {
        _line_right = [[UIView alloc]init];
        _line_right.backgroundColor = HEX(@"dedede", 1);
        [self addSubview:_line_right];
        [_line_right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset = -0;
            make.top.offset = 0;
            make.left.offset = WIDTH/2-0.5;
            make.width.offset = 0.5;
        }];

    }
    return _line_right;
}
-(void)setArray:(NSArray *)array{
    _array = array;
    for (UIImageView *imgV in imgVArr ) {
        [imgV removeFromSuperview];
    }
    [self addImgV];
}
//添加四张图片
-(void)addImgV{
    for (int i = 0 ; i < self.array.count; i ++) {
        JHTempAdvModel *model = self.array[i];
        UIImageView *imgV = [[UIImageView alloc]init];
        imgV.userInteractionEnabled = YES;
        imgV.tag = i;
        [self addSubview:imgV];
        [imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.thumb]] placeholderImage:IMAGE(@"tgtopdeafault")];
        [imgVArr addObject:imgV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImg:)];
        [imgV addGestureRecognizer:tap];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = (WIDTH/2)*(i%2);
            make.top.offset = 90*(i/2)*(WIDTH/375);
            make.width.offset = (WIDTH-1)/2;
            make.height.offset = 89.5*(WIDTH/375);
        }];
    }
}
-(void)clickImg:(UITapGestureRecognizer *)tap{
    if (self.clickAdvBlock) {
        self.clickAdvBlock(tap.view.tag);
    }
}
@end
