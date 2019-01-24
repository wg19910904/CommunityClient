//
//  JHUPKeepOrderDetailCellSix.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/3/17.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHUPKeepOrderDetailCellSix.h"
#import "MyTapGestureRecognizer.h"
@implementation JHUPKeepOrderDetailCellSix
{
    UIView * view;//蒙版
    UILabel * label_image;//显示查看图片的时候的选中张数
    UIScrollView * scrollV;//创建滑动视图
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.imageV_One == nil) {
        self.imageV_One = [[UIImageView alloc]init];
        self.imageV_One.frame = FRAME((WIDTH-320)/5, 10, 80, 80);
        self.imageV_One.image = [UIImage imageNamed:@"pic"];
        [self addSubview:self.imageV_One];
        MyTapGestureRecognizer * tapGusture = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSeeImage:)];
        self.imageV_One.userInteractionEnabled = YES;
        tapGusture.tag = 1;
        [self.imageV_One addGestureRecognizer:tapGusture];
    }
    if (self.imageV_Two == nil) {
        self.imageV_Two = [[UIImageView alloc]init];
        self.imageV_Two.frame = FRAME((WIDTH-320)/5*2+80, 10, 80, 80);
        self.imageV_Two.image = [UIImage imageNamed:@"pic"];
        [self addSubview:self.imageV_Two];
        MyTapGestureRecognizer * tapGusture1 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSeeImage:)];
        self.imageV_Two.userInteractionEnabled = YES;
        tapGusture1.tag = 2;
        [self.imageV_Two addGestureRecognizer:tapGusture1];
    }
    if (self.imageV_Three == nil) {
        self.imageV_Three = [[UIImageView alloc]init];
        self.imageV_Three.frame = FRAME((WIDTH-320)/5*3+160, 10, 80, 80);
        self.imageV_Three.image = [UIImage imageNamed:@"pic"];
        [self addSubview:self.imageV_Three];
        MyTapGestureRecognizer * tapGusture2 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSeeImage:)];
        self.imageV_Three.userInteractionEnabled = YES;
        tapGusture2.tag = 3;
        [self.imageV_Three addGestureRecognizer:tapGusture2];
    }
    if (self.imageV_Four == nil) {
        self.imageV_Four = [[UIImageView alloc]init];
        self.imageV_Four.frame = FRAME((WIDTH-320)/5*4+240, 10, 80, 80);
        self.imageV_Four.image = [UIImage imageNamed:@"pic"];
        [self addSubview:self.imageV_Four];
        MyTapGestureRecognizer * tapGusture3 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSeeImage:)];
        self.imageV_Four.userInteractionEnabled = YES;
        tapGusture3.tag = 4;
        [self.imageV_Four addGestureRecognizer:tapGusture3];
    }
    
    
}
#pragma mark - 这是点击图片查看大图的方法
-(void)clickToSeeImage:(MyTapGestureRecognizer * )tap{
    [self creatImageMengBanWithImageArray:@[@"",@"",@"",@""] withSelectedNum:tap.tag];
}
#pragma mark - 创建查看大图的view
-(void)creatImageMengBanWithImageArray:(NSArray *)imageArray withSelectedNum:(NSInteger)a{
    if (view == nil) {
        view = [[UIView alloc]init];
        view.frame = FRAME(0, 0, WIDTH, HEIGHT);
        view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:view];
        UITapGestureRecognizer * tap_remove = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove_image:)];
        [view addGestureRecognizer:tap_remove];
        label_image = [[UILabel alloc]init];
        label_image.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
        label_image.bounds = CGRectMake(0, 0, 50, 30);
        label_image.center = CGPointMake(view.center.x,view.center.y - HEIGHT/2.5 + 64);
        label_image.text = [NSString stringWithFormat:@"%ld/%ld",a,imageArray.count];
        label_image.textAlignment = NSTextAlignmentCenter;
        label_image.textColor  = [UIColor whiteColor];
        [view addSubview:label_image];
        scrollV = [[UIScrollView alloc]init];
        scrollV.bounds = CGRectMake(0, 0,WIDTH, HEIGHT/2.5);
        scrollV.center = view.center;
        scrollV.contentSize = CGSizeMake(WIDTH*imageArray.count,HEIGHT/2.5);
        [scrollV setContentOffset:CGPointMake((a - 1)*WIDTH, 0)];
        scrollV.tag = imageArray.count;
        scrollV.showsHorizontalScrollIndicator = NO;
        scrollV.showsVerticalScrollIndicator = NO;
        [view addSubview:scrollV];
        //设置滑动视图整页滑动
        scrollV.pagingEnabled = YES;
        //滑动到头／尾的时候，不能滑动
        scrollV.bounces = NO;
        scrollV.delegate = self;
        scrollV.backgroundColor = [UIColor clearColor];
        scrollV.showsHorizontalScrollIndicator = NO;
        scrollV.showsVerticalScrollIndicator = NO;
        for (int i = 0; i < imageArray.count; i++) {
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*WIDTH, 0, WIDTH, HEIGHT/2.5)];
            //NSString * String = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,imageArray[i]];
            //[imageView sd_setImageWithURL:[NSURL URLWithString:String] placeholderImage:[UIImage imageNamed:@"picNone@2x.png"]];
            imageView.image = [UIImage imageNamed:@"pic"];
            [scrollV addSubview:imageView];
        }
        
    }
}
#pragma mark - 这是移除蒙版的手势
-(void)remove_image:(UITapGestureRecognizer *)sender{
    [view removeFromSuperview];
    view = nil;
    [scrollV removeFromSuperview];
    scrollV = nil;
    [label_image removeFromSuperview];
    label_image = nil;
}
#pragma mark - 这是滑动视图的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int  a = scrollView.contentOffset.x/WIDTH + 1;
    label_image.text = [NSString stringWithFormat:@"%d/%ld",a,scrollView.tag];
}
@end
