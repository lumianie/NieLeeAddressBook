//
//  ViewController.m
//  AddressBook
//
//  Created by E&P on 16/8/16.
//  Copyright © 2016年 easipass. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import "Person.h"
#import "TableViewCell.h"
#import "BMChineseSort.h"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *personArray;
@property (nonatomic, strong) NSMutableArray *titArray;
@property (nonatomic, strong) NSMutableArray *sortArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.title = @"通讯录";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.000 green:0.185 blue:0.151 alpha:1.000];
    self.personArray = [NSMutableArray arrayWithCapacity:0];
    self.titArray = [NSMutableArray arrayWithCapacity:0];
    self.sortArray = [NSMutableArray arrayWithCapacity:0];
    self.tableView.rowHeight = 80;
    [self loadPerson];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadPerson
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            
            CFErrorRef *error1 = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
            [self copyAddressBook:addressBook];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        [self copyAddressBook:addressBook];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
}
#pragma clang diagnostic pop

- (void)copyAddressBook:(ABAddressBookRef)addressBook
{
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for ( int i = 0; i < numberOfPeople; i++){
        Person *per = [Person new];
        per.phoneArr = [NSMutableArray arrayWithCapacity:0];
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        //读取middlename
        NSString *middlename = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNameProperty));
        
        if (firstName == nil && lastName != nil) {
            per.name = lastName;
        } else if (firstName != nil && lastName == nil) {
            per.name = firstName;
        } else if (firstName != nil && lastName != nil) {
            per.name = [lastName stringByAppendingString:firstName];
        } else {
            per.name = @"";
        }
        //读取prefix前缀
        NSString *prefix = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonPrefixProperty));
        //读取suffix后缀
        NSString *suffix = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonSuffixProperty));
        //读取nickname呢称
        NSString *nickname = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonNicknameProperty));
        //读取firstname拼音音标
        NSString *firstnamePhonetic = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty));
        //读取lastname拼音音标
        NSString *lastnamePhonetic = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty));
        //读取middlename拼音音标
        NSString *middlenamePhonetic = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty));
        //读取organization公司
        NSString *organization = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonOrganizationProperty));
        //读取jobtitle工作
        NSString *jobtitle = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonJobTitleProperty));
        //读取department部门
        NSString *department = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonDepartmentProperty));
        //读取birthday生日
        NSDate *birthday = (NSDate*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonBirthdayProperty));
        //读取note备忘录
        NSString *note = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonNoteProperty));
        //第一次添加该条记录的时间
        NSString *firstknow = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonCreationDateProperty));
       // NSLog(@"第一次添加该条记录的时间%@\n",firstknow);
        //最后一次修改該条记录的时间
        NSString *lastknow = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonModificationDateProperty));
      //  NSLog(@"最后一次修改該条记录的时间%@\n",lastknow);
        
        //获取email多值
        ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
        int emailcount = ABMultiValueGetCount(email);
        for (int x = 0; x < emailcount; x++)
        {
         
            //获取email Label
            NSString* emailLabel = (NSString*)CFBridgingRelease(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x)));
            //获取email值
            NSString* emailContent = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(email, x));
        }
        //读取地址多值
        ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
        int count = ABMultiValueGetCount(address);
        
        for(int j = 0; j < count; j++)
        {
            //获取地址Label
            NSString* addressLabel = (NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(address, j));
            //获取該label下的地址6属性
            NSDictionary* personaddress =(NSDictionary*) CFBridgingRelease(ABMultiValueCopyValueAtIndex(address, j));
            NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
            NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
            NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
            NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
            NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
            NSString* coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
        }
        
        //获取dates多值
        ABMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
        int datescount = ABMultiValueGetCount(dates);
        for (int y = 0; y < datescount; y++)
        {
            //获取dates Label
            NSString* datesLabel = (NSString*)CFBridgingRelease(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(dates, y)));
            //获取dates值
            NSString* datesContent = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(dates, y));
        }
        //获取kind值
        CFNumberRef recordType = ABRecordCopyValue(person, kABPersonKindProperty);
        if (recordType == kABPersonKindOrganization) {
            // it's a company
          //  NSLog(@"it's a company\n");
        } else {
            // it's a person, resource, or room
          //  NSLog(@"it's a person, resource, or room\n");
        }
        
        
        //获取IM多值
        ABMultiValueRef instantMessage = ABRecordCopyValue(person, kABPersonInstantMessageProperty);
        for (int l = 1; l < ABMultiValueGetCount(instantMessage); l++)
        {
            //获取IM Label
            NSString* instantMessageLabel = (NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(instantMessage, l));
            //获取該label下的2属性
            NSDictionary* instantMessageContent =(NSDictionary*) CFBridgingRelease(ABMultiValueCopyValueAtIndex(instantMessage, l));
            NSString* username = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
            
            NSString* service = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
        }
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            NSString * personPhoneLabel = (NSString*)CFBridgingRelease(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k)));
            //获取該Label下的电话值
            NSString * personPhone = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phone, k));
            [per.phoneArr addObject:personPhone];
        }
        //获取URL多值
        ABMultiValueRef url = ABRecordCopyValue(person, kABPersonURLProperty);
        for (int m = 0; m < ABMultiValueGetCount(url); m++)
        {
            //获取电话Label
            NSString * urlLabel = (NSString*)CFBridgingRelease(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(url, m)));
            //获取該Label下的电话值
            NSString * urlContent = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(url,m));
        }
        
        //读取照片
        NSData *image = (NSData*)CFBridgingRelease(ABPersonCopyImageData(person));
        
        [self.personArray addObject:per];
    }
    _titArray = [BMChineseSort IndexWithArray:_personArray Key:@"name"];
    _sortArray = [BMChineseSort sortObjectArray:_personArray Key:@"name"];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sortArray[section] count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _titArray[section];
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _titArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.person = self.sortArray[indexPath.section][indexPath.row];
    return cell;
}


@end
