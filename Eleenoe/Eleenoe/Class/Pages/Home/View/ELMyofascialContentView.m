//
//  ELMyofascialContentView.m
//  Eleenoe
//
//  Created by HuiLu on 2019/3/30.
//  Copyright © 2019 FaceBook. All rights reserved.
//

#import "ELMyofascialContentView.h"
#import "ELMyofascialPickView.h"
#import "ELMyofascialContentModel.h"
#import "ELHorseRaceLamp.h"
@interface ELMyofascialContentView()
@property(nonatomic,strong)UIImageView *contentImageView;
@property(nonatomic,strong) ELMyofascialPickView *bodyListView;
@property(nonatomic,strong) ELMyofascialPickView *rankListView;
@property(nonatomic,strong) ELHorseRaceLamp *marqueLabel;
@property(nonatomic,strong) ELMyofascialContentModel *model;
@property(nonatomic,assign)NSInteger atIndex;
@end

@implementation ELMyofascialContentView
-(void)ELSinitConfingViews{
    
    _marqueLabel = ({
        ELHorseRaceLamp *iv = [[ELHorseRaceLamp alloc]init];
        iv.textColor = MainThemColor;
        iv.textFont = [UIFont ELPingFangSCRegularFontOfSize:kSaFont(12)];
        [iv updateTextAlignmentLeft];
        iv.backgroundColor = MainLightThemColor;
        [self addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(30);
        }];
        iv;
    });
    
    _contentImageView = ({
        UIImageView *iv = [[UIImageView alloc]init];
        iv.clipsToBounds = YES;
        UIImage *icon  = [UIImage imageNamed:@"mysofac_newbody"];
        iv.image = icon ;
        [self addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(kSAdap_V(40));
            make.size.mas_equalTo(CGSizeMake(kSAdap(150), kSAdap_V(250)));
        }];
        iv;
    });
    
    _bodyListView = ({
        ELMyofascialPickView *iv = [[ELMyofascialPickView alloc]init];
        iv.backgroundColor = [UIColor clearColor];
        [self addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kSAdap(10));
            make.top.mas_equalTo(kSAdap_V(60));
            make.width.mas_equalTo(kSAdap(60));
            make.height.mas_equalTo(kSAdap_V(210));
        }];
        iv;
    });
    
    _rankListView = ({
        ELMyofascialPickView *iv = [[ELMyofascialPickView alloc]init];
        iv.backgroundColor = [UIColor clearColor];
        iv.hidden = YES;
        [self addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kSAdap(10));
            make.top.mas_equalTo(kSAdap_V(60));
            make.width.mas_equalTo(kSAdap(50));
            make.height.mas_equalTo(kSAdap_V(210));
        }];
        iv;
    });
    
    @weakify(self);
    self.bodyListView.MyofascialPickBlock = ^(ELMyofascialPickView * _Nonnull pickview, NSInteger index, ELMyofascialContentListModel * _Nonnull model) {
        @strongify(self);
        self.contentImageView.image = ELImageNamed(model.selectedImageName);
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setValue:model forKey:AnalyzeUserInfoKey];
        [ELNotificationCenter postNotificationName:TriggerAnalyzeNotificationCenter object:nil userInfo:userInfo];
    };
    
    self.rankListView.MyofascialPickBlock = ^(ELMyofascialPickView * _Nonnull pickview, NSInteger index, ELMyofascialContentListModel * _Nonnull model) {
        @strongify(self);
        self.marqueLabel.text = model.ads;
    };
}

-(void)InitDataWithModel:(ELMyofascialContentModel *)model{
    _model = model;
    [self.rankListView setHidden:!model.isShow];
    [self.marqueLabel setHidden:!model.isShow];
    [self.bodyListView InitDataSouce:model.datas];
    if (model.isShow) {
        [self.rankListView InitDataSouce:model.pains];
    }
    
    switch (model.MyofascialType) {
        case MyofascialContentTypeRelax:{
            [self.bodyListView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kSAdap(60));
            }];
            break;
        }
        case MyofascialContentTypeAnadesma:{
            [self.bodyListView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kSAdap(70));
            }];
            break;
        }
        case MyofascialContentTypePains:{
            [self.bodyListView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kSAdap(60));
            }];
            break;
        }
        case MyofascialContentTypeDamage:{
            [self.bodyListView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kSAdap(90));
            }];
            break;
        }
        default:
            break;
    }
}

@end
