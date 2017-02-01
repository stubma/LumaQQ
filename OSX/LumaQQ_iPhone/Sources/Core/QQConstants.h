/*
 * LumaQQ - Cross platform QQ client, special edition for iPhone
 *
 * Copyright (C) 2007 luma <stubma@163.com>
 *
 * This program is free software you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

#import <Foundation/Foundation.h>

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

// triggered when login success
#define kLoginNotificationName @"Login"

// triggerred when logout
#define kLogoutNotificationName @"Logout"

// triggered when send normal im timeout
// object is dest object
// use kUserInfoMessage to get message string
#define kSendIMTimeoutNotificationName @"SendIMTimeout"
#define kUserInfoMessage @"UserInfoMessage"

// triggered when normal im sent ok
// object is user qq number
#define kSendIMOKNotificationName @"SendIMOK"

// triggered when send cluster im timeout
// object is dest object
// use kUserInfoMessage to get message string
#define kSendClusterIMTimeoutNotificationName @"SendClusterIMTimeout"

// triggered when send cluster im failed
// object is dest object
// use kUserInfoMessage to get message string
#define kSendClusterIMFailedNotificationName @"SendClusterIMFailed"

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
#define kQQPortTCPSecure 443
#define kQQProtocolUDP @"UDP"
#define kQQProtocolTCP @"TCP"
#define kQQProxyNone @"None"
#define kQQProxyHTTP @"HTTP"
#define kQQProxySocks4 @"Socks4"
#define kQQProxySocks5 @"Socks5"

// md5 of QQ.exe of 2007
static const char kQQ2007ExeMD5[] = {
	0x56, 0x4E, 0xC8, 0xFB, 
	0x0A, 0x4F, 0xEF, 0xB3, 
	0x7A, 0x5D, 0xD8, 0x86, 
	0x0F, 0xAC, 0xE5, 0x1A
};

// key name of local computer guid
#define kQQLocalComputerGUIDKeyName @"edu.tsinghua.luma.lumaqq.LocalComputerGUID"

// qq key length
#define kQQKeyLength 16

// max resend count
#define kQQMaxResend 5

// max custom face fragment length
#define kQQMaxCustomFaceFragmentLength 1024

// max characters of sms message and sender name
#define kQQMaxSMSCharacters 54

// max sms sender name
#define kQQMaxSMSSenderName 13

// max mobile length
#define kQQMaxMobileLength 18

// max level get count
#define kQQMaxLevelRequest 70

// max signature request
#define kQQMaxSignatureRequest 33

// max member info request
#define kQQMaxMemberInfoRequest 30

// max message fragment length
#define kQQMaxMessageFragmentLength 700

// max upload group friend count
#define kQQMaxUploadGroupFriendCount 150

// max custom head info get count
#define kQQMaxGetCustomHeadInfoRequest 20

#pragma mark -
#pragma mark qq version

// 2006 final release
#define kQQVersion2006 0x0F5F

// 2007 final release
#define kQQVersion2007 0x111D

// current version
#define kQQVersionCurrent kQQVersion2007

#pragma mark -
#pragma mark qq protocol family constant

#define kQQFamilyBasic 1
#define kQQFamilyAgent 2
#define kQQFamilyAuxiliary 3
#define kQQFamilyUnknown 4

#define kQQHeaderBasicFamily 0x02
#define kQQTailBasicFamily 0x03
#define kQQHeaderAuxiliaryFamily 0x03
#define kQQHeaderAgentFamily 0x05
#define kQQTailAgentFamily 0x03

#pragma mark -
#pragma mark encoding

#define kQQEncodingGBK 0x8602
#define kQQEncodingASCII 0x0000
#define kQQEncodingUTF8 0x0001
#define kQQEncodingDefault 0x8602

#pragma mark -
#pragma mark language code

#define kQQLanguageChinese 0x0804
#define kQQLanguageEnglish 0x0409

#pragma mark -
#pragma mark user status

#define kQQStatusOnline 0x0A
#define kQQStatusOffline 0x14
#define kQQStatusAway 0x01E
#define kQQStatusHidden 0x28
#define kQQStatusBusy 0x32
#define kQQStatusQMe 0x3C
#define kQQStatusMute 0x46

#pragma mark -
#pragma mark user property

/** 性别-男 */
#define kQQGenderMale 0x0
/** 性别-女 */
#define kQQGenderFemale 0x1
/** 性别-未知 */
#define kQQGenderUnknown 0xFF

// auth type
#define kQQAuthNo 0
#define kQQAuthNeed 1
#define kQQAuthReject 2
#define kQQAuthQuestion 3

// contact visibility
#define kQQContactVisibilityAll 0
#define kQQContactVisibilityFriend 1
#define kQQContactVisibilityNo 2

// user flag mask
// member
#define kQQFlagMember 0x02
// vip user
#define kQQFlagVIP 0x04
// mobile qq user
#define kQQFlagMobile 0x20
// bind to mobile 
#define kQQFlagBind 0x40
// has camera, also known as "VQQ"
#define kQQFlagCamera 0x80
// SMS monthly user, must be bind to mobile first
#define kQQFlagSMSMonthly 0x400
// mobile chat
#define kQQFlagMobileChat 0x1000
// Rich status user
#define kQQFlagRichStatus 0x2000
// QQ ring
#define kQQFlagRing 0x8000
// TM user
#define kQQFlagTM 0x40000
// QQ Home user
#define kQQFlagHome 0x80000
// Hosting user
#define kQQFlagHosting 0x100000

// user flag ex bit number
// QQ album
#define kQQFlagExAlbum 0x0
// QQ show VIP
#define kQQFlagExShowVIP 0x02
// QQ tang
#define kQQFlagExTang 0x03
// QQ Pet
#define kQQFlagExPet 0x04
// Super QQ game user
#define kQQFlagExSuperGameUser 0x05
// has signature
#define kQQFlagExHasSignature 0x06
// QQ home VIP user
#define kQQFlagExHomeVIP 0x07
// QQ IVR
#define kQQFlagExIVR 0x09
// QQ Love user
#define kQQFlagExLove 0x0A
// has custom head
#define kQQFlagExHasCustomHead 0x0C
// QQ flash show
#define kQQFlagExFlashShow 0x0D
// QQ space
#define kQQFlagExSpace 0x0E
// QQ fantasy
#define kQQFlagExFantasy 0x10
// QQ battle zone
#define kQQFlagExBattleZone 0x11
// 3D avatar user, also named "3D show"
#define kQQFlagEx3DAvatar 0x12
// QQ shop keeper
#define kQQFlagExShopKeeper 0x13
// QQ shop customer
#define kQQFlagExShopCustomer 0x14
// QQ music user
#define kQQFlagExMusic 0x15
// R2Beat user
#define kQQFlagExR2Beat 0x17
// QQ tang VIP
#define kQQFlagExTangVIP 0x1A
// 3D quick show
#define kQQFlagEx3DQuickShow 0x1B
// QQ SG user
#define kQQFlagExSG 0x1D
// QQ magazine user
#define kQQFlagExMagazine 0x1E
// QQ HuaXia
#define kQQFlagExHuaXia 0x20
// QQ download
#define kQQFlagExDownload 0x21
// SoSo user
#define kQQFlagExSoSo 0x22
// QQ singer
#define kQQFlagExSinger 0x23
// DNA 20 user
#define kQQFlagExDNA20 0x26
// R2Beat VIP
#define kQQFlagExR2BeatVIP 0x27
// QQ pet VIP
#define kQQFlagExPetVIP 0x28
// QQ video
#define kQQFlagExVideo 0x29
// QQ mail user
#define kQQFlagExMail 0x2A
// 3G user
#define kQQFlagEx3G 0x2B
// QQ show 20
#define kQQFlagExShow20 0x2C
// QQ talk user
#define kQQFlagExTalk 0x2D
// QQ bookmark
#define kQQFlagExBookmark 0x2E
// QQ Live user
#define kQQFlagExLive 0x2F
// Fly QQ, must be a bind to mobile user first
#define kQQFlagExFlyQQ 0x31
// QQ Pet ex
#define kQQFlagExPetEx 0x32

// next start position of get friend list reply
#define kQQPositionEnd 0xFFFF

// friend type
#define kQQTypeUser 0x1
#define kQQTypeCluster 0x4

#pragma mark -
#pragma mark cluster property

// cluster level flag mask
#define kQQFlagAdvancedCluster 0x10

// cluster type
#define kQQClusterTypeTemp 0x00
#define kQQClusterTypePermanent 0x01

// cluster auth type
#define kQQClusterAuthNo 0x01
#define kQQClusterAuthNeed 0x02
#define kQQClusterAuthReject 0x03

/** 临时群类型常量 - 多人对话 */
#define kQQTempClusterTypeDialog 0x01
/** 临时群类型常量 - 讨论组 */
#define kQQTempClusterTypeSubject 0x02

/*
 * cluster message setting constant
 */
#define kQQClusterMessageAccept 0x00
#define kQQClusterMessageAutoEject 0x01
#define kQQClusterMessageAcceptNoPrompt 0x02
#define kQQClusterMessageBlock 0x03
#define kQQClusterMessageDisplayCount 0x04
#define kQQClusterMessageClearServerSetting 0x0F

/*
 * cluster notification right
 */
#define kQQClusterNotificationAllowUserSend 0x01
#define kQQClusterNotificationAllowAdminSend 0x02

/*
 * cluster name card modification right
 */
#define kQQClusterNameCardAllowAdminModify 0x02

/*
 * cluster channel modification mask
 */
#define kQQClusterOperationMaskNotificationRight 0x01
#define kQQClusterOperationMaskChannel 0x02

#pragma mark -
#pragma mark basic family command

/** 命令常量 - 登出 */
#define kQQCommandLogout 0x0001
/** 命令常量 - 保持在线状态 */
#define kQQCommandKeepAlive 0x0002
/** 命令常量 - 修改自己的信息 */
#define kQQCommandModifyInfo 0x0004
/** 命令常量 - 查找用户 */
#define kQQCommandSearch 0x0005
/** 命令常量 - 得到好友信息 */
#define kQQCommandGetUserInfo 0x0006
/** 命令常量 - 删除一个好友 */
#define kQQCommandDeleteFriend 0x000A
/** 命令常量 - 发送验证信息 */
#define kQQCommandAddFriendAuth 0x000B
/** 命令常量 - 改变自己的在线状态 */
#define kQQCommandChangeStatus 0x000D
/** 命令常量 - 确认收到了系统消息 */
#define kQQCommandAcknowledgeSystemMessage 0x0012
/** 命令常量 - 发送消息 */
#define kQQCommandSendIM 0x0016
/** 命令常量 - 接收消息 */
#define kQQCommandReceivedIM 0x0017
/** 命令常量 - 把自己从对方好友名单中删除 */
#define kQQCommandRemoveSelf 0x001C
/** 请求一些操作需要的密钥，比如文件中转，视频也有可能 */
#define kQQCommandGetKey 0x001D
/** 命令常量 - 登陆 */
#define kQQCommandLogin 0x0022
/** 命令常量 - 得到好友列表 */
#define kQQCommandGetFriendList 0x0026
/** 命令常量 - 得到在线好友列表 */
#define kQQCommandGetOnlineOp 0x0027
/** 命令常量 - 发送短消息 */
#define kQQCommandSendSMS 0x002D
/** 命令常量 - 群相关命令 */
#define kQQCommandCluster 0x0030
/** 命令常量 - 分组数组操作 */
#define kQQCommandGroupDataOp 0x003C
/** 命令常量 - 上传分组中的好友QQ号列表 */
#define kQQCommandUploadGroupFriend 0x003D
/** 命令常量 - 好友相关数据操作 */
#define kQQCommandFriendDataOp 0x003E
/** 命令常量 - 下载分组中的好友QQ号列表 */
#define kQQCommandGetFriendGroup 0x0058
/** 命令常量 - 好友等级信息相关操作 */
#define kQQCommandLevelOp 0x005C 
/** 命令常量 - 隐私数据操作 */
#define kQQCommandPrivacyOp 0x005E
/** 命令常量 - 群数据操作命令 */
#define kQQCommandClusterDataOp 0x005F
/** 命令常量 - 好友高级查找 */
#define kQQCommandAdvancedSearch 0x0061
/** command - get server token */
#define kQQCommandGetServerToken 0x0062
/** 命令常量 - 属性操作 */
#define kQQCommandPropertyOp 0x0065
/** 命令常量 - 临时会话操作 */
#define kQQCommandTempSessionOp 0x0066
/** 命令常量 - 个性签名的操作 */
#define kQQCommandSignatureOp 0x0067
/** 命令常量 - 系统通知 */
#define kQQCommandSystemNotification 0x0080
/** 命令常量 - 好友改变状态 */
#define kQQCommandFriendStatusChanged 0x0081
/** select login server */
#define kQQCommandSelectServer 0x0091
/** 命令常量 - 天气操作 */
#define kQQCommandWeatherOp 0x00A6
/**
 * 命令常量 - 添加好友
 * This is add friend command used in 2005. Before 2005, another command
 * which is deprecated is used
 */
#define kQQCommandAddFriend 0x00A7
/** 命令常量 - 发送验证消息 */
#define kQQCommandAuthorize 0x00A8
/** 命令常量 - 请求验证信息 */
#define kQQCommandAuthInfoOp 0x00AE
/** 命令常量 - 认证问题操作 */
#define kQQCommandAuthQuestionOp 0x00B7
/** 命令常量 - 请求登陆令牌 */
#define kQQCommandGetLoginToken 0x00BA
/** command - password verify */
#define kQQCommandPasswordVerify 0x00DD
/** 命令常量 - 未知命令，调试用途 */
#define kQQCommandUnknown 0xFFFF

#pragma mark -
#pragma mark agent family command

/** 命令常量 - 请求中转 */
#define kQQCommandRequestAgent 0x0021
/** 命令常量 - 请求得到自定义表情 */
#define kQQCommandRequestFace 0x0022
/** 命令常量 - 开始传送 */
#define kQQCommandTransfer 0x0023
/** 命令常量 - 请求开始传送 */
#define kQQCommandRequestBegin 0x0026

#pragma mark -
#pragma mark auxiliary family command

// keep in mind, command of auxiliary is 1 byte but we set it to 2 bytes
#define kQQCommandGetCustomHeadInfo 0x04
#define kQQCommandGetCustomHeadData 0x02

#pragma mark -
#pragma mark sub command

// 0x001D
#define kQQSubCommandGet03Key 0x03
#define kQQSubCommandGetFileAgentKey 0x04
#define kQQSubCommandGet06Key 0x06
#define kQQSubCommandGet07Key 0x07
#define kQQSubCommandGet08Key 0x08
#define kQQSubCommandGet0AKey 0x0A
#define kQQSubCommandGet0BKey 0x0B
#define kQQSubCommandGet0CKey 0x0C
#define kQQSubCommandGet0EKey 0x0E

// search user
#define kQQSubCommandSearchAll 0x31
#define kQQSubCommandSearchByNick 0x32
#define kQQSubCommandSearchByQQ 0x33

// advanced search user
#define kQQSubCommandSearchNormalUser 0x01

// download friend group
#define kQQSubCommandDownloadFriendGroup 0x01

// group data op
#define kQQSubCommandDownloadGroupName 0x01
#define kQQSubCommandUploadGroupName 0x02

// 0x0027
#define kQQSubCommandGetOnlineFriend 0x02
#define kQQSubCommandGetSystemService 0x03

// get property
#define kQQSubCommandGetUserProperty 0x01

// weather op sub command
#define kQQSubCommandGetWeather 0x01

// friend data op
#define kQQSubCommandBatchGetFriendRemark 0x00
#define kQQSubCommandUploadFriendRemark 0x01
#define kQQSubCommandRemoveFriendFromList 0x02
#define kQQSubCommandGetFriendRemark 0x03
#define kQQSubCommandModifyRemarkName 0x05

// sub command of 0x0062 
/** get server token */
#define kQQSubCommandGetServerToken 0x00

// sub command of 0x00B7
// get my question and answer
#define kQQSubCommandGetMyQuestion 0x01
// modify question
#define kQQSubCommandModifyQuestion 0x02
/** 得到问题 */
#define kQQSubCommandGetUserQuestion 0x03
/** 回答问题 */
#define kQQSubCommandAnswerQuestion 0x04

// sub command of 0x00A8
/** 普通验证，即验证码验证 */
#define kQQSubCommandNormalAuthorize 0x02
// approve and add him
#define kQQSubCommandApproveAuthorizationAndAddHim 0x03
// approve authorization
#define kQQSubCommandApproveAuthorization 0x04
// reject authorization
#define kQQSubCommandRejectAuthorization 0x05
/** 双重验证，即验证码和问题双重验证 */
#define kQQSubCommandDoubleAuthorize 0x10

// 0x00AE
/** 请求验证信息 */
#define kQQSubCommandGetAuthInfo 0x01
/** 通过提交验证码来得到验证信息 */
#define kQQSubCommandGetAuthInfoByVerifyCode 0x02

// 0x00BA的子命令
/** 登录认证 */
#define kQQSubCommandGetLoginToken 0x01
/** 刷新验证码图片 */
#define kQQSubCommandSubmitVerifyCode 0x02
/** 扩展的登录认证命令 */
#define kQQSubCommandGetLoginTokenEx 0x03
/** extended submit command */
#define kQQSubCommandSubmitVerifyCodeEx 0x04

// 0x005E的子命令
/** 只能通过号码搜到我 */
#define kQQSubCommandSearchMeByQQOnly 0x03
/** 共享地理位置 */
#define kQQSubCommandShareGeography 0x04

// 0x005C的子命令
/** 得到好友等级信息 */
#define kQQSubCommandGetFriendLevel 0x02

// 0x005F的子命令	
/** 得到群在线成员 */
#define kQQSubCommandGetClusterOnlineMember 0x01 

// 子命令常量，用于子命令0x0067
/** 修改个性签名 */
#define kQQSubCommandModifySignature 0x01
/** 删除个性签名 */
#define kQQSubCommandDeleteSignature 0x02
/** 得到个性签名 */
#define kQQSubCommandGetSignature 0x03

// system notification sub command, in packet, the command is represented as string!
/** 自己被别人加为好友 */
#define kQQSubCommandOtherAddMe 1
/** 
* 对方请求加我为好友
* 当对方不使用0x00A8命令发送认证消息，才会收到此系统通知, deprecated in QQ 2005
*/
#define kQQSubCommandOtherRequestAddMe 2
/** 对方同意加他为好友 */
#define kQQSubCommandOtherApproveMyRequest 3
/** 对方拒绝加他为好友 */
#define kQQSubCommandOtherRejectMyRequest 4
/** 广告 */
#define kQQSubCommandAdvertisement 6
/** 更新提示 */
#define kQQSubCommandSoftwareUpdate 9
/** 对方把我加为了好友 */
#define kQQSubCommandOtherAddMeEx 40
/** 
* 对方请求加你为好友
* 当对方使用0x00A8命令发送认证消息，才会收到此系统通知
*/
#define kQQSubCommandOtherRequestAddMeEx 41
/** 对方同意加他为好友，同时加我为好友 */
#define kQQSubCommandOtherApproveMyRequestAndAddMe 43

// 0x0066
/** send temp session im */
#define kQQSubCommandSendTempSessionIM 0x01

#pragma mark -
#pragma mark sub sub command

// sub command of 0x00AE
#define kQQSubSubCommandGetUserAuthInfo 0x0001
#define kQQSubSubCommandGetClusterAuthInfo 0x0002
#define kQQSubSubCommandGetUserTempSessionAuthInfo 0x0003
#define kQQSubSubCommandGetDeleteUserAuthInfo 0x0006
#define kQQSubSubCommandGetModifyUserInfoAuthInfo 0x0007

#pragma mark -
#pragma mark cluster sub command

/*
 * Create cluster
 * QQ 2006 don't use this command any more, operation is conducted thru web
 */
#define kQQSubCommandClusterCreate 0x01
/** 群操作命令 - 修改群成员 */
#define kQQSubCommandClusterModifyMember 0x02
/** 群操作命令 - 修改群资料 */
#define kQQSubCommandClusterModifyInfo 0x03
/** 群操作命令 - 得到群资料 */
#define kQQSubCommandClusterGetInfo 0x04
/*
 * Activate cluster
 * QQ 2006 don't use this command any more, operation is conducted thru web
 */
#define kQQSubCommandClusterActivate 0x05
/** 群操作命令 - 搜索群 */
#define kQQSubCommandClusterSearch 0x06
/** 群操作命令 - 加入群 */
#define kQQSubCommandClusterJoin 0x07
/** 群操作命令 - 加入群的验证消息 */
#define kQQSubCommandClusterAuthorize 0x08
/** 群操作命令 - 退出群 */
#define kQQSubCommandClusterExit 0x09
/** 
 * 群操作命令 - 发送群消息 
 * deprecated, use kQQSubCommandClusterSendIMEx
 */
#define kQQSubCommandClusterSendIM 0x0A
/** 群操作命令 - 得到在线成员 */
#define kQQSubCommandClusterGetOnlineMember 0x0B
/** 群操作命令 - 得到成员资料 */
#define kQQSubCommandClusterGetMemberInfo 0x0C
/** 群操作命令 - 修改群名片 */
#define kQQSubCommandClusterModifyCard 0x0E
/** 群操作命令 - 批量得到成员群名片中的真实姓名 */
#define kQQSubCommandClusterBatchGetCard 0x0F
/** 群操作命令 - 得到某个成员的群名片 */
#define kQQSubCommandClusterGetCard 0x10
/** 群操作命令 - 提交组织架构到服务器 */
#define kQQSubCommandClusterCommitOrganization 0x11
/** 群操作命令 - 从服务器获取组织架构 */
#define kQQSubCommandClusterUpdateOrganization 0x12
/** 群操作命令 - 提交成员分组情况到服务器 */
#define kQQSubCommandClusterCommitMemberGroup 0x13
/** 群操作命令 - 得到各种version id */
#define kQQSubCommandClusterGetVersionID 0x19
/** 群操作命令 - 扩展格式的群消息 */
#define kQQSubCommandClusterSendIMEx 0x1A
/** 群操作命令 - 设置成员角色 */
#define kQQSubCommandClusterSetRole 0x1B
/** 群操作命令 - 转让自己的角色给他人 */
#define kQQSubCommandClusterTransferRole 0x1C
/*
 * Dismiss cluster
 * QQ 2006 don't use this command any more, operation is conducted thru web
 */
#define kQQSubCommandClusterDismiss 0x1D
// get message setting
#define kQQSubCommandClusterGetMessageSetting 0x20
// change message setting
#define kQQSubCommandClusterModifyMessageSetting 0x21
// get member last talk time
#define kQQSubCommandClusterGetLastTalkTime 0x22
/** 群操作命令 - 创建临时群 */
#define kQQSubCommandTempClusterCreate 0x30
/** 群操作命令 - 修改临时群成员列表 */
#define kQQSubCommandTempClusterModifyMember 0x31
/** 群操作命令 - 退出临时群 */
#define kQQSubCommandTempClusterExit 0x32
/** 群操作命令 - 得到临时群资料 */
#define kQQSubCommandTempClusterGetInfo 0x33
/** 群操作命令 - 修改临时群资料 */
#define kQQSubCommandTempClusterModifyInfo 0x34
/** 群操作命令 - 发送临时群消息 */
#define kQQSubCommandTempClusterSendIM 0x35
/** 群操作命令 - 子群操作 */
#define kQQSubCommandClusterSubOp 0x36
/** activate temp cluster */
#define kQQSubCommandTempClusterActivate 0x37
// change cluster channel setting
#define kQQSubCommandClusterModifyChannelSetting 0x70
// get cluster channel setting
#define kQQSubCommandClusterGetChannelSetting 0x71

#pragma mark -
#pragma mark cluster sub sub command

/** 群操作子命令 - 添加成员，用在修改成员列表命令中 */
#define kQQSubSubCommandAddMember 0x01
/** 群操作子命令 - 删除成员，用在修改成员列表命令中 */
#define kQQSubSubCommandRemoveMember 0x02

/** 群操作子命令 - 得到多人对话列表 */
#define kQQSubSubCommandGetDialogs 0x01
/** 群操作子命令 - 得到群内的讨论组列表 */
#define kQQSubSubCommandGetSubjects 0x02

/** 群的搜索方式 - 根据群号搜索 */
#define kQQSubSubCommandSearchClusterByID 0x01
/** 群的搜索方式 - 搜索示范群, QQ doesn't support this any more */
#define kQQSubSubCommandSearchDemoCluster	= 0x02

// for set role
#define kQQSubSubCommandSetAdminRole 0x01
#define kQQSubSubCommandUnsetAdminRole 0x00

// cluster auth sub command
#define kQQSubSubCommandRequestJoinCluster 0x01
#define kQQSubSubCommandApproveJoinCluster 0x02
#define kQQSubSubCommandRejectJoinCluster 0x03

#pragma mark -
#pragma mark cluster member related flag

// cluster member flag
/** 群成员角色标志位 - 管理员 */
#define kQQRoleAdmin 0x01
/** 群成员角色标志位 - 股东 */
#define kQQRoleStockholder 0x02
/*
 * role - managed
 * managed means cluster admin can edit my name card
 */
#define kQQRoleManaged 0x08

// join/exit cluster caused by
#define kQQExitClusterDismissed 0x01
#define kQQExitClusterActive 0x02
#define kQQExitClusterPassive 0x03
#define kQQJoinClusterPassive 0x03

// role changed caused by
#define kQQClusterAdminRoleUnset 0x00
#define kQQClusterAdminRoleSet 0x01
#define kQQClusterOwnerRoleSet 0xFF

#pragma mark -
#pragma mark reply code

// ok, same for all command
#define kQQReplyOK 0

// 0x00BA reply, also available for 0x00AE
#define kQQReplyNeedVerifyCode 0x01

// reply of login
#define kQQReplyServerBusy 0x05
#define kQQReplyRedirect 0x0A
#define kQQReplyLoginFailed 0x09

// reply of add friend
#define kQQReplyAlreadyFriend 0x99

// reply of friend data op
#define kQQReplyNoMoreRemark 0x01

// reply of get online op
#define kQQReplyNoMoreOnline 0xFF

// reply of change status
#define kQQReplyChangeStatusOK 0x30

// advanced search user
#define kQQReplyNoMoreResult 0x01

// auth info op
#define kQQReplyInvalidAuthInfo 0x01

// reply of cluster command
#define kQQReplyNoSuchCluster 0x02
#define kQQReplyTempClusterRemoved 0x03
#define kQQReplyNotTempClusterMember 0x04
#define kQQReplyNoInfoAvailable 0x05
#define kQQReplyNotClusterMember 0x0A

// reply code of agent family, request agent command
#define kQQReplyRequestAgentRedirect 0x0001
#define kQQReplyRequestAgentRejected 0x0003

// reply code of temp session op
/** temp session im cached, maybe received is offline */
#define kQQReplyTempSesionIMCached 0x02

// sub command of 0x00DD
/** password error */
#define kQQReplyPasswordError 0x34
// need activate
#define kQQReplyNeedActivate 0x51

#pragma mark -
#pragma mark IM type

// im type in ReceiveIMHeader class
/** from my friend */
#define kQQIMTypeFriend 0x0009
/** from stranger */
#define kQQIMTypeStranger 0x000A
/** mobile message, from normal bind user */
#define kQQIMTypeBind 0x000B
/** mobile message - from mobile phone */
#define kQQIMTypeMobile 0x000C
/** member login hint, nothing in packet, just a hint of last login ip and time */
#define kQQIMTypeMemberLoginHint 0x0012
/** mobile message, mobile qq user */
#define kQQIMTypeMobileQQ 0x0013
/** mobile message, mobile qq user (use mobile phone number) */
#define kQQIMTypeMobileQQ2 0x0014
/** friend property change notification */
#define kQQIMTypePropertyChangedNotification 0x001E
/** temp session message */
#define kQQIMTypeTempSession 0x001F
/** unknown type cluster message */
#define kQQIMTypeClusterUnknown 0x0020
/** notifiaction of someone has joined a cluster */
#define kQQIMTypeJoinedCluster 0x0021
/** notification of someone has exited a cluster */
#define kQQIMTypeExitedCluster 0x0022
/** notification someone request to join cluster */
#define kQQIMTypeRequestJoinCluster 0x0023
/** notification of someone approve me */	
#define kQQIMTypeApprovedJoinCluster 0x0024
/** notification of someone reject me */
#define kQQIMTypeRejectedJoinCluster 0x0025
/** cluster created notification */
#define kQQIMTypeClusterCreated 0x0026
/** temp cluster message */
#define kQQIMTypeTempCluster 0x002A
/** cluster message */
#define kQQIMTypeCluster 0x002B
/** notification of cluster member role changed */
#define kQQIMTypeClusterRoleChanged 0x002C
/** notification of cluster is dismissed */
#define kQQIMTypeClusterDismissed 0x002D
/** cluster version id change notification */
#define kQQIMTypeClusterVersionChanged 0x002F
/** system message */ 
#define kQQIMTypeSystem 0x0030
/** signature change notification */
#define kQQIMTypeSignatureChangedNotification 0x0041
/** custom head change notification */
#define kQQIMTypeCustomHeadChangedNotification 0x0049
/** extended format friend message */
#define kQQIMTypeFriendEx 0x0084
/** extended format stranger message */
#define kQQIMTypeStrangerEx 0x0085

#pragma mark -
#pragma mark normal IM type

// 普通消息类型，normalIMHeader中的类型
/** normal text message */
#define kQQNormalIMTypeText 0x000B

#pragma mark -
#pragma mark system im type

// system im type, lower than im type, used when the im is sent by system

/** kick out by system, occurred when your qq is logined elsewhere */
#define kQQSystemIMTypeKickOut 0x01

#pragma mark -
#pragma mark im reply type

/** 消息回复类型 - 正常回复 */
#define kQQIMReplyTypeManual 0x01
/** 消息回复类型 - 自动回复 */
#define kQQIMReplyTypeAuto 0x02

#pragma mark -
#pragma mark sms type

#define kQQSMSTypeHandFree 0x20

#pragma mark -
#pragma mark agent transfer type

#define kQQAgentCustomFace 1100
#define kQQAgentScreenscrap 1000
#define kQQAgentReceive 0

#pragma mark -
#pragma mark custom face related

// custom face image source
#define kQQImageSourceCustomFace 0x1A
#define kQQImageSourceFile 0x1C
#define kQQImageSourceScreenscrap 0x1D

// face tag in message
#define kQQTagDefaultFace 0x14
#define kQQTagCustomFace 0x15

// face existence flag
#define kQQClusterCustomFace 0x36
#define kQQClusterCustomFaceRef 0x37

// face type
#define kQQFaceTypeCustomFace 'e'
#define kQQFaceTypeScreenscrap 'k'