//
//  NGRValidatorBehavior.m
//  NGRValidator
//
//  Created by Patryk Kaczmarek on 13.02.2015.
//
//

@interface NGRTestModel : NSObject
@property (strong, nonatomic) id value;
@end

@implementation NGRTestModel @end

SharedExamplesBegin(NGRValidatorBehavior)

sharedExamplesFor(NGRValueBehavior, ^(NSDictionary *data) {
    
    __block NSError *error; __block NSArray *array; __block BOOL success;
    __block NGRTestModel *model; __block NSArray *(^rules)(); __block NGRPropertyValidator *propertyValidator;
    
    beforeEach(^{
        model = [[NGRTestModel alloc] init];
        propertyValidator = data[NGRValidatorKey];
        rules = ^NSArray *{
            return @[propertyValidator];
        };
    });
    
    afterEach(^{
        model = nil; rules = nil; error = nil; array = nil; cleanDescriptors();
    });
    
    describe(validatorDescriptor, ^{

        it([NSString stringWithFormat:@"with %@, should succeed.", successDescriptor], ^{
            
            success = NO;
            model.value = data[NGRValidValueKey];
            
            // 1st
            success = [NGRValidator validateModel:model error:&error usingRules:rules];
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            // 2nd
            array = [NGRValidator validateModel:model usingRules:rules];
            expect(array).to.beNil();
            
            // 3rd
            error = nil;
            error = [NGRValidator validateValue:model.value named:@"value" usingRules:^(NGRPropertyValidator *validator) {
                [validator setValue:propertyValidator.validationRules forKey:@"validationRules"];
                [validator setValue:propertyValidator.messages forKey:@"messages"];
            }];
            expect(error).to.beNil();

        });
        
        it([NSString stringWithFormat:@"with %@, should fail.", failureDescriptor], ^{
            
            success = YES;
            model.value = data[NGRInvalidValueKey];
            
            // 1st
            success = [NGRValidator validateModel:model error:&error usingRules:rules];
            expect(success).to.beFalsy();
            expect(error).toNot.beNil();
            expect(error.localizedDescription).to.contain(msg);
            
            // 2nd
            array = [NGRValidator validateModel:model usingRules:rules];
            expect(array).to.haveCountOf([data[NGRErrorCountKey] integerValue]);
            for (NSError *error in array) {
                expect(error.localizedDescription).to.contain(msg);
            }
            
            // 3rd
            error = nil;
            error = [NGRValidator validateValue:model.value named:@"value" usingRules:^(NGRPropertyValidator *validator) {
                [validator setValue:propertyValidator.validationRules forKey:@"validationRules"];
                [validator setValue:propertyValidator.messages forKey:@"messages"];
            }];
            expect(error).toNot.beNil();
            expect(error.localizedDescription).to.contain(msg);
        });
    });
    
});

sharedExamplesFor(NGRScenarioSuccessBehavior, ^(NSDictionary *data) {
    
    __block NSError *error; __block NSArray *array; __block BOOL success;
    __block NGRTestModel *model; __block NSArray *(^rules)(); __block NGRPropertyValidator *propertyValidator;
    __block NSString *scenario;
    
    beforeEach(^{
        scenario = data[NGRScenarioKey];
        model = [[NGRTestModel alloc] init];
        propertyValidator = data[NGRValidatorKey];
        rules = ^NSArray *{
            return @[propertyValidator];
        };
    });
    
    afterEach(^{
        model = nil; rules = nil; error = nil; array = nil; scenario = nil; cleanDescriptors();
    });
    
    describe(validatorDescriptor, ^{
        
        it([NSString stringWithFormat:@"with %@, should succeed.", successDescriptor], ^{
            
            success = NO;
            model.value = data[NGRValidValueKey];
            
            // 1st
            success = [NGRValidator validateModel:model error:&error scenario:scenario usingRules:rules];
            expect(success).to.beTruthy();
            expect(error).to.beNil();
            
            // 2nd
            array = [NGRValidator validateModel:model scenario:scenario usingRules:rules];
            expect(array).to.beNil();
        });
    });
});

sharedExamplesFor(NGRScenarioFailureBehavior, ^(NSDictionary *data) {
    
    __block NSError *error; __block NSArray *array; __block BOOL success;
    __block NGRTestModel *model; __block NSArray *(^rules)(); __block NGRPropertyValidator *propertyValidator;
    __block NSString *scenario;
    
    beforeEach(^{
        scenario = data[NGRScenarioKey];
        model = [[NGRTestModel alloc] init];
        propertyValidator = data[NGRValidatorKey];
        rules = ^NSArray *{
            return @[propertyValidator];
        };
    });
    
    afterEach(^{
        model = nil; rules = nil; error = nil; array = nil; scenario = nil; cleanDescriptors();
    });
    
    describe(validatorDescriptor, ^{
    
        it([NSString stringWithFormat:@"with %@, should fail.", failureDescriptor], ^{
            
            success = YES;
            model.value = data[NGRValidValueKey];
            
            // 1st
            success = [NGRValidator validateModel:model error:&error scenario:scenario usingRules:rules];
            expect(success).to.beFalsy();
            expect(error).toNot.beNil();
            expect(error.localizedDescription).to.contain(msg);
            
            // 2nd
            array = [NGRValidator validateModel:model scenario:scenario usingRules:rules];
            expect(array).to.haveCountOf([data[NGRErrorCountKey] integerValue]);
            for (NSError *error in array) {
                expect(error.localizedDescription).to.contain(msg);
            }
        });
    });
});

sharedExamplesFor(NGRAssertBehavior, ^(NSDictionary *data) {
    
    __block NSError *error; __block NSArray *(^rules)();
    __block NGRTestModel *model; __block NGRPropertyValidator *propertyValidator;
    
    beforeEach(^{
        model = [[NGRTestModel alloc] init];
        model.value = data[NGRValidValueKey];
        propertyValidator = data[NGRValidatorKey];
        rules = ^NSArray *{
            return @[propertyValidator];
        };
    });
    
    afterEach(^{
        model = nil; rules = nil; error = nil; cleanDescriptors();
    });
        
    it(failureDescriptor, ^{
        expect(^{
            [NGRValidator validateModel:model error:&error usingRules:rules];
        }).to.raise(NSInternalInconsistencyException);
        
        expect(^{
            [NGRValidator validateModel:model usingRules:rules];
        }).to.raise(NSInternalInconsistencyException);
        
        expect(^{
            [NGRValidator validateValue:model.value named:nil usingRules:^(NGRPropertyValidator *validator) {
                [validator setValue:propertyValidator.validationRules forKey:@"validationRules"];
                [validator setValue:propertyValidator.messages forKey:@"messages"];
            }];
        }).to.raise(NSInternalInconsistencyException);
    });
});

SharedExamplesEnd

