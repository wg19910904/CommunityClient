//
//  TempHomeHeadlinesCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/12.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "TempHomeHeadlinesCell.h"
#import <UIImageView+WebCache.h>
#import "NewUpwardLunV.h"

@interface TempHomeHeadlinesCell()<UIScrollViewDelegate>{
NewUpwardLunV *apView;
    UIImageView *leftImgView;
}

@end


@implementation TempHomeHeadlinesCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    
    return self;
}
-(void)creatUI{
    self.backgroundColor = HEX(@"f5f5f5", 1);
   leftImgView = [[UIImageView alloc]init];
    [self addSubview:leftImgView];
    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset = 13;
        make.bottom.offset = -13;
        make.width.offset = 55;
    }];
//    leftImgView.image =PHAIMAGE;
    

}
-(void)setArr:(NSArray *)arr{
    [apView removeFromSuperview];
    apView = nil;
    /*使用API */
    if(arr.count>0){
        if(!apView){
    apView = [NewUpwardLunV adsPlayViewWithFrame:CGRectMake(80, 5,WIDTH - 80 , 60) imageGroup:arr];
     apView.animationDuration = 2.;
    apView.placeHoldImage = [UIImage imageNamed:@"Default-568h"];
    [self addSubview:apView];
    //这句可以在任何地方使用，异步下载并展示
    __weak typeof (self)welkself = self;
    [apView startWithTapActionBlock:^(NSInteger index) {
        if (welkself.clickBlock) {
            welkself.clickBlock(index);
        }
    }];
        }
        apView.array = arr;
    leftImgView.image =IMAGE(@"toutiao");
    }
}
@end
