//
//  TableViewCell.m
//  AddressBook
//
//  Created by E&P on 16/8/16.
//  Copyright © 2016年 easipass. All rights reserved.
//

#import "TableViewCell.h"
#import "Person.h"

@interface TableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel1;

@end

@implementation TableViewCell

- (void)setPerson:(Person *)person {
    if (_person != person) {
        _person = person;
    }
    _nameLabel.text = _person.name;
    _phoneLabel.hidden = NO;
    _phoneLabel1.hidden = NO;
    if (_person.phoneArr.count != 0) {
        if (_person.phoneArr.count == 1) {
            _phoneLabel.text = [person.phoneArr lastObject];
            _phoneLabel1.hidden = YES;
        } else {
            _phoneLabel.text = [person.phoneArr firstObject];
            _phoneLabel1.text = [person.phoneArr lastObject];
        }
    } else {
        _phoneLabel.hidden = YES;
        _phoneLabel1.hidden = YES;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
