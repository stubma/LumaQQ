/*
 * LumaQQ - Cross platform QQ client, special edition for Mac
 *
 * Copyright (C) 2007 luma <stubma@163.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

#pragma mark -
#pragma mark for internal use

//////////////////////////////////////////////////////
// default server list

#define kLQUDPServerCount 18
const static id LQUDPServers[] = {
	@"sz.tencent.com",
	@"sz2.tencent.com",
	@"sz3.tencent.com",
	@"sz4.tencent.com",
	@"sz5.tencent.com",
	@"sz6.tencent.com",
	@"sz7.tencent.com",
	@"61.144.238.155",
	@"61.144.238.156",
	@"202.96.170.163",
	@"202.96.170.164",
	@"219.133.38.129",
	@"219.133.38.130",
	@"219.133.38.43",
	@"219.133.38.44",
	@"219.133.40.215",
	@"219.133.40.216",
	@"219.133.48.100"
};

#define kLQTCPServerCount 5
const static id LQTCPServers[] = {
	@"219.133.60.173",
	@"tcpconn.tencent.com",
    @"tcpconn2.tencent.com",
    @"tcpconn3.tencent.com",
    @"tcpconn4.tencent.com"
};

// some internal notification
// object is connection
// a "DataItem" key in user info dict
#define kQQSocketDataAvailableNotificationName @"SocketDataAvailableNotificationName"
#define kUserInfoDataItem @"DataItem"

// custom face start agent server
#define kStartAgentServer @"219.133.40.128"
#define kStartAgentServerPort 443

// custom head upload server
#define kCustomHeadUploadServer @"cface.qq.com"
// custom head download server
#define kCustomHeadDownloadServer @"cface_tms.qq.com"

// there is a copy in PreferenceConstants.h
#define kQQPortUDP 8000
#define kQQPortTCP 80
#define kQQProtocolUDP @"UDP"
#define kQQProtocolTCP @"TCP"
#define kQQProxyNone @"None"
#define kQQProxyHTTP @"HTTP"
#define kQQProxySocks4 @"Socks4"
#define kQQProxySocks5 @"Socks5"

// key name of local computer guid
#define kQQLocalComputerGUIDKeyName @"edu.tsinghua.luma.lumaqq.LocalComputerGUID"

// qq key length
static const int kQQKeyLength = 16;

// max resend count
static const int kQQMaxResend = 5;

// max custom face fragment length
static const int kQQMaxCustomFaceFragmentLength = 1024;

// max characters of sms message and sender name
static const int kQQMaxSMSCharacters = 54;

// max sms sender name
static const int kQQMaxSMSSenderName = 13;

// max mobile length
static const int kQQMaxMobileLength = 18;

// max level get count
static const int kQQMaxLevelRequest = 70;

// max signature request
static const int kQQMaxSignatureRequest = 33;

// max member info request
static const int kQQMaxMemberInfoRequest = 30;

// max message fragment length
static const int kQQMaxMessageFragmentLength = 700;

// max upload group friend count
static const int kQQMaxUploadGroupFriendCount = 150;

// max custom head info get count
static const int kQQMaxGetCustomHeadInfoRequest = 20;

// md5 of QQ.exe of 2007
static const char kQQ2007ExeMD5[] = {
	0x56, 0x4E, 0xC8, 0xFB, 
	0x0A, 0x4F, 0xEF, 0xB3, 
	0x7A, 0x5D, 0xD8, 0x86, 
	0x0F, 0xAC, 0xE5, 0x1A
};

#pragma mark -
#pragma mark qq version

// 2006 final release
static const UInt16 kQQVersion2006 = 0x0F5F;

// 2007 final release
static const UInt16 kQQVersion2007 = 0x111D;

// current version
#define kQQVersionCurrent kQQVersion2007

#pragma mark -
#pragma mark qq protocol family constant

#define kQQFamilyBasic 1
#define kQQFamilyAgent 2
#define kQQFamilyAuxiliary 3
#define kQQFamilyUnknown 4

static const char kQQHeaderBasicFamily = 0x02;
static const char kQQTailBasicFamily = 0x03;
static const char kQQHeaderAuxiliaryFamily = 0x03;
static const char kQQHeaderAgentFamily = 0x05;
static const char kQQTailAgentFamily = 0x03;

#pragma mark -
#pragma mark language code

static const int kQQLanguageChinese = 0x0804;
static const int kQQLanguageEnglish = 0x0409;

#pragma mark -
#pragma mark encoding

static const int kQQEncodingGBK = 0x8602;
static const int kQQEncodingASCII = 0x0000;	
static const int kQQEncodingUTF8 = 0x0001;
static const int kQQEncodingDefault = 0x8602;

#pragma mark -
#pragma mark user status

static const char kQQStatusOnline = 0x0A;
static const char kQQStatusOffline = 0x14;
static const char kQQStatusAway = 0x01E;
static const char kQQStatusHidden = 0x28;
static const char kQQStatusBusy = 0x32;
static const char kQQStatusQMe = 0x3C;
static const char kQQStatusMute = 0x46;

#pragma mark -
#pragma mark user property

/** 性别-男 */
static const char kQQGenderMale = 0x0;
/** 性别-女 */
static const char kQQGenderFemale = 0x1;
/** 性别-未知 */
static const char kQQGenderUnknown = 0xFF;

// auth type
static const char kQQAuthNo = 0;
static const char kQQAuthNeed = 1;
static const char kQQAuthReject = 2;
static const char kQQAuthQuestion = 3;

// contact visibility
static const char kQQContactVisibilityAll = 0;
static const char kQQContactVisibilityFriend = 1;
static const char kQQContactVisibilityNo = 2;

// user flag mask
// member
static const int kQQFlagMember = 0x02;
// vip user
static const int kQQFlagVIP = 0x04;
// mobile qq user
static const int kQQFlagMobile = 0x20;
// bind to mobile 
static const int kQQFlagBind = 0x40;
// has camera, also known as "VQQ"
static const int kQQFlagCamera = 0x80;
// SMS monthly user, must be bind to mobile first
static const int kQQFlagSMSMonthly = 0x400;
// mobile chat
static const int kQQFlagMobileChat = 0x1000;
// Rich status user
static const int kQQFlagRichStatus = 0x2000;
// QQ ring
static const int kQQFlagRing = 0x8000;
// TM user
static const int kQQFlagTM = 0x40000;
// QQ Home user
static const int kQQFlagHome = 0x80000;
// Hosting user
static const int kQQFlagHosting = 0x100000;

// user flag ex bit number
// QQ album
static const int kQQFlagExAlbum = 0x0;
// QQ show VIP
static const int kQQFlagExShowVIP = 0x02;
// QQ tang
static const int kQQFlagExTang = 0x03;
// QQ Pet
static const int kQQFlagExPet = 0x04;
// Super QQ game user
static const int kQQFlagExSuperGameUser = 0x05;
// has signature
static const int kQQFlagExHasSignature = 0x06;
// QQ home VIP user
static const int kQQFlagExHomeVIP = 0x07;
// QQ IVR
static const int kQQFlagExIVR = 0x09;
// QQ Love user
static const int kQQFlagExLove = 0x0A;
// has custom head
static const int kQQFlagExHasCustomHead = 0x0C;
// QQ flash show
static const int kQQFlagExFlashShow = 0x0D;
// QQ space
static const int kQQFlagExSpace = 0x0E;
// QQ fantasy
static const int kQQFlagExFantasy = 0x10;
// QQ battle zone
static const int kQQFlagExBattleZone = 0x11;
// 3D avatar user, also named "3D show"
static const int kQQFlagEx3DAvatar = 0x12;
// QQ shop keeper
static const int kQQFlagExShopKeeper = 0x13;
// QQ shop customer
static const int kQQFlagExShopCustomer = 0x14;
// QQ music user
static const int kQQFlagExMusic = 0x15;
// R2Beat user
static const int kQQFlagExR2Beat = 0x17;
// QQ tang VIP
static const int kQQFlagExTangVIP = 0x1A;
// 3D quick show
static const int kQQFlagEx3DQuickShow = 0x1B;
// QQ SG user
static const int kQQFlagExSG = 0x1D;
// QQ magazine user
static const int kQQFlagExMagazine = 0x1E;
// QQ HuaXia
static const int kQQFlagExHuaXia = 0x20;
// QQ download
static const int kQQFlagExDownload = 0x21;
// SoSo user
static const int kQQFlagExSoSo = 0x22;
// QQ singer
static const int kQQFlagExSinger = 0x23;
// DNA 20 user
static const int kQQFlagExDNA20 = 0x26;
// R2Beat VIP
static const int kQQFlagExR2BeatVIP = 0x27;
// QQ pet VIP
static const int kQQFlagExPetVIP = 0x28;
// QQ video
static const int kQQFlagExVideo = 0x29;
// QQ mail user
static const int kQQFlagExMail = 0x2A;
// 3G user
static const int kQQFlagEx3G = 0x2B;
// QQ show 20
static const int kQQFlagExShow20 = 0x2C;
// QQ talk user
static const int kQQFlagExTalk = 0x2D;
// QQ bookmark
static const int kQQFlagExBookmark = 0x2E;
// QQ Live user
static const int kQQFlagExLive = 0x2F;
// Fly QQ, must be a bind to mobile user first
static const int kQQFlagExFlyQQ = 0x31;
// QQ Pet ex
static const int kQQFlagExPetEx = 0x32;

// next start position of get friend list reply
static const UInt16 kQQPositionEnd = 0xFFFF;

// friend type
static const int kQQTypeUser = 0x1;
static const int kQQTypeCluster = 0x4;

#pragma mark -
#pragma mark cluster property

// cluster level flag mask
static const int kQQFlagAdvancedCluster = 0x10;

// cluster type
static const char kQQClusterTypeTemp = 0x00;
static const char kQQClusterTypePermanent = 0x01;

// cluster auth type
static const char kQQClusterAuthNo = 0x01;
static const char kQQClusterAuthNeed = 0x02;
static const char kQQClusterAuthReject = 0x03;

/** 临时群类型常量 - 多人对话 */
static const char kQQTempClusterTypeDialog = 0x01;
/** 临时群类型常量 - 讨论组 */
static const char kQQTempClusterTypeSubject = 0x02;

/*
 * cluster message setting constant
 */
static const char kQQClusterMessageAccept = 0x00;
static const char kQQClusterMessageAutoEject = 0x01;
static const char kQQClusterMessageAcceptNoPrompt = 0x02;
static const char kQQClusterMessageBlock = 0x03;
static const char kQQClusterMessageDisplayCount = 0x04;
static const char kQQClusterMessageClearServerSetting = 0x0F;

/*
 * cluster notification right
 */
static const char kQQClusterNotificationAllowUserSend = 0x01;
static const char kQQClusterNotificationAllowAdminSend = 0x02;

/*
 * cluster name card modification right
 */
static const char kQQClusterNameCardAllowAdminModify = 0x02;

/*
 * cluster channel modification mask
 */
static const char kQQClusterOperationMaskNotificationRight = 0x01;
static const char kQQClusterOperationMaskChannel = 0x02;

#pragma mark -
#pragma mark basic family command

/** 命令常量 - 登出 */
static const UInt16 kQQCommandLogout = 0x0001;
/** 命令常量 - 保持在线状态 */
static const UInt16 kQQCommandKeepAlive = 0x0002;
/** 命令常量 - 修改自己的信息 */
static const UInt16 kQQCommandModifyInfo = 0x0004;
/** 命令常量 - 查找用户 */
static const UInt16 kQQCommandSearch = 0x0005;
/** 命令常量 - 得到好友信息 */
static const UInt16 kQQCommandGetUserInfo = 0x0006;
/** 命令常量 - 删除一个好友 */
static const UInt16 kQQCommandDeleteFriend = 0x000A;
/** 命令常量 - 发送验证信息 */
static const UInt16 kQQCommandAddFriendAuth = 0x000B;
/** 命令常量 - 改变自己的在线状态 */
static const UInt16 kQQCommandChangeStatus = 0x000D;
/** 命令常量 - 确认收到了系统消息 */
static const UInt16 kQQCommandAcknowledgeSystemMessage = 0x0012;
/** 命令常量 - 发送消息 */
static const UInt16 kQQCommandSendIM = 0x0016;
/** 命令常量 - 接收消息 */
static const UInt16 kQQCommandReceivedIM = 0x0017;
/** 命令常量 - 把自己从对方好友名单中删除 */
static const UInt16 kQQCommandRemoveSelf = 0x001C;
/** 请求一些操作需要的密钥，比如文件中转，视频也有可能 */
static const UInt16 kQQCommandGetKey = 0x001D;
/** 命令常量 - 登陆 */
static const UInt16 kQQCommandLogin = 0x0022;
/** 命令常量 - 得到好友列表 */
static const UInt16 kQQCommandGetFriendList = 0x0026;
/** 命令常量 - 得到在线好友列表 */
static const UInt16 kQQCommandGetOnlineOp = 0x0027;
/** 命令常量 - 发送短消息 */
static const UInt16 kQQCommandSendSMS = 0x002D;
/** 命令常量 - 群相关命令 */
static const UInt16 kQQCommandCluster = 0x0030;
/** 命令常量 - 分组数组操作 */
static const UInt16 kQQCommandGroupDataOp = 0x003C;
/** 命令常量 - 上传分组中的好友QQ号列表 */
static const UInt16 kQQCommandUploadGroupFriend = 0x003D;
/** 命令常量 - 好友相关数据操作 */
static const UInt16 kQQCommandFriendDataOp = 0x003E;
/** 命令常量 - 下载分组中的好友QQ号列表 */
static const UInt16 kQQCommandGetFriendGroup = 0x0058;
/** 命令常量 - 好友等级信息相关操作 */
static const UInt16 kQQCommandLevelOp = 0x005C; 
/** 命令常量 - 隐私数据操作 */
static const UInt16 kQQCommandPrivacyOp = 0x005E;
/** 命令常量 - 群数据操作命令 */
static const UInt16 kQQCommandClusterDataOp = 0x005F;
/** 命令常量 - 好友高级查找 */
static const UInt16 kQQCommandAdvancedSearch = 0x0061;
/** command - get server token */
static const UInt16 kQQCommandGetServerToken = 0x0062;
/** 命令常量 - 属性操作 */
static const UInt16 kQQCommandPropertyOp = 0x0065;
/** 命令常量 - 临时会话操作 */
static const UInt16 kQQCommandTempSessionOp = 0x0066;
/** 命令常量 - 个性签名的操作 */
static const UInt16 kQQCommandSignatureOp = 0x0067;
/** 命令常量 - 系统通知 */
static const UInt16 kQQCommandSystemNotification = 0x0080;
/** 命令常量 - 好友改变状态 */
static const UInt16 kQQCommandFriendStatusChanged = 0x0081;
/** select login server */
static const UInt16 kQQCommandSelectServer = 0x0091;
/** 命令常量 - 天气操作 */
static const UInt16 kQQCommandWeatherOp = 0x00A6;
/**
 * 命令常量 - 添加好友
 * This is add friend command used in 2005. Before 2005, another command
 * which is deprecated is used
 */
static const UInt16 kQQCommandAddFriend = 0x00A7;
/** 命令常量 - 发送验证消息 */
static const UInt16 kQQCommandAuthorize = 0x00A8;
/** 命令常量 - 请求验证信息 */
static const UInt16 kQQCommandAuthInfoOp = 0x00AE;
/** 命令常量 - 认证问题操作 */
static const UInt16 kQQCommandAuthQuestionOp = 0x00B7;
/** 命令常量 - 请求登陆令牌 */
static const UInt16 kQQCommandGetLoginToken = 0x00BA;
/** command - password verify */
static const UInt16 kQQCommandPasswordVerify = 0x00DD;
/** 命令常量 - 未知命令，调试用途 */
static const UInt16 kQQCommandUnknown = 0xFFFF;

#pragma mark -
#pragma mark agent family command

/** 命令常量 - 请求中转 */
static const UInt16 kQQCommandRequestAgent = 0x0021;
/** 命令常量 - 请求得到自定义表情 */
static const UInt16 kQQCommandRequestFace = 0x0022;
/** 命令常量 - 开始传送 */
static const UInt16 kQQCommandTransfer = 0x0023;
/** 命令常量 - 请求开始传送 */
static const UInt16 kQQCommandRequestBegin = 0x0026;

#pragma mark -
#pragma mark auxiliary family command

// keep in mind, command of auxiliary is 1 byte but we set it to 2 bytes
static const UInt16 kQQCommandGetCustomHeadInfo = 0x04;
static const UInt16 kQQCommandGetCustomHeadData = 0x02;

#pragma mark -
#pragma mark sub command

// 0x001D
static const char kQQSubCommandGet03Key = 0x03;
static const char kQQSubCommandGetFileAgentKey = 0x04;
static const char kQQSubCommandGet06Key = 0x06;
static const char kQQSubCommandGet07Key = 0x07;
static const char kQQSubCommandGet08Key = 0x08;
static const char kQQSubCommandGet0AKey = 0x0A;
static const char kQQSubCommandGet0BKey = 0x0B;
static const char kQQSubCommandGet0CKey = 0x0C;
static const char kQQSubCommandGet0EKey = 0x0E;

// search user
static const char kQQSubCommandSearchAll = 0x31;
static const char kQQSubCommandSearchByNick = 0x32;
static const char kQQSubCommandSearchByQQ = 0x33;

// advanced search user
static const char kQQSubCommandSearchNormalUser = 0x01;

// download friend group
static const char kQQSubCommandDownloadFriendGroup = 0x01;

// group data op
static const char kQQSubCommandDownloadGroupName = 0x01;
static const char kQQSubCommandUploadGroupName = 0x02;

// 0x0027
static const char kQQSubCommandGetOnlineFriend = 0x02;
static const char kQQSubCommandGetSystemService = 0x03;

// get property
static const char kQQSubCommandGetUserProperty = 0x01;

// weather op sub command
static const char kQQSubCommandGetWeather = 0x01;

// friend data op
static const char kQQSubCommandBatchGetFriendRemark = 0x00;
static const char kQQSubCommandUploadFriendRemark = 0x01;
static const char kQQSubCommandRemoveFriendFromList = 0x02;
static const char kQQSubCommandGetFriendRemark = 0x03;
static const char kQQSubCommandModifyRemarkName = 0x05;

// sub command of 0x0062 
/** get server token */
static const char kQQSubCommandGetServerToken = 0x00;

// sub command of 0x00B7
// get my question and answer
static const char kQQSubCommandGetMyQuestion = 0x01;
// modify question
static const char kQQSubCommandModifyQuestion = 0x02;
/** 得到问题 */
static const char kQQSubCommandGetUserQuestion = 0x03;
/** 回答问题 */
static const char kQQSubCommandAnswerQuestion = 0x04;

// sub command of 0x00A8
/** 普通验证，即验证码验证 */
static const char kQQSubCommandNormalAuthorize = 0x02;
// approve and add him
static const char kQQSubCommandApproveAuthorizationAndAddHim = 0x03;
// approve authorization
static const char kQQSubCommandApproveAuthorization = 0x04;
// reject authorization
static const char kQQSubCommandRejectAuthorization = 0x05;
/** 双重验证，即验证码和问题双重验证 */
static const char kQQSubCommandDoubleAuthorize = 0x10;

// 0x00AE
/** 请求验证信息 */
static const char kQQSubCommandGetAuthInfo = 0x01;
/** 通过提交验证码来得到验证信息 */
static const char kQQSubCommandGetAuthInfoByVerifyCode = 0x02;

// 0x00BA的子命令
/** 登录认证 */
static const char kQQSubCommandGetLoginToken = 0x01;
/** 刷新验证码图片 */
static const char kQQSubCommandSubmitVerifyCode = 0x02;
/** 扩展的登录认证命令 */
static const char kQQSubCommandGetLoginTokenEx = 0x03;
/** extended submit command */
static const char kQQSubCommandSubmitVerifyCodeEx = 0x04;

// 0x005E的子命令
/** 只能通过号码搜到我 */
static const char kQQSubCommandSearchMeByQQOnly = 0x03;
/** 共享地理位置 */
static const char kQQSubCommandShareGeography = 0x04;

// 0x005C的子命令
/** 得到好友等级信息 */
static const char kQQSubCommandGetFriendLevel = 0x02;

// 0x005F的子命令	
/** 得到群在线成员 */
static const char kQQSubCommandGetClusterOnlineMember = 0x01; 

// 子命令常量，用于子命令0x0067
/** 修改个性签名 */
static const char kQQSubCommandModifySignature = 0x01;
/** 删除个性签名 */
static const char kQQSubCommandDeleteSignature = 0x02;
/** 得到个性签名 */
static const char kQQSubCommandGetSignature = 0x03;

// system notification sub command, in packet, the command is represented as string!
/** 自己被别人加为好友 */
static const char kQQSubCommandOtherAddMe = 1;
/** 
* 对方请求加我为好友
* 当对方不使用0x00A8命令发送认证消息，才会收到此系统通知, deprecated in QQ 2005
*/
static const char kQQSubCommandOtherRequestAddMe = 2;
/** 对方同意加他为好友 */
static const char kQQSubCommandOtherApproveMyRequest = 3;
/** 对方拒绝加他为好友 */
static const char kQQSubCommandOtherRejectMyRequest = 4;
/** 广告 */
static const char kQQSubCommandAdvertisement = 6;
/** 更新提示 */
static const char kQQSubCommandSoftwareUpdate = 9;
/** 对方把我加为了好友 */
static const char kQQSubCommandOtherAddMeEx = 40;
/** 
* 对方请求加你为好友
* 当对方使用0x00A8命令发送认证消息，才会收到此系统通知
*/
static const char kQQSubCommandOtherRequestAddMeEx = 41;
/** 对方同意加他为好友，同时加我为好友 */
static const char kQQSubCommandOtherApproveMyRequestAndAddMe = 43;

// 0x0066
/** send temp session im */
static const char kQQSubCommandSendTempSessionIM = 0x01;

#pragma mark -
#pragma mark sub sub command

// sub command of 0x00AE
static const UInt16 kQQSubSubCommandGetUserAuthInfo = 0x0001;
static const UInt16 kQQSubSubCommandGetClusterAuthInfo = 0x0002;
static const UInt16 kQQSubSubCommandGetUserTempSessionAuthInfo = 0x0003;
static const UInt16 kQQSubSubCommandGetDeleteUserAuthInfo = 0x0006;
static const UInt16 kQQSubSubCommandGetModifyUserInfoAuthInfo = 0x0007;

#pragma mark -
#pragma mark cluster sub command

/*
 * Create cluster
 * QQ 2006 don't use this command any more, operation is conducted thru web
 */
static const char kQQSubCommandClusterCreate = 0x01;
/** 群操作命令 - 修改群成员 */
static const char kQQSubCommandClusterModifyMember = 0x02;
/** 群操作命令 - 修改群资料 */
static const char kQQSubCommandClusterModifyInfo = 0x03;
/** 群操作命令 - 得到群资料 */
static const char kQQSubCommandClusterGetInfo = 0x04;
/*
 * Activate cluster
 * QQ 2006 don't use this command any more, operation is conducted thru web
 */
static const char kQQSubCommandClusterActivate = 0x05;
/** 群操作命令 - 搜索群 */
static const char kQQSubCommandClusterSearch = 0x06;
/** 群操作命令 - 加入群 */
static const char kQQSubCommandClusterJoin = 0x07;
/** 群操作命令 - 加入群的验证消息 */
static const char kQQSubCommandClusterAuthorize = 0x08;
/** 群操作命令 - 退出群 */
static const char kQQSubCommandClusterExit = 0x09;
/** 
 * 群操作命令 - 发送群消息 
 * deprecated, use kQQSubCommandClusterSendIMEx
 */
static const char kQQSubCommandClusterSendIM = 0x0A;
/** 群操作命令 - 得到在线成员 */
static const char kQQSubCommandClusterGetOnlineMember = 0x0B;
/** 群操作命令 - 得到成员资料 */
static const char kQQSubCommandClusterGetMemberInfo	= 0x0C;
/** 群操作命令 - 修改群名片 */
static const char kQQSubCommandClusterModifyCard = 0x0E;
/** 群操作命令 - 批量得到成员群名片中的真实姓名 */
static const char kQQSubCommandClusterBatchGetCard = 0x0F;
/** 群操作命令 - 得到某个成员的群名片 */
static const char kQQSubCommandClusterGetCard = 0x10;
/** 群操作命令 - 提交组织架构到服务器 */
static const char kQQSubCommandClusterCommitOrganization = 0x11;
/** 群操作命令 - 从服务器获取组织架构 */
static const char kQQSubCommandClusterUpdateOrganization = 0x12;
/** 群操作命令 - 提交成员分组情况到服务器 */
static const char kQQSubCommandClusterCommitMemberGroup = 0x13;
/** 群操作命令 - 得到各种version id */
static const char kQQSubCommandClusterGetVersionID = 0x19;
/** 群操作命令 - 扩展格式的群消息 */
static const char kQQSubCommandClusterSendIMEx = 0x1A;
/** 群操作命令 - 设置成员角色 */
static const char kQQSubCommandClusterSetRole = 0x1B;
/** 群操作命令 - 转让自己的角色给他人 */
static const char kQQSubCommandClusterTransferRole = 0x1C;
/*
 * Dismiss cluster
 * QQ 2006 don't use this command any more, operation is conducted thru web
 */
static const char kQQSubCommandClusterDismiss = 0x1D;
// get message setting
static const char kQQSubCommandClusterGetMessageSetting = 0x20;
// change message setting
static const char kQQSubCommandClusterModifyMessageSetting = 0x21;
// get member last talk time
static const char kQQSubCommandClusterGetLastTalkTime = 0x22;
/** 群操作命令 - 创建临时群 */
static const char kQQSubCommandTempClusterCreate = 0x30;
/** 群操作命令 - 修改临时群成员列表 */
static const char kQQSubCommandTempClusterModifyMember = 0x31;
/** 群操作命令 - 退出临时群 */
static const char kQQSubCommandTempClusterExit = 0x32;
/** 群操作命令 - 得到临时群资料 */
static const char kQQSubCommandTempClusterGetInfo = 0x33;
/** 群操作命令 - 修改临时群资料 */
static const char kQQSubCommandTempClusterModifyInfo = 0x34;
/** 群操作命令 - 发送临时群消息 */
static const char kQQSubCommandTempClusterSendIM = 0x35;
/** 群操作命令 - 子群操作 */
static const char kQQSubCommandClusterSubOp = 0x36;
/** activate temp cluster */
static const char kQQSubCommandTempClusterActivate = 0x37;
// change cluster channel setting
static const char kQQSubCommandClusterModifyChannelSetting = 0x70;
// get cluster channel setting
static const char kQQSubCommandClusterGetChannelSetting = 0x71;

#pragma mark -
#pragma mark cluster sub sub command

/** 群操作子命令 - 添加成员，用在修改成员列表命令中 */
static const char kQQSubSubCommandAddMember = 0x01;
/** 群操作子命令 - 删除成员，用在修改成员列表命令中 */
static const char kQQSubSubCommandRemoveMember = 0x02;

/** 群操作子命令 - 得到多人对话列表 */
static const char kQQSubSubCommandGetDialogs = 0x01;
/** 群操作子命令 - 得到群内的讨论组列表 */
static const char kQQSubSubCommandGetSubjects = 0x02;

/** 群的搜索方式 - 根据群号搜索 */
static const char kQQSubSubCommandSearchClusterByID = 0x01;
/** 群的搜索方式 - 搜索示范群, QQ doesn't support this any more */
static const char kQQSubSubCommandSearchDemoCluster	= 0x02;

// for set role
static const char kQQSubSubCommandSetAdminRole = 0x01;
static const char kQQSubSubCommandUnsetAdminRole = 0x00;

// cluster auth sub command
static const char kQQSubSubCommandRequestJoinCluster = 0x01;
static const char kQQSubSubCommandApproveJoinCluster = 0x02;
static const char kQQSubSubCommandRejectJoinCluster = 0x03;

#pragma mark -
#pragma mark cluster member related flag

// cluster member flag
/** 群成员角色标志位 - 管理员 */
static const int kQQRoleAdmin = 0x01;
/** 群成员角色标志位 - 股东 */
static const int kQQRoleStockholder = 0x02;
/*
 * role - managed
 * managed means cluster admin can edit my name card
 */
static const int kQQRoleManaged = 0x08;

// join/exit cluster caused by
static const char kQQExitClusterDismissed = 0x01;
static const char kQQExitClusterActive = 0x02;
static const char kQQExitClusterPassive = 0x03;
static const char kQQJoinClusterPassive = 0x03;

// role changed caused by
static const char kQQClusterAdminRoleUnset = 0x00;
static const char kQQClusterAdminRoleSet = 0x01;
static const char kQQClusterOwnerRoleSet = 0xFF;

#pragma mark -
#pragma mark reply code

// ok, same for all command
static const char kQQReplyOK = 0;

// 0x00BA reply, also available for 0x00AE
static const char kQQReplyNeedVerifyCode = 0x01;

// reply of login
static const char kQQReplyServerBusy = 0x05;
static const char kQQReplyRedirect = 0x0A;
static const char kQQReplyLoginFailed = 0x09;

// reply of add friend
static const char kQQReplyAlreadyFriend = (char)0x99;

// reply of friend data op
static const char kQQReplyNoMoreRemark = 0x01;

// reply of get online op
static const char kQQReplyNoMoreOnline = 0xFF;

// reply of change status
static const char kQQReplyChangeStatusOK = 0x30;

// advanced search user
static const char kQQReplyNoMoreResult = 0x01;

// auth info op
static const char kQQReplyInvalidAuthInfo = 0x01;

// reply of cluster command
static const char kQQReplyNoSuchCluster = 0x02;
static const char kQQReplyTempClusterRemoved = 0x03;
static const char kQQReplyNotTempClusterMember = 0x04;
static const char kQQReplyNoInfoAvailable = 0x05;
static const char kQQReplyNotClusterMember = 0x0A;

// reply code of agent family, request agent command
static const UInt16 kQQReplyRequestAgentRedirect = 0x0001;
static const UInt16 kQQReplyRequestAgentRejected = 0x0003;

// reply code of temp session op
/** temp session im cached, maybe received is offline */
static const UInt16 kQQReplyTempSesionIMCached = 0x02;

// sub command of 0x00DD
/** password error */
static const char kQQReplyPasswordError = 0x34;
// need activate
static const char kQQReplyNeedActivate = 0x51;

#pragma mark -
#pragma mark IM type

// im type in ReceiveIMHeader class
/** from my friend */
static const UInt16 kQQIMTypeFriend = 0x0009;
/** from stranger */
static const UInt16 kQQIMTypeStranger = 0x000A;
/** mobile message, from normal bind user */
static const UInt16 kQQIMTypeBind = 0x000B;
/** mobile message - from mobile phone */
static const UInt16 kQQIMTypeMobile = 0x000C;
/** member login hint, nothing in packet, just a hint of last login ip and time */
static const UInt16 kQQIMTypeMemberLoginHint = 0x0012;
/** mobile message, mobile qq user */
static const UInt16 kQQIMTypeMobileQQ = 0x0013;
/** mobile message, mobile qq user (use mobile phone number) */
static const UInt16 kQQIMTypeMobileQQ2 = 0x0014;
/** friend property change notification */
static const UInt16 kQQIMTypePropertyChangedNotification = 0x001E;
/** temp session message */
static const UInt16 kQQIMTypeTempSession = 0x001F;
/** unknown type cluster message */
static const UInt16 kQQIMTypeClusterUnknown = 0x0020;
/** notifiaction of someone has joined a cluster */
static const UInt16 kQQIMTypeJoinedCluster = 0x0021;
/** notification of someone has exited a cluster */
static const UInt16 kQQIMTypeExitedCluster = 0x0022;
/** notification someone request to join cluster */
static const UInt16 kQQIMTypeRequestJoinCluster = 0x0023;
/** notification of someone approve me */	
static const UInt16 kQQIMTypeApprovedJoinCluster = 0x0024;
/** notification of someone reject me */
static const UInt16 kQQIMTypeRejectedJoinCluster = 0x0025;
/** cluster created notification */
static const UInt16 kQQIMTypeClusterCreated = 0x0026;
/** temp cluster message */
static const UInt16 kQQIMTypeTempCluster = 0x002A;
/** cluster message */
static const UInt16 kQQIMTypeCluster = 0x002B;
/** notification of cluster member role changed */
static const UInt16 kQQIMTypeClusterRoleChanged = 0x002C;
/** notification of cluster is dismissed */
static const UInt16 kQQIMTypeClusterDismissed = 0x002D;
/** cluster version id change notification */
static const UInt16 kQQIMTypeClusterVersionChanged = 0x002F;
/** system message */ 
static const UInt16 kQQIMTypeSystem = 0x0030;
/** signature change notification */
static const UInt16 kQQIMTypeSignatureChangedNotification = 0x0041;
/** custom head change notification */
static const UInt16 kQQIMTypeCustomHeadChangedNotification = 0x0049;
/** extended format friend message */
static const UInt16 kQQIMTypeFriendEx = 0x0084;
/** extended format stranger message */
static const UInt16 kQQIMTypeStrangerEx = 0x0085;

#pragma mark -
#pragma mark normal IM type

// 普通消息类型，normalIMHeader中的类型
/** normal text message */
static const UInt16 kQQNormalIMTypeText = 0x000B;

#pragma mark -
#pragma mark system im type

// system im type, lower than im type, used when the im is sent by system

/** kick out by system, occurred when your qq is logined elsewhere */
static const char kQQSystemIMTypeKickOut = 0x01;

#pragma mark -
#pragma mark im reply type

/** 消息回复类型 - 正常回复 */
static const char kQQIMReplyTypeManual = 0x01;
/** 消息回复类型 - 自动回复 */
static const char kQQIMReplyTypeAuto = 0x02;

#pragma mark -
#pragma mark sms type

static const char kQQSMSTypeHandFree = 0x20;

#pragma mark -
#pragma mark agent transfer type

static const UInt16 kQQAgentCustomFace = 1100;
static const UInt16 kQQAgentScreenscrap = 1000;
static const UInt16 kQQAgentReceive = 0;

#pragma mark -
#pragma mark custom face related

// custom face image source
static const char kQQImageSourceCustomFace = 0x1A;
static const char kQQImageSourceFile = 0x1C;
static const char kQQImageSourceScreenscrap = 0x1D;

// face tag in message
static const char kQQTagDefaultFace = 0x14;
static const char kQQTagCustomFace = 0x15;

// face existence flag
static const char kQQClusterCustomFace = 0x36;
static const char kQQClusterCustomFaceRef = 0x37;

// face type
static const char kQQFaceTypeCustomFace = 'e';
static const char kQQFaceTypeScreenscrap = 'k';