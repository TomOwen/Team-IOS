//
//  SharedObject.h
//  SharedObjects
//
//  Created by Tom Owen on 6/4/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

// To use singleton
// include SharedObject.h
/*
 ***** setter
 self.myPatientID = @"1234567";
 [[SharedObject sharedTeamData] setPatientID:self.myPatientID];

***** getter 
 NSString *receivedObject = nil;
 receivedObject = [[SharedObject sharedTeamData] getPatientID];
*/
#import <Foundation/Foundation.h>

@interface SharedObject : NSObject{
    NSNumber *teamID;
    NSString *patientID;
    NSString *patientName;
    NSDate *scanDate;
    NSDate *scanDate2;
    NSNumber *lesionNumber;
    NSNumber *lesionNumber2;
    NSString *userAdmin;
    NSString *mediaType;
    NSString *docType;
    NSString* db_server;
    NSString* dbUser;
    NSString* dbPassword;
    NSString* imagedoc_server;
    NSString* imagedocUser;
    NSString* imagedocPassword;
    NSString* companyName;
    NSString* imageExt1;
    NSString* imageExt2;
    NSString* studyid;
    NSString* user_name;
    
}

+(SharedObject *)sharedTeamData;
-(void)setTeamID:(NSNumber *)newTeamID;
-(NSNumber *)getTeamID;

-(void)setPatientID:(NSString *)newPatientID;
-(NSString *)getPatientID;

-(void)setPatientName:(NSString *)newPatientName;
-(NSString *)getPatientName;

-(void)setScanDate:(NSDate *)newScanDate;
-(NSDate *)getScanDate;

-(void)setScanDate2:(NSDate *)newScanDate2;
-(NSDate *)getScanDate2;

-(void)setLesionNumber:(NSNumber *)newLesionNumber;
-(NSNumber *)getLesionNumber;

-(void)setLesionNumber2:(NSNumber *)newLesionNumber2;
-(NSNumber *)getLesionNumber2;

-(void)setUserAdmin:(NSString *)newUserAdmin;
-(NSString *)getUserAdmin;

-(void)setMediaType:(NSString *)newMediaType;
-(NSString *)getMediaType;

-(void)setDocType:(NSString *)newDocType;
-(NSString *)getDocType;

-(void)setDb_server:(NSString *)newDb_server;
-(NSString *)getDb_server;

-(void)setDbUser:(NSString *)newDbUser;
-(NSString *)getDbUser;

-(void)setDbPassword:(NSString *)newDbPassword;
-(NSString *)getDbPassword;

-(void)setImagedoc_server:(NSString *)newImagedoc_server;
-(NSString *)getImagedoc_server;

-(void)setImagedocUser:(NSString *)newImagedocUser;
-(NSString *)getImagedocUser;

-(void)setImagedocPassword:(NSString *)newImagedocPassword;
-(NSString *)getImagedocPassword;

-(void)setCompanyName:(NSString *)newCompanyName;
-(NSString *)getCompanyName;

-(void)setImageExt1:(NSString *)newImageExt1;
-(NSString *)getImageExt1;

-(void)setImageExt2:(NSString *)newImageExt2;
-(NSString *)getImageExt2;

-(void)setStudyid:(NSString *)newStudyid;
-(NSString *)getStudyid;

-(void)setUser_name:(NSString *)newUser_name;
-(NSString *)getUser_name;




@end
