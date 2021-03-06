//
//  ELTriggerAnalyzeFloatingView.m
//  Eleenoe
//
//  Created by FaceBook on 2019/3/31.
//  Copyright © 2019 FaceBook. All rights reserved.
//

#import "ELTriggerAnalyzeFloatingView.h"
#import "ELButtonExtention.h"
#import "ELSlideTabBar.h"
#import <KLCPopup.h>
@interface ELTriggerAnalyzeFloatingView()<ELSlideTabBarDelegate>
@property(nonatomic,strong) KLCPopup *popup;
@property(nonatomic,copy)void(^CompleteBlock)(ELBaseModel *model);
@property(nonatomic,strong) UIImageView *triggerImageView;
@property(nonatomic,strong) UIView *analyzeView;
@property(nonatomic,strong) ELButtonExtention *downloadButton;
@property(nonatomic,strong) UIButton *close;
@property(nonatomic,strong) ELSlideTabBar *sliderBar;
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) NSMutableArray *titles;
@end
@implementation ELTriggerAnalyzeFloatingView

+ (instancetype)showComplete:(void(^)(ELBaseModel *model))complete{
    
    ELTriggerAnalyzeFloatingView *view = [[ELTriggerAnalyzeFloatingView alloc] initWithFrame:CGRectZero];
    
    KLCPopup *popup = [KLCPopup popupWithContentView:view
                                            showType:KLCPopupShowTypeSlideInFromBottom
                                         dismissType:KLCPopupDismissTypeSlideOutToBottom
                                            maskType:KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:YES
                               dismissOnContentTouch:NO];
    
    [popup  showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
    
    view.CompleteBlock = complete;
    
    view.popup = popup;
    
    
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame{
    frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kSAdap(82) - iPhone_X_Navigation_Bar_Heigth);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MainThemColor;
        [self setupViews];
    }
    return self;
}

-(void)setupViews{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT-kSAdap(82) - iPhone_X_Navigation_Bar_Heigth) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(15.0f, 15.0f)];
    CAShapeLayer *layer =[[CAShapeLayer alloc] init];
    [layer setPath:path.CGPath];
    self.layer.mask = layer;
    
    _close = ({
        UIButton *iv = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *icon = [UIImage imageNamed:@"shop_close"];
        [iv setImage:icon forState:UIControlStateNormal];
        [iv setImage:icon forState:UIControlStateSelected];
        [iv setImage:icon forState:UIControlStateHighlighted];
        [iv addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        iv.tag = TriggerAnalyzeTypeClose;
        [self addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSAdap(15.0));
            make.top.mas_equalTo(kSAdap_V(15.0));
            make.size.mas_equalTo(icon.size);
        }];
        iv;
    });
    
    _triggerImageView = ({
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectZero];
        UIImage *icon  = [UIImage imageNamed:@"body_downwhite"];
        iv.image = icon ;
        [self addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kSAdap_V(30.0));
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kSAdap(123), kSAdap_V(200)));
        }];
        iv;
    });
    
    _analyzeView = ({
        UIView *iv = [[UIView alloc]init];
        iv.backgroundColor = [UIColor colorWithRed:249.0/255.0f green:254.0/255.0f blue:236.0/255.0f alpha:1.0];
        iv.layer.borderColor = MainThemColor.CGColor;
        iv.layer.borderWidth = 0.5f;
        iv.cornerRadius = kSAdap(12);
        [self addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSAdap(20.0));
            make.right.mas_equalTo(-kSAdap(20));
            make.top.mas_equalTo(self.triggerImageView.mas_bottom).mas_offset(kSAdap_V(32.0));
            make.height.mas_equalTo(kSAdap_V(120));
        }];
        iv;
    });
    
    _sliderBar = ({
        ELSlideTabBar *iv = [[ELSlideTabBar alloc]init];
        iv.backgroundColor = [UIColor clearColor];
        iv.delegate = self;
        [self.analyzeView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kSAdap_V(20));
            make.left.mas_equalTo(kSAdap(12));
            make.right.mas_equalTo(-kSAdap(12));
            make.top.mas_equalTo(kSAdap_V(10));
        }];
        iv;
    });
    [_sliderBar setLabels:@[@"成因分析",@"治疗原则",@"扳机点位置"] tabIndex:0];
    
    UIView *spliteLine = [[UIView alloc] init];
    spliteLine.backgroundColor = MainThemColor;
    [self.analyzeView addSubview:spliteLine];
    [spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSAdap(12));
        make.right.mas_equalTo(-kSAdap(12));
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.sliderBar.mas_bottom).mas_offset(kSAdap_V(5));
    }];
    
    _contentLabel = ({
        UILabel *iv = [[UILabel alloc]init];
        iv.numberOfLines = 0;
        iv.textColor = MainThemColor;
        iv.textAlignment = NSTextAlignmentLeft;
        iv.font = [UIFont ELPingFangSCRegularFontOfSize:kSaFont(12)];
        [iv sizeToFit];
        iv.text = @"在电脑或办公桌保持一个姿势或从事体力劳动，进行大量运动等导致腰部过度劳累而引起。";
        [self.analyzeView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSAdap(12));
            make.right.mas_equalTo(-kSAdap(12));
            make.top.mas_equalTo(self.sliderBar.mas_bottom).mas_offset(kSAdap_V(14));
        }];
        iv;
    });
    
    
    _downloadButton = ({
        ELButtonExtention *iv = [ELButtonExtention buttonWithType:UIButtonTypeCustom];
        UIImage *icon = [UIImage imageNamed:@"home_download_white"];
        [iv setImage:icon forState:UIControlStateNormal];
        [iv setImage:icon forState:UIControlStateSelected];
        [iv setImage:icon forState:UIControlStateHighlighted];
        [iv setTitle:@"程序下载" forState:UIControlStateNormal];
        [iv setTitle:@"程序下载" forState:UIControlStateSelected];
        [iv setTitle:@"程序下载" forState:UIControlStateHighlighted];
        [iv setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [iv setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [iv setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        iv.adjustsImageWhenHighlighted =NO;
        iv.showsTouchWhenHighlighted =NO;
        [iv.titleLabel setFont:[UIFont ELPingFangSCRegularFontOfSize:kSaFont(16.0)]];
        [iv addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        iv.type = ButtonDisplayTypeImageRightTileleft;
        iv.tag = TriggerAnalyzeTypeDownload;
        [self addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(-kSAdap_V(45));
            make.width.mas_equalTo(kSAdap(120));
            make.height.mas_equalTo(kSAdap_V(25));
        }];
        iv;
    });
}

-(void)InitDataWithModel:(ELMyofascialContentListModel *)model{
    self.triggerImageView.image = ELImageNamed(model.selectedImageName);
    [self.titles addObjectsFromArray:@[@"在电脑或办公桌保持一个姿势或从事体力劳动，进行大量运动等导致腰部过度劳累而引起。",@"测试治疗原则测试治疗原则测试治疗原则测试治疗原则",@"扳机点位置扳机点位置扳机点位置扳机点位置"]];
}

#pragma mark ELSlideTabBarDelegate
- (void)onTabTapAction:(NSInteger)index{
    self.contentLabel.text = convertToString(self.titles[index]);
}

-(void)Click:(UIButton *)sender{
    switch (sender.tag) {
        case TriggerAnalyzeTypeClose:{
            [self dismiss];
            break;
        }
        case TriggerAnalyzeTypeDownload:{
            if (self.CompleteBlock) {
                
            }
            break;
        }
        default:
            break;
    }
}

- (void)dismiss {
    [self.popup dismiss:YES];
}

#pragma mark 懒加载
-(NSMutableArray *)titles{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}
@end
