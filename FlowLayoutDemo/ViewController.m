//
//  ViewController.m
//  FlowLayoutDemo
//
//  Created by BlueK on 17/6/19.
//  Copyright © 2017年 Lanqi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet FlowLayout *flowmaxLinView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet FlowLayout *flowLayout3;

@property (weak, nonatomic) IBOutlet FlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *buttonList;
-(void)flowLayout3AddView;
-(void)add;
- (UIImage *)imageWithColor:(UIColor *)color;
@end

@implementation ViewController

- (NSMutableArray *)buttonList {
    if (_buttonList == nil) {
        _buttonList = [NSMutableArray array];
        for (int i = 0; i < 18; i++) {
            switch (i%10) {
                case 1:
                    [_buttonList addObject:[NSString stringWithFormat:@"adapter模式%d",i]];
                    break;
                case 2:
                    [_buttonList addObject:[NSString stringWithFormat:@"尝试的说%d",i]];
                    break;
                case 3:
                    [_buttonList addObject:[NSString stringWithFormat:@"音乐%d",i]];
                    break;
                default:
                    [_buttonList addObject:[NSString stringWithFormat:@"flowLayout%d",i]];
                    break;
            }
        }
    }
    return _buttonList;
}

-(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 charactersif ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appearsif ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [self.flowLayout setSubViewList:self.buttonList];
    //   7.0以上头部会有空白
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    self.flowLayout.fastenHeight=YES;
    self.flowmaxLinView.delegate= self;
    [self.flowmaxLinView setMaxLine:5];
    self.flowLayout.delegate= self;
    [self.flowLayout3 sizeToFit];
    [self flowLayout3AddView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGSize contentSize=self.scrollView.contentSize;
    contentSize.height=CGRectGetMaxY(self.flowLayout3.frame);
    self.scrollView.contentSize=contentSize;
}


-(void)flowLayout3AddView{
    UIButton *button;
    for (NSString* str in self.buttonList) {
        button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:15.0]; //设置矩形四个圆角半径
        //边框宽度
        [button.layer setBorderWidth:1.0];
        [button setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
        button.layer.borderColor=[self hexStringToColor:@"dedede"].CGColor;
        [button addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchDown];
        
        [button setTitle:str forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:14.0];
        [button sizeToFit];
        CGRect tem=button.frame;
        tem.size.width=tem.size.width+30.0;
        
        button.frame=tem;
        
        button.titleEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 15);
        [self.flowLayout3 addSubview:button];
    }
}


-(NSInteger)numberOfSectionsInFlowLayout:(FlowLayout *)flowLayout{
    return self.buttonList.count;
}

-(UIView *)flowLayout:(FlowLayout *)flowLayout viewAtIndex:(NSInteger)index itemView:(UIView*)itemView{
    UIButton *button;
    if (itemView==nil) {
        button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:15.0]; //设置矩形四个圆角半径
        //边框宽度
        [button.layer setBorderWidth:1.0];
        [button setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
        button.layer.borderColor=[self hexStringToColor:@"dedede"].CGColor;
        [button addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchDown];
        
    }else{
        button=(UIButton*)itemView;
    }
    [button setTitle:self.buttonList[index] forState:UIControlStateNormal];
    
    button.titleLabel.font=[UIFont systemFontOfSize:14.0];
    
    [button sizeToFit];
    
    CGRect tem=button.frame;
    tem.size.width=tem.size.width+30.0;
    
    button.frame=tem;
    
    button.titleEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 15);
    return button;
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 30.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)add{
    NSLog(@"123");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end

