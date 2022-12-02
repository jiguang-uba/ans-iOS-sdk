//
//  ANSBindTableViewCellTMP.m
//  AnalysysOCDemo
//
//  Created by xiao xu on 2020/8/26.
//  Copyright © 2020 xiao xu. All rights reserved.
//

#import "ANSBindTableViewCellTMP.h"

@implementation ANSBindTableViewCellTMP

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    lab.text = @"aaa";
    lab.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:lab];
    self.lab = lab;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
