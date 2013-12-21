//
//  ResponseMap.h
//  Team
//
//  Created by Tom Owen on 10/14/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseMap : NSObject
@property (nonatomic, retain) NSString* patient_name;
@property (nonatomic, retain) NSString* patient_id;
@property (nonatomic, retain) NSString* patient_doctor;
@property (nonatomic, retain) NSString* patient_study_id;
@property (nonatomic, retain) NSString* study_owner;
@property (nonatomic, retain) NSString* study_name;
@property (nonatomic, retain) NSString* study_percentpr;
@property (nonatomic, retain) NSString* study_percentpd;
@property (nonatomic, retain) NSString* overall_response_code;
@property (nonatomic, retain) NSString* target_response_code;
@property (nonatomic, retain) NSString* tc_total_size;
@property (nonatomic, retain) NSString* tb_total_size;
@property (nonatomic, retain) NSString* tb_percent_change;
@property (nonatomic, retain) NSString* tb_response;
@property (nonatomic, retain) NSString* ts_total_size;
@property (nonatomic, retain) NSString* ts_percent_change;
@property (nonatomic, retain) NSString* ts_response;
@property (nonatomic, retain) NSString* non_target_response_code;
@property (nonatomic, retain) NSString* ntc_total_size;
@property (nonatomic, retain) NSString* ntb_total_size;
@property (nonatomic, retain) NSString* ntb_percent_change;
@property (nonatomic, retain) NSString* ntb_response;
@property (nonatomic, retain) NSString* nts_total_size;
@property (nonatomic, retain) NSString* nts_percent_change;
@property (nonatomic, retain) NSString* nts_response;

@property (nonatomic, retain) NSString* lesion_number;
@property (nonatomic, retain) NSString* lesion_target;
@property (nonatomic, retain) NSString* current_date;
@property (nonatomic, retain) NSString* baseline_date;
@property (nonatomic, retain) NSString* current_size;
@property (nonatomic, retain) NSString* baseline_size;
@property (nonatomic, retain) NSString* baseline_percent_change;
@property (nonatomic, retain) NSString* smallest_date;
@property (nonatomic, retain) NSString* smallest_size;
@property (nonatomic, retain) NSString* smallest_percent_change;
@property (nonatomic, retain) NSString* isnew_lesion;
@property (nonatomic, retain) NSString* lesion_node;

@end
