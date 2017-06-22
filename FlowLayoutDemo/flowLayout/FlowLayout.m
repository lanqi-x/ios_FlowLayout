//
//  FlowLayout.m
//  customTitleView
//
//  Created by BlueK on 17/6/8.
//  Copyright © 2017年 BlueK. All rights reserved.
//

#import "FlowLayout.h"

@implementation FlowLayout

@synthesize subViewList=_subViewList;
@synthesize rowList=_rowList;
@synthesize rowHightList=_rowHightList;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (instancetype)initWithSubViewList:(NSMutableArray *)subViewList {
    if (self = [super init]) {
        
        for (UIView *item in subViewList) {
            [self addSubview:item];
        }
    }
    return self;
}


-(void)setDelegate:(id<FlowLayoutDelegate>)delegate{
    _delegate=delegate;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setSubViewFromDelegate];
}
//通过协议添加view
-(void)setSubViewFromDelegate{
    if ([self hasRealizeDelegate]) {
        for (int i=0; i<[self.delegate numberOfSectionsInFlowLayout:self]; i++) {
            
            [self addSubview:[self.delegate flowLayout:self viewAtIndex:i itemView:nil]];
            
        }
    }
}
//是否有实现协议
-(BOOL)hasRealizeDelegate{
    return self.delegate!=nil && [self.delegate respondsToSelector:@selector(numberOfSectionsInFlowLayout:)]
    &&[self.delegate respondsToSelector:@selector(flowLayout:viewAtIndex:itemView:)];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
//通过xib或storyboard初始化
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)addSubview:(UIView *)view{
    [self.subViewList addObject:view];
    [super addSubview:view];
}
//初始化参数
-(void)commonInit{
    _horizontalSpace=10.0;
    _verticalSpace=10.0;
    _maxLine=INT_MAX;
    _fastenHeight=true;
    _lastShowIndex=-1;
}

-(void)sizeToFit{
    [super sizeToFit];
    self.fastenHeight=false;
}

-(void)setMaxLine:(int)maxLine{
    if (maxLine<1) {
        maxLine=1;
    }
    _maxLine=maxLine;
    [self setNeedsLayout];
}

-(void) setVerticalSpace:(CGFloat)verticalSpace{
    _verticalSpace=verticalSpace;
    [self setNeedsLayout];
}

-(void) setHorizontalSpace:(CGFloat)horizontalSpace{
    _horizontalSpace=horizontalSpace;
    [self setNeedsLayout];
}

-(void)setSubViewList:(NSMutableArray *)subViewList{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (UIView *item in subViewList) {
        [self addSubview:item];
    }
}

-(NSMutableArray *)subViewList{
    if (_subViewList==nil) {
        _subViewList=[NSMutableArray array];
    }
    return _subViewList;
}

-(NSMutableArray*) rowList{
    if (_rowList==nil) {
        _rowList=[NSMutableArray array];
    }
    return _rowList;
}
-(NSMutableArray*) rowHightList{
    if (_rowHightList==nil) {
        _rowHightList=[NSMutableArray array];
    }
    return _rowHightList;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _lastShowIndex=-1;
    if (self.subViewList.count>0) {
        
        //清空所有值，重新计算
        [self.rowHightList removeAllObjects];
        [self.rowList removeAllObjects];
        
        //获取第一个view
        NSMutableArray *lineList=[NSMutableArray array];
        UIView* firstView=self.subViewList[0];
        CGFloat sumWidth=self.horizontalSpace+firstView.frame.size.width;
        CGFloat height=firstView.frame.size.height;
        CGFloat flowWidth=self.frame.size.width;
        
        
        [lineList addObject:firstView];
        
        //计算每行放哪些View
        for (int i=1; i<self.subViewList.count; i++) {
            
            UIView* view=self.subViewList[i];
            sumWidth=sumWidth+view.frame.size.width+self.horizontalSpace;
            
            if (sumWidth >= flowWidth) {
                
                //一行放不下了，记录为一行
                [self saveLine:lineList lineHeight:height];
                
                //重新创建一行
                lineList=[NSMutableArray array];
                [lineList addObject:view];
                height=view.frame.size.height;
                sumWidth=self.horizontalSpace+view.frame.size.width;
                
            }else{
                //一行还够放
                [lineList addObject:view];
                if (view.frame.size.height>height) {
                    height=view.frame.size.height;
                }
            }
            //如果这是最后一个view了，不管够不够一行，都记为一行
            if (i==self.subViewList.count-1) {
                [self saveLine:lineList lineHeight:height];
            }
        }
        //摆放subView
        CGFloat y=self.verticalSpace;
        
        //一行一行取出
        for (int i=0;i<self.rowList.count;i++) {
            lineList=self.rowList[i];
            
            CGFloat x=self.horizontalSpace;
            //获取这一行的高度
            CGFloat rowHeight=[self.rowHightList[i] floatValue];
            
            if (i!=0) {
                y=y+[self.rowHightList[i-1] floatValue]+self.verticalSpace;
            }
            
            if ((self.fastenHeight && y+[self.rowHightList[i] floatValue]>=self.frame.size.height)
                || i>=self.maxLine) {
                [self dontShowLine:i];
                break;
            }
            
            //摆放每一行的subView
            for (UIView *item in lineList){
                _lastShowIndex++;
                [self setX:x changeView:item];
                item.hidden=false;
                if (item.frame.size.height<rowHeight) {
                    [self setY:y+((rowHeight-item.frame.size.height)/2.0) changeView:item];
                }else{
                    [self setY:y changeView:item];
                }
                
                x=x+item.frame.size.width+self.horizontalSpace;
                
            }
            
        }
        
        if(!self.fastenHeight && self.lastShowIndex!=-1){
            UIView *lastItem = self.subViewList[self.lastShowIndex];
            CGRect rect=self.frame;
            //计算flowLayout最终的高度
            rect.size.height=CGRectGetMaxY(lastItem.frame) + self.verticalSpace;
            self.frame = rect;
////            修改约束，保证兄弟或父子控件的约束更新
            NSArray* constrains = self.constraints;
            for (NSLayoutConstraint* constraint in constrains) {
                if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                    [self removeConstraint:constraint];
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:rect.size.height]];
                }
            }
            
            
        }
//        self.backgroundColor=[UIColor greenColor];
        
    }
}

-(void)setFastenHeight:(bool)fastenHeight{
    _fastenHeight=fastenHeight;
    [self setNeedsLayout];
}

-(void)dontShowLine:(int) starIndex{
    NSMutableArray* lineList;
    for (starIndex=starIndex; starIndex<self.rowList.count; starIndex++) {
        lineList=self.rowList[starIndex];
        for (UIView *view in lineList) {
            view.hidden=true;
        }
    }
}

-(void)saveLine:(NSMutableArray *)lineList lineHeight:(CGFloat) height{
    [self.rowList addObject:lineList];
    NSNumber *num = [NSNumber numberWithFloat:height];
    [self.rowHightList addObject:num];
}

-(void)reloadData{
    if (self.delegate!=nil) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.subViewList removeAllObjects];
        [self setSubViewFromDelegate];
    }
}

-(void)insertItemAtIndex:(NSInteger)index{
    if ([self hasRealizeDelegate]) {
        
        NSAssert(!(index>[self.delegate numberOfSectionsInFlowLayout:self]-1), @"角标越界");
        
        UIView *item=[self.delegate flowLayout:self viewAtIndex:index itemView:nil];
        [self.subViewList insertObject:item atIndex:index];
        [super addSubview:item];
        
    }
}

-(void)removeItemAtIndex:(NSInteger)index{
    if ([self hasRealizeDelegate]) {
        
        NSAssert(!(index>[self.delegate numberOfSectionsInFlowLayout:self]), @"角标越界");
        
        UIView *item=[self.subViewList objectAtIndex:index];
        [self.subViewList removeObject:item];
        [item removeFromSuperview];
    }
    
}

-(void)changeItemAtIndex:(NSInteger)index{
    if ([self hasRealizeDelegate]) {
        
        NSAssert(!(index>[self.delegate numberOfSectionsInFlowLayout:self]-1), @"角标越界");
        
        UIView *item=[self.subViewList objectAtIndex:index];
        [self.delegate flowLayout:self viewAtIndex:index itemView:item];
        
    }
}

- (void)setX:(CGFloat)x changeView:(UIView*) view{
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}

- (void)setY:(CGFloat)y changeView:(UIView*) view {
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}


- (void)setWidth:(CGFloat)width changeView:(UIView*) view {
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}


- (void)setHeight:(CGFloat)height changeView:(UIView*) view{
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
}

@end
