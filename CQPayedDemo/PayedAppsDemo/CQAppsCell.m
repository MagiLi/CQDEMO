//
//  CQAppsCell.m
//  CQPayedDemo
//
//  Created by mac on 16/12/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQAppsCell.h"
#import "CQAppsDataManager.h"

@interface CQAppsCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

@property(nonatomic,assign)BOOL editing;

@end

@implementation CQAppsCell

+ (CQAppsCell *)cellWithCollectionView:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath withModel:(CQAppsModel *)model withEditing:(BOOL)editing{
    CQAppsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.editing = editing;
    cell.indexPath = indexPath;
    cell.model = model;
    cell.delegate = (id)collectionView;
    return cell;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateButtonChanged:) name:notification_CellStateChange object:nil];
    }
    return self;
}

- (void)stateButtonChanged:(NSNotification *)noti {
    if ([noti.object isEqualToNumber:@1]) {
        self.stateBtn.hidden = NO;
        [self showStateButton];
    } else {
        self.stateBtn.hidden = YES;
    }
}
- (void)showStateButton {
    switch (_model.buttonState) {
        case ServeButtonNormal:
            self.stateBtn.enabled = YES;
            [self.stateBtn setImage:[UIImage imageNamed:@"app_add"] forState:UIControlStateNormal];
            break;
        case ServeButtonSelected:
            if (self.indexPath.section == 0) {
                self.stateBtn.enabled = YES;
                [self.stateBtn setImage:[UIImage imageNamed:@"app_del"] forState:UIControlStateNormal];
            } else {
                
                if ([[[CQAppsDataManager sharedAppsDataManager].dataArray firstObject] containsObject:self.model]) {
                    self.stateBtn.enabled = NO;
                    [self.stateBtn setImage:[UIImage imageNamed:@"app_ok"] forState:UIControlStateNormal];
                } else {
                    self.stateBtn.enabled = YES;
                    [self.stateBtn setImage:[UIImage imageNamed:@"app_add"] forState:UIControlStateNormal];
                }
            }
            break;
        default:
            break;
    }
}
- (void)setModel:(CQAppsModel *)model {
    _model = model;
    
    self.titleLab.text = model.title;
    if (self.editing) {
        self.stateBtn.hidden = NO;
        [self showStateButton];
    } else {
        self.stateBtn.hidden = YES;
    }
    
}
- (IBAction)stateButtonClicked:(UIButton *)sender {
    sender.enabled = NO;
    if (self.indexPath.section != 0) {
        [sender setImage:[UIImage imageNamed:@"app_ok"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(stateButtonClickedEvents:)]) {
        [self.delegate stateButtonClickedEvents:self];
    }
}

@end
