//
//  ResponseMap.m
//  Team
//
//  Created by Tom Owen on 10/14/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "ResponseMap.h"

@implementation ResponseMap
@synthesize patient_name = _patient_name;
@synthesize patient_id = _patient_id;
@synthesize patient_doctor = _patient_doctor;
@synthesize patient_study_id = _patient_study_id;
@synthesize study_owner = _study_owner;
@synthesize study_name = _study_name;
@synthesize study_percentpr = _study_percentpr;
@synthesize study_percentpd = _study_percentpd;
@synthesize overall_response_code = _overall_response_code;
@synthesize target_response_code = _target_response_code;
@synthesize tc_total_size = _tc_total_size;
@synthesize tb_total_size = _tb_total_size;
@synthesize tb_percent_change = _tb_percent_change;
@synthesize tb_response = _tb_response;
@synthesize ts_total_size = _ts_total_size;
@synthesize ts_percent_change = _ts_percent_change;
@synthesize ts_response = _ts_response;
@synthesize non_target_response_code = _non_target_response_code;
@synthesize ntc_total_size = _ntc_total_size;
@synthesize ntb_total_size = _ntb_total_size;
@synthesize ntb_percent_change = _ntb_percent_change;
@synthesize ntb_response = _ntb_response;
@synthesize nts_total_size = _nts_total_size;
@synthesize nts_percent_change = _nts_percent_change;
@synthesize nts_response = _nts_response;

@synthesize lesion_number = _lesion_number;
@synthesize lesion_target = _lesion_target;
@synthesize current_date = _current_date;
@synthesize baseline_date = _baseline_date;
@synthesize current_size = _current_size;
@synthesize baseline_size = _baseline_size;
@synthesize baseline_percent_change = _baseline_percent_change;
@synthesize smallest_date = _smallest_date;
@synthesize smallest_size = _smallest_size;
@synthesize smallest_percent_change = _smallest_percent_change;
@synthesize isnew_lesion = _isnew_lesion;
@synthesize lesion_node = _lesion_node;
@end
;
