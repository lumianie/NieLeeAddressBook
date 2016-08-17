//
//  Person.h
//  AddressBook
//
//  Created by E&P on 16/8/16.
//  Copyright © 2016年 easipass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *phoneArr;
@end
