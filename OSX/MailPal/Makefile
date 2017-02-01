INFOPLIST_FILE=Info.plist
SOURCES=\
	Sources/main.m \
	Sources/MailPalApp.m \
	Sources/UIController.m \
	Sources/UIMain.m \
	Sources/UIUtil.m \
	Sources/LocalizedStringTool.m \
	Sources/Mailbox.m \
	Sources/MailPal.m \
	Sources/ByteTool.m \
	Sources/Extension/NSData-Base64.m \
	Sources/Extension/NSData-BytesOperation.m \
	Sources/Extension/NSData-MD5.m \
	Sources/Extension/NSMutableData-CustomAppending.m \
	Sources/Extension/NSMutableData-Trim.m \
	Sources/Extension/NSNumber-Serialization.m \
	Sources/Extension/NSString-Converter.m \
	Sources/Extension/NSString-Filter.m \
	Sources/Extension/NSString-Validate.m \
	Sources/Pantomime/CWCacheManager.m \
	Sources/Pantomime/CWCharset.m \
	Sources/Pantomime/CWConstants.m \
	Sources/Pantomime/CWContainer.m \
	Sources/Pantomime/CWDNSManager.m \
	Sources/Pantomime/CWFlags.m \
	Sources/Pantomime/CWFolder.m \
	Sources/Pantomime/CWFolderInformation.m \
	Sources/Pantomime/CWIMAPCacheManager.m \
	Sources/Pantomime/CWIMAPFolder.m \
	Sources/Pantomime/CWIMAPMessage.m \
	Sources/Pantomime/CWIMAPStore.m \
	Sources/Pantomime/CWISO8859_1.m \
	Sources/Pantomime/CWISO8859_10.m \
	Sources/Pantomime/CWISO8859_11.m \
	Sources/Pantomime/CWISO8859_13.m \
	Sources/Pantomime/CWISO8859_14.m \
	Sources/Pantomime/CWISO8859_15.m \
	Sources/Pantomime/CWISO8859_2.m \
	Sources/Pantomime/CWISO8859_3.m \
	Sources/Pantomime/CWISO8859_4.m \
	Sources/Pantomime/CWISO8859_5.m \
	Sources/Pantomime/CWISO8859_6.m \
	Sources/Pantomime/CWISO8859_7.m \
	Sources/Pantomime/CWISO8859_8.m \
	Sources/Pantomime/CWISO8859_9.m \
	Sources/Pantomime/CWInternetAddress.m \
	Sources/Pantomime/CWKOI8_R.m \
	Sources/Pantomime/CWKOI8_U.m \
	Sources/Pantomime/CWLocalCacheManager.m \
	Sources/Pantomime/CWLocalFolder+maildir.m \
	Sources/Pantomime/CWLocalFolder+mbox.m \
	Sources/Pantomime/CWLocalFolder.m \
	Sources/Pantomime/CWLocalMessage.m \
	Sources/Pantomime/CWLocalStore.m \
	Sources/Pantomime/CWMD5.m \
	Sources/Pantomime/CWMIMEMultipart.m \
	Sources/Pantomime/CWMIMEUtility.m \
	Sources/Pantomime/CWMacOSXGlue.m \
	Sources/Pantomime/CWMessage.m \
	Sources/Pantomime/CWPOP3CacheManager.m \
	Sources/Pantomime/CWPOP3CacheObject.m \
	Sources/Pantomime/CWPOP3Folder.m \
	Sources/Pantomime/CWPOP3Message.m \
	Sources/Pantomime/CWPOP3Store.m \
	Sources/Pantomime/CWParser.m \
	Sources/Pantomime/CWPart.m \
	Sources/Pantomime/CWRegEx.m \
	Sources/Pantomime/CWSMTP.m \
	Sources/Pantomime/CWService.m \
	Sources/Pantomime/CWTCPConnection.m \
	Sources/Pantomime/CWURLName.m \
	Sources/Pantomime/CWUUFile.m \
	Sources/Pantomime/CWVirtualFolder.m \
	Sources/Pantomime/CWWINDOWS_1250.m \
	Sources/Pantomime/CWWINDOWS_1251.m \
	Sources/Pantomime/CWWINDOWS_1252.m \
	Sources/Pantomime/CWWINDOWS_1253.m \
	Sources/Pantomime/CWWINDOWS_1254.m \
	Sources/Pantomime/NSData+Extensions.m \
	Sources/Pantomime/NSFileManager+Extensions.m \
	Sources/Pantomime/NSScanner+Extensions.m \
	Sources/Pantomime/NSString+Extensions.m \
	Sources/Pantomime/io.m

CC=/usr/local/bin/arm-apple-darwin-gcc
CXX=/usr/local/bin/arm-apple-darwin-g++
CFLAGS=-DMACOSX -fsigned-char -I$(SRCROOT)/Sources \
	-I$(SRCROOT)/Sources/Extension \
	-I$(SRCROOT)/Sources/Pantomime
LDFLAGS=-Wl,-syslibroot,/usr/local/arm-apple-darwin/heavenly \
				-ObjC \
				-lobjc \
				-lcrypto \
				-lssl \
				-lsqlite3 \
				-liconv \
				-framework CoreFoundation \
				-framework Foundation \
				-framework UIKit \
				-framework LayerKit \
				-framework CoreGraphics \
				-framework GraphicsServices \
				-framework AudioToolbox \
				-framework MusicLibrary \
				-framework Message \
				-framework CFNetwork
LD=$(CC)

WRAPPER_NAME=$(PRODUCT_NAME).app
EXECUTABLE_NAME=$(PRODUCT_NAME)
SOURCES_ABS=$(addprefix $(SRCROOT)/,$(SOURCES))
INFOPLIST_ABS=$(addprefix $(SRCROOT)/,$(INFOPLIST_FILE))
OBJECTS=\
	$(patsubst %.c,%.o,$(filter %.c,$(SOURCES))) \
	$(patsubst %.cc,%.o,$(filter %.cc,$(SOURCES))) \
	$(patsubst %.cpp,%.o,$(filter %.cpp,$(SOURCES))) \
	$(patsubst %.m,%.o,$(filter %.m,$(SOURCES))) \
	$(patsubst %.mm,%.o,$(filter %.mm,$(SOURCES)))
OBJECTS_ABS=$(addprefix $(CONFIGURATION_TEMP_DIR)/,$(OBJECTS))
APP_ABS=$(BUILT_PRODUCTS_DIR)/$(WRAPPER_NAME)
PRODUCT_ABS=$(APP_ABS)/$(EXECUTABLE_NAME)

all: $(PRODUCT_ABS)
	cp *.png $(APP_ABS)
	mkdir -p $(APP_ABS)/English.lproj
	mkdir -p $(APP_ABS)/zh_CN.lproj
	cp English.lproj/*.strings $(APP_ABS)/English.lproj
	cp zh_CN.lproj/*.strings $(APP_ABS)/zh_CN.lproj

$(PRODUCT_ABS): $(APP_ABS) $(OBJECTS_ABS)
	$(LD) $(LDFLAGS) -o $(PRODUCT_ABS) $(OBJECTS_ABS)

$(APP_ABS): $(INFOPLIST_ABS)
	mkdir -p $(APP_ABS)
	cp $(INFOPLIST_ABS) $(APP_ABS)/

$(CONFIGURATION_TEMP_DIR)/%.o: $(SRCROOT)/%.m
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

clean:
	echo rm -f $(OBJECTS_ABS)
	echo rm -rf $(APP_ABS)

