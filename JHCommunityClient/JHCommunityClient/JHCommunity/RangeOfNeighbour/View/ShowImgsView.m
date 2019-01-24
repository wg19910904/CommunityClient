//
//  ShowImgsView.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "ShowImgsView.h"
#import <UIImageView+WebCache.h>
#import "DisplayImageInView.h"

#define img_tag  200
#define img_margin 15

@interface ShowImgsView()
@property(nonatomic,strong)DisplayImageInView *displayView;
@end

@implementation ShowImgsView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    CGFloat margin=img_margin;
    CGFloat width=(self.width-margin*4)/3.0;
    
    for (int i=0; i<6; i++) {
        
        int x=i%3;
        int y=i/3;
        
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:FRAME(margin+(width+margin)*x, margin+(margin+width)*y, width, width)];
        imgView.tag=img_tag+i;
        imgView.hidden=YES;
        [self addSubview:imgView];
        imgView.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImg:)];
        [imgView addGestureRecognizer:tap];
        
    }

}

-(void)clickImg:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag-img_tag+1;
    NSMutableArray *arr=[NSMutableArray array];
    for (NSString *str in self.imgsArr) {
        NSString *url=str;
        if (![str hasPrefix:@"http"]) {
            url=[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,str];
        }
        [arr addObject:url];
    }
    [self.displayView showInViewWithImageUrlArray:[arr copy] withIndex:index withBlock:^{
        [self.displayView removeFromSuperview];
        _displayView=nil;
    }];
}

-(void)setImgsArr:(NSArray *)imgsArr{
    _imgsArr=imgsArr;
//    if (imgsArr.count==0)  {
////        self.height=0;
//    }else{
//        int count=(int)imgsArr.count/4+1;
//        float height= (WIDTH-img_margin*4)/3.0 * count +img_margin*(count+1);
//        self.height=height;
//    }
    [self setImgViews];
}

-(void)setImgViews{
    
    for (int i=0; i<6; i++) {
        UIImageView *imgView=[self viewWithTag:img_tag+i];
        if (self.imgsArr.count==0) {
            imgView.hidden=YES;
            break;
        }
        if (i<=self.imgsArr.count-1) {
            imgView.hidden=NO;
            CGFloat width=(self.width-img_margin*4)/3.0;
            imgView.bounds=CGRectMake(0, 0, width, width);
            NSString *url=self.imgsArr[i];
            if (![url containsString:@"http"]) {
                url=[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,url];
            }
            [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:IMAGE(@"chaoshi290x290")];
        }else {
            imgView.hidden=YES;
            imgView.bounds=CGRectMake(0, 0, 0, 0);
        }
    }
}

-(DisplayImageInView *)displayView{
    if (_displayView==nil) {
        _displayView=[[DisplayImageInView alloc] init];
    }
    return _displayView;
}


@end