//
//  CQLoadPhoneNumber.m
//  CQPayedDemo
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQLoadPhoneNumber.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>

@interface CQLoadPhoneNumber ()
@property(nonatomic,strong)NSMutableArray *array;
@end

@implementation CQLoadPhoneNumber

+ (instancetype)sharedInstance {
    static CQLoadPhoneNumber *phoneNum;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        phoneNum = [[self alloc] init];
    });
    return phoneNum;
}

- (NSMutableArray *)loadUserPhoneNumber {
    
    if (kCurrent_Version >= 9.0) {
        [self loadPhoneNumberInNewVersion];
    } else {
        [self loadPhoneNumberInOldVersion];
    }
    return self.array;
}
#pragma mark -
#pragma mark - 9.0系统以上
- (NSMutableArray *)loadPhoneNumberInNewVersion {
    __weak typeof(self) weakSelf = self;
    // 获取用户授权状态
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    if ( authorizationStatus == CNAuthorizationStatusNotDetermined) { // 用户没有做出选择
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            weakSelf.array = [self copyContactStore:contactStore];
        }];
    } else if (authorizationStatus == CNAuthorizationStatusAuthorized) { // 用户已经授权
        self.array = [self copyContactStore:contactStore];
    }
    return self.array;
}

- (NSMutableArray *)copyContactStore:(CNContactStore *)contactStore {
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactGivenNameKey,CNContactImageDataKey,CNContactPhoneNumbersKey,CNContactFamilyNameKey]];

    NSMutableArray *peopleArray = [NSMutableArray array];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:NULL usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        // 1.获取联系人的姓名
        NSString *firstName = contact.familyName;
        NSString *secondName = contact.givenName;
        if (!firstName) {
            firstName = @"";
        }
        if (!secondName) {
            secondName = @"";
        }
        NSString *userName = [NSString stringWithFormat:@"%@%@",firstName, secondName];
        
        __block NSString *mobileString = @"";
        // 2.遍历联系人的电话号码
        [contact.phoneNumbers enumerateObjectsUsingBlock:^(CNLabeledValue *labeledValue, NSUInteger idx, BOOL * _Nonnull stop) {
            // 2.1.获取电话号码的KEY
//            NSString *phoneLabel = labeledValue.label;
            
            // 2.2.获取电话号码
            CNPhoneNumber *phoneNumer = labeledValue.value;
            NSString *phoneValue = phoneNumer.stringValue;
            
            if (idx == 0) {
                mobileString = [mobileString stringByAppendingString:[NSString stringWithFormat:@"%d%@%@",idx + 1,SUB_ARRAY_CLIP,phoneValue]];
            } else {
                mobileString = [mobileString stringByAppendingString:[NSString stringWithFormat:@"%@%d%@%@",ARRAY_CLIP,idx + 1,SUB_ARRAY_CLIP,phoneValue]];
            }
            mobileString = [mobileString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }];
        if ([mobileString isEqualToString:@""]) return; // 过滤没有手机号的数据
        CQPhoneNumModel *model = [[CQPhoneNumModel alloc] init];
        model.name = userName;
        model.mobile = mobileString;
        model.head = contact.imageData;
        model.nameAlphabet = userName.chinesePhoneticAlphabet;
        [peopleArray addObject:model];

    }];
    
    return peopleArray;
}

#pragma mark -
#pragma mark - 9.0系统一下
- (void)loadPhoneNumberInOldVersion {
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) { // 用户没有做出选择
        __weak typeof(self) weakSelf = self;
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            
            CFErrorRef *error1 = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
            weakSelf.array = [self copyAddressBook:addressBook];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){ // 已经授权
        
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        _array = [self copyAddressBook:addressBook];
       
    }
}
-(NSMutableArray *)copyAddressBook:(ABAddressBookRef)addressBook
{
    
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    NSMutableArray *peopleList = [NSMutableArray array];
    
    for ( int i = 0; i < numberOfPeople; i++){
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        if (!firstName) {
            firstName = @"";
        }
        if (!lastName) {
            lastName = @"";
        }
        
        NSString *username = [NSString stringWithFormat:@"%@%@",firstName, lastName];
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString *mobileStr = @"";
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            //            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            if ([username isEqualToString:@""] && k == 0) {
                username = personPhone;
            }
            
            if (k == 0) {
                mobileStr = [mobileStr stringByAppendingString:[NSString stringWithFormat:@"%d%@%@",k + 1,SUB_ARRAY_CLIP,personPhone]];
            }else
            {
                mobileStr = [mobileStr stringByAppendingString:[NSString stringWithFormat:@"%@%d%@%@",ARRAY_CLIP,k + 1,SUB_ARRAY_CLIP,personPhone]];
            }
            
            mobileStr = [mobileStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
        }
        //读取照片
        NSData *image = (__bridge NSData*)ABPersonCopyImageDataWithFormat(person,kABPersonImageFormatThumbnail);
        if ([mobileStr isEqualToString:@""]) continue; // 过滤没有手机号的数据
        CQPhoneNumModel *model =[[CQPhoneNumModel alloc] init];
        model.tbid = [NSNumber numberWithInt:i+1];
        model.name = username;
        model.mobile = mobileStr;
        model.head = image;
        model.nameAlphabet = username.chinesePhoneticAlphabet;
        [peopleList addObject:model];
    }
    return peopleList;
    
}

@end
