//
//  EvaluationStar.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "EvaluationStar.h"

@interface EvaluationStar ()
@property (nonatomic,strong)NSMutableArray *starArr;
@end

@implementation EvaluationStar

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStarView:)];
        [self addGestureRecognizer:tap];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panStarView:)];
        [self addGestureRecognizer:pan];
        for(int i = 0 ; i < 5;i ++){
            UIImageView *img = [[UIImageView alloc] init];
            img.image = [UIImage imageNamed:@"big-star_default"];
            img.frame = CGRectMake(5 + i * (20), 2.5, 15, 15);
            [self addSubview:img];
            [self.starArr addObject:img];
        }
        self.starNumber = 0;
    }
    return self;
}
- (NSMutableArray *)starArr{
    if(_starArr == nil){
        _starArr = @[].mutableCopy;
    }
    return _starArr;
}
- (void)tapStarView:(UITapGestureRecognizer *)tap{
    self.starNumber = 0;
    CGPoint touchPoint = [tap locationInView:self];
    for(int i = 0 ; i < 5; i++){
        UIImageView *img = self.starArr[i];
        if(img.frame.origin.x < touchPoint.x){
            img.image = [UIImage imageNamed:@"big-star"];
            self.starNumber = i + 1;
        }else{
            img.image = [UIImage imageNamed:@"big-star_default"];
        }
    }
}
- (void)panStarView:(UIPanGestureRecognizer *)pan{
    self.starNumber = 0;
    CGPoint touchPoint = [pan locationInView:self];
    for(int i = 0 ; i < 5; i++){
        UIImageView *img = self.starArr[i];
        if(img.frame.origin.x < touchPoint.x){
            img.image = [UIImage imageNamed:@"big-star"];
            self.starNumber = i + 1;
        }else{
            img.image = [UIImage imageNamed:@"big-star_default"];
        }
    }
}


@end
