//
//  SharedObject.m
//  SharedObjects
//
//  Created by Tom Owen on 6/4/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//
/*
NSString* db_server;
NSString* dbUser;
NSString* dbPassword;
NSString* imagedoc_server;
NSString* imagedocUser;
NSString* imagedocPassword;
*/
#import "SharedObject.h"

static SharedObject *sharedTeamData;

@implementation SharedObject

-(id)init{
    
    self = [super init];
    teamID = [NSNumber new];
    patientID = [NSString new];
    patientName = [NSString new];
    return self;
}

+(SharedObject *)sharedTeamData{
    if (!sharedTeamData) {
        sharedTeamData = [[SharedObject alloc] init];
    }
    return sharedTeamData;
}
// team ID
-(void)setTeamID:(NSNumber *)newTeamID{
    teamID = newTeamID;
}
-(NSNumber *)getTeamID{
    return teamID;
}
// patient ID
-(void)setPatientID:(NSString *)newPatientID{
    patientID = newPatientID;
}
-(NSString *)getPatientID{
    return patientID;
} 
// patient Name
-(void)setPatientName:(NSString *)newPatientName{
    patientName = newPatientName;
}
-(NSString *)getPatientName{
    return patientName;
}
// media type 1 and 2
-(void)setDocType:(NSString *)newDocType{
    docType = newDocType;
}
-(NSString *)getDocType{
    return docType;
}
-(void)setMediaType:(NSString *)newMediaType{
    mediaType = newMediaType;
}
-(NSString *)getMediaType{
    return mediaType;
}
// scan date
-(void)setScanDate:(NSDate *)newScanDate{
    //NSLog(@"setScanDate called ...returned %@",newScanDate);
    scanDate = newScanDate;
}
-(NSDate *)getScanDate{
    //NSLog(@"getScanDate called ...returned %@",scanDate);
    return scanDate;
}
-(void)setScanDate2:(NSDate *)newScanDate2{
    scanDate2 = newScanDate2;
}
-(NSDate *)getScanDate2{
    return scanDate2;
}
// lesion number
-(void)setLesionNumber:(NSNumber *)newLesionNumber{
    lesionNumber = newLesionNumber;
}
-(NSNumber *)getLesionNumber{
    return lesionNumber;
}
-(void)setLesionNumber2:(NSNumber *)newLesionNumber2{
    lesionNumber2 = newLesionNumber2;
}
-(NSNumber *)getLesionNumber2{
    return lesionNumber2;
}
// user admin
-(void)setUserAdmin:(NSString *)newUserAdmin{
    userAdmin = newUserAdmin;
}
-(NSString *)getUserAdmin{
    return userAdmin;
}

-(void)setDb_server:(NSString *)newDb_server{
    db_server = newDb_server;
}
-(NSString *)getDb_server{
    return db_server;
}

-(void)setDbUser:(NSString *)newDbUser{
    dbUser = newDbUser;
}
-(NSString *)getDbUser{
    return dbUser;
}

-(void)setDbPassword:(NSString *)newDbPassword{
    dbPassword = newDbPassword;
}
-(NSString *)getDbPassword{
    return dbPassword;
}

-(void)setImagedoc_server:(NSString *)newImagedoc_server{
    imagedoc_server = newImagedoc_server;
}
-(NSString *)getImagedoc_server{
    return imagedoc_server;
}

-(void)setImagedocUser:(NSString *)newImagedocUser{
    imagedocUser = newImagedocUser;
}
-(NSString *)getImagedocUser{
    return imagedocUser;
}

-(void)setImagedocPassword:(NSString *)newImagedocPassword{
    imagedocPassword = newImagedocPassword;
}
-(NSString *)getImagedocPassword{
    return imagedocPassword;
}

-(void)setCompanyName:(NSString *)newCompanyName{
    companyName = newCompanyName;
}
-(NSString *)getCompanyName{
    return companyName;
}

-(void)setImageExt1:(NSString *)newImageExt1{
    imageExt1 = newImageExt1;
}
-(NSString *)getImageExt1{
    return imageExt1;
}

-(void)setImageExt2:(NSString *)newImageExt2{
    imageExt2 = newImageExt2;
}
-(NSString *)getImageExt2{
    return imageExt2;
}

-(void)setStudyid:(NSString *)newStudyid{
    studyid = newStudyid;
}
-(NSString *)getStudyid{
    return studyid;
}

-(void)setUser_name:(NSString *)newUser_name{
    user_name = newUser_name;
}
-(NSString *)getUser_name{
    return user_name;
}


@end

