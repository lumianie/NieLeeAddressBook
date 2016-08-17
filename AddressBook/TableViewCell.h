//
//  TableViewCell.h
//  AddressBook
//
//  Created by E&P on 16/8/16.
//  Copyright © 2016年 easipass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Person;
@interface TableViewCell : UITableViewCell
@property (nonatomic, strong) Person *person;
@end
