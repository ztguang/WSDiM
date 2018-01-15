/*
systemctl start mariadb.service
mysql -u root -p -e 'create database bpms;' 
mysql -uroot -p bpms < sssl.sql

在 MySQL中，SQL的模式缺省是忽略大小写的。
*/
drop table `sssl`;
CREATE TABLE `sssl` (
  `id` bigint(16) unsigned NOT NULL AUTO_INCREMENT,
  `SUUID` varchar(32) DEFAULT NULL,
  `clusterID` varchar(32) DEFAULT NULL,
  `SecurityID` varchar(32) DEFAULT NULL,
  `URI` varchar(240) DEFAULT NULL,
  `serviceName` varchar(60) DEFAULT NULL,
  `Inputs` varchar(240) DEFAULT NULL,
  `Outputs` varchar(240) DEFAULT NULL,
  `SFD` varchar(360) DEFAULT NULL, /* service function description */
  `keywords` varchar(240) DEFAULT NULL,
  `type` varchar(8) DEFAULT 'WS', /* WS or BPDaaS */
  `BPDaaS` varchar(2048) DEFAULT NULL,
  `state` varchar(1) DEFAULT 'Y', /* yes or no */
  `QoS` varchar(60) DEFAULT NULL,

  `ToMW1` tinyint(2) unsigned DEFAULT '0',
  `ToMW2` tinyint(2) unsigned DEFAULT '0',
  `ToMW3` tinyint(2) unsigned DEFAULT '0',
  `ToMW4` tinyint(2) unsigned DEFAULT '0',
  `ToMW5` tinyint(2) unsigned DEFAULT '0',
  `ToMW6` tinyint(2) unsigned DEFAULT '0',
  `ToMW7` tinyint(2) unsigned DEFAULT '0',
  `ToMW8` tinyint(2) unsigned DEFAULT '0',
  `ToMW9` tinyint(2) unsigned DEFAULT '0',
  `ToMW10` tinyint(2) unsigned DEFAULT '0',
  `SoInputs` tinyint(2) unsigned DEFAULT '0',
  `SoOutputs` tinyint(2) unsigned DEFAULT '0',
  `similarity` double DEFAULT '0',
  `insertdate` date DEFAULT NULL,

  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


/*
mysql -u root -p -e 'create database bpms;' 
mysql -uroot -p bpms < sssl.sql

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ();

('A8F7', 'B3A8', '0F23', '112.26.0.1/fastcgi/ws1', 'WebService1', '', '', '', '');
('', '', '', '', '', '', '', '', '');

get the UAV's speed									get UAV speed
obtain the position of the UAV								obtain UAV position
determine if UAV is in the prohibited area(restricted navigation zones)		UAV prohibited area
judge whether region is congestion 							region congestion
get hydrology information								get hydrology information
*/


insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('3C146112561E4074A7C7E33D4A2BB801', 'B3A8099C349A45AE9AF9E272838E7712', 'B43FECAB26844892955A62BF8A5312CB', '112.26.0.1/fastcgi/ws1', 'WebService1', '', '', 'get the UAV speed', 'getUAVspeed');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('EBCD3B329D8940568A33374CDC8057E8', 'B3A8099C349A45AE9AF9E272838E7712', 'D734F717A3A24335A80E143A3D104FA0', '112.26.0.1/fastcgi/ws2', 'WebService2', '', '', 'obtain the position of the UAV', 'obtainUAVposition');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('6C5D3C8CEBB543EF8A2CC2F999281B63', 'B3A8099C349A45AE9AF9E272838E7712', 'EC368B3BACD24814B9E17BF68640019E', '112.26.0.1/fastcgi/ws3', 'WebService3', '', '', 'determine if UAV is in the prohibited area', 'UAVprohibitedarea');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('BB53A7607CEE472480E23B35F853DE46', 'B3A8099C349A45AE9AF9E272838E7712', '6E9E9D0F933C46C9943922A71AAF965A', '112.26.0.1/fastcgi/ws4', 'WebService4', '', '', 'judge whether region is congestion', 'regioncongestion');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('738D8156001842DCBD48C3D409552475', 'B3A8099C349A45AE9AF9E272838E7712', 'B17885C4547F49219EAC234F33D6D15E', '112.26.0.1/fastcgi/ws5', 'WebService5', '', '', 'get hydrology information', 'gethydrologyinformation');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('449FED1232B34C3AA014F1D853677817', 'B3A8099C349A45AE9AF9E272838E7712', 'F7070CD7EC794FB89A187BF6C1DB395C', '112.26.0.1/fastcgi/ws6', 'WebService6', '', '', '', 'GetCompressedFileSize');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('22E37527F3C34CF3B7E0BF3DFCB09A58', 'B3A8099C349A45AE9AF9E272838E7712', '963F25D056F74453853AD29F64F5888A', '112.26.0.1/fastcgi/ws7', 'WebService7', '', '', '', 'GetCurrentDirectory');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('CC5D18EA855F4C50848CC1E6A322669C', 'B3A8099C349A45AE9AF9E272838E7712', '74D5946E2BA74CA7810013EEEC57A315', '112.26.0.1/fastcgi/ws8', 'WebService8', '', '', '', 'GetDiskFreeSpace');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('C98B47365CB04C478EA10F294F80A85D', 'B3A8099C349A45AE9AF9E272838E7712', '0B30E2D01469480DA53F3EF40988725C', '112.26.0.1/fastcgi/ws9', 'WebService9', '', '', '', 'GetDiskFreeSpaceEx');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('44008EE7FDA4464AB846A7CFC755E85F', 'B3A8099C349A45AE9AF9E272838E7712', '2CA32B9862884D2FA81BC7574112849F', '112.26.0.1/fastcgi/ws10', 'WebService10', '', '', '', 'GetDriveType');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('5D0FA25995AD43B18089076503F7E895', 'B3A8099C349A45AE9AF9E272838E7712', 'C512BD3658DE481AADB8A0AA597BE471', '112.26.0.1/fastcgi/ws11', 'WebService11', '', '', '', 'GetExpandedName');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('B4F00152C24C49939195C80CE60EB324', 'B3A8099C349A45AE9AF9E272838E7712', '578633B28DB74C4FBBF35EB8D063A801', '112.26.0.1/fastcgi/ws12', 'WebService12', '', '', '', 'GetFileAttributes');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('795D79CB63824465AA54D39B561B4F10', 'B3A8099C349A45AE9AF9E272838E7712', '7D24F588E690409D896FDEE31FF1DEF2', '112.26.0.1/fastcgi/ws13', 'WebService13', '', '', '', 'GetFileInformationByHandle');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('0315AF9DE68043B094BDF2B552D09C46', 'B3A8099C349A45AE9AF9E272838E7712', '6CC6A9D6398F4C94AF6665AB5A2B8E19', '112.26.0.1/fastcgi/ws14', 'WebService14', '', '', '', 'GetFileVersionInfo');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('73322148657D4140A1FCDC81F79E9C16', 'B3A8099C349A45AE9AF9E272838E7712', '6B0914294BEF46B4BF38C19408AF75F1', '112.26.0.1/fastcgi/ws15', 'WebService15', '', '', '', 'GetFileVersionInfoSize');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('2030C857A04241508B7FF83C4F2E5804', 'B3A8099C349A45AE9AF9E272838E7712', 'A8E7318157354C0898AF0BACD67C282C', '112.26.0.1/fastcgi/ws16', 'WebService16', '', '', '', 'GetOverlappedResult');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('82C274F6656A43E1A429842AB4267664', 'B3A8099C349A45AE9AF9E272838E7712', '3DB592521E48490889FE4A6B7D0B9323', '112.26.0.1/fastcgi/ws17', 'WebService17', '', '', '', 'GetPrivateProfileInt');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('E430874D671D44C48E951D652AC6EAD7', 'B3A8099C349A45AE9AF9E272838E7712', 'F6DCD67182D14CD9A6D658BBAABC874B', '112.26.0.1/fastcgi/ws18', 'WebService18', '', '', '', 'GetPrivateProfileSection');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('04F1C26D1F274520AA30B8EE6BDF254E', 'B3A8099C349A45AE9AF9E272838E7712', '0E0409A58106463EA4251DAC3A9612D5', '112.26.0.1/fastcgi/ws19', 'WebService19', '', '', '', 'GetPrivateProfileString');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('03A3BC8CBD8041AD9BE6528A1B4D477F', 'B3A8099C349A45AE9AF9E272838E7712', '87505BC764C44F4790EA68F774F7E44A', '112.26.0.1/fastcgi/ws20', 'WebService20', '', '', '', 'GetShortPathName');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('99CB74D3F40448F58E647B9011598622', 'B3A8099C349A45AE9AF9E272838E7712', 'F4B3ABEF1E2447CF96A969934C9DCDDB', '112.26.0.1/fastcgi/ws21', 'WebService21', '', '', '', 'GetSystemDirectory');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('57999212F20F461AA36214DA399856AF', 'B3A8099C349A45AE9AF9E272838E7712', 'E1C0AA30AAF34C08BA77F65BDA15FB71', '112.26.0.1/fastcgi/ws22', 'WebService22', '', '', '', 'GetTempFileName');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('E25C6459FB7E43C9A41DBCD34DD26E93', 'B3A8099C349A45AE9AF9E272838E7712', '57F947A854924C939874465DE1A96A21', '112.26.0.1/fastcgi/ws23', 'WebService23', '', '', '', 'GetTempPath');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('0E5C5D408457408680BD24E0D3228151', 'B3A8099C349A45AE9AF9E272838E7712', '2208DB4DC287412F9DF2CF1480BF47EE', '112.26.0.1/fastcgi/ws24', 'WebService24', '', '', '', 'GetWindowsDirectory');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('F754B84372934B10A51ED91F4AEF5B09', 'B3A8099C349A45AE9AF9E272838E7712', 'EC09A7B8A04A488E98797D035FA09C9F', '112.26.0.1/fastcgi/ws25', 'WebService25', '', '', '', 'QueryDosDevice');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('5D7B234AB0DF42DDBCA7BC2DCF80BF49', 'B3A8099C349A45AE9AF9E272838E7712', '19C2724F974F4CE4AB4FFD01F83BE63B', '112.26.0.1/fastcgi/ws26', 'WebService26', '', '', '', 'OpenFileMapping');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('69563235F99D49ED94CCCE6D3ABDA186', 'B3A8099C349A45AE9AF9E272838E7712', 'DDB508E4C8EE42B39C4A250A36F0F897', '112.26.0.1/fastcgi/ws27', 'WebService27', '', '', '', 'RegConnectRegistry');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('9F85BB594EC548F39139E2D278C535DE', 'B3A8099C349A45AE9AF9E272838E7712', 'B682FF6CA651477D8E95B619A07EA0C0', '112.26.0.1/fastcgi/ws28', 'WebService28', '', '', '', 'RegGetKeySecurity');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('7D4A0BE3E96745F8A7193B6FF0AC01A7', 'B3A8099C349A45AE9AF9E272838E7712', 'E52C2E1B661A4CD1AC4737E0E967A295', '112.26.0.1/fastcgi/ws29', 'WebService29', '', '', '', 'RegNotifyChangeKeyValue');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('2F1612E513964C1C90142A49E685036C', 'B3A8099C349A45AE9AF9E272838E7712', '3B0F13A73A51460DA975724E143CE381', '112.26.0.1/fastcgi/ws30', 'WebService30', '', '', '', 'RegQueryInfoKey');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('458F6A440AC845EBA0EE8C4A3EE44FB9', 'B3A8099C349A45AE9AF9E272838E7712', '3CBA1DA3B9DE412FAED935070DA8272B', '112.26.0.1/fastcgi/ws31', 'WebService31', '', '', '', 'RemoveDirectory');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('EFC97468D6954006846D3FA7C2B37BC0', 'B3A8099C349A45AE9AF9E272838E7712', '1D1E805877AB4EC6AFD1BD8032C12D9E', '112.26.0.1/fastcgi/ws32', 'WebService32', '', '', '', 'SetCurrentDirectory');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('75B50EB3AE444A46A03C7AB0A37A5F9E', 'B3A8099C349A45AE9AF9E272838E7712', '0CC7B820ACD74705BCB20E0F2C3CF436', '112.26.0.1/fastcgi/ws33', 'WebService33', '', '', '', 'SetFileAttributes');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('98E5D6410385435E92840FC8284844D8', 'B3A8099C349A45AE9AF9E272838E7712', '4CE5D31ED9154EC2BCB14544E69D7F7F', '112.26.0.1/fastcgi/ws34', 'WebService34', '', '', '', 'SystemTimeToFileTime');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('460A37B4597E43DFA5E74A3CB50064AC', 'B3A8099C349A45AE9AF9E272838E7712', '4548234B56D34F6281E38A98DE0897C4', '112.26.0.1/fastcgi/ws35', 'WebService35', '', '', '', 'UnmapViewOfFile');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('9473B81C17354E9CBB0C714E30623A60', 'B3A8099C349A45AE9AF9E272838E7712', '8074874933D543EBA0CA10AEF10250C3', '112.26.0.1/fastcgi/ws36', 'WebService36', '', '', '', 'WritePrivateProfileSection');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('076C0361954040A39A962EF2255F9E1D', 'B3A8099C349A45AE9AF9E272838E7712', 'C7D085A3501F452B962B47D7E58AE059', '112.26.0.1/fastcgi/ws37', 'WebService37', '', '', '', 'WritePrivateProfileString');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('04F0B0454F2D489A868F63C18021F042', 'B3A8099C349A45AE9AF9E272838E7712', 'DF173F1A084847C09EB91C15F2A67F91', '112.26.0.1/fastcgi/ws38', 'WebService38', '', '', '', 'WriteProfileSection');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('120F04A3EB34421AAE8180D5555B3F7D', 'B3A8099C349A45AE9AF9E272838E7712', '133FCB2D51BF44E59F306544BBD4E9F6', '112.26.0.1/fastcgi/ws39', 'WebService39', '', '', '', 'WriteProfileString');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('3075DABF7EC843D990BB70BA70C5D31E', 'B3A8099C349A45AE9AF9E272838E7712', 'CE91E63B27F64A268ADA3D78A66CD834', '112.26.0.1/fastcgi/ws40', 'WebService40', '', '', '', 'AddPrinterConnection');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('857A525596654C51AE2499DFB121F73A', 'B3A8099C349A45AE9AF9E272838E7712', '18661F356EF74FB79667D9E315290889', '112.26.0.1/fastcgi/ws41', 'WebService41', '', '', '', 'AddPrintProcessor');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('15308A4091F7493F8931D9EDD733A583', 'B3A8099C349A45AE9AF9E272838E7712', '949C0DDE496249F9BBC0CB58FD309BA1', '112.26.0.1/fastcgi/ws42', 'WebService42', '', '', '', 'AdvancedDocumentProperties');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('D1AC67133F4F4941A1D5B72708808DD1', 'B3A8099C349A45AE9AF9E272838E7712', '6EE035CA030C4FC3B863D85267BA0AB5', '112.26.0.1/fastcgi/ws43', 'WebService43', '', '', '', 'DeletePrinterConnection');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('62221AAB323C4CC6A93D09769A21BDCF', 'B3A8099C349A45AE9AF9E272838E7712', '20C9705F547645769C15E26EC30128CE', '112.26.0.1/fastcgi/ws44', 'WebService44', '', '', '', 'DeletePrinterDriver');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('C111A2C9231E4A929A6FECA15A52D79A', 'B3A8099C349A45AE9AF9E272838E7712', '33FADDDDC04C42F59410208A2A14D491', '112.26.0.1/fastcgi/ws45', 'WebService45', '', '', '', 'DeletePrintProvidor');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('AF778BF1DD8348A19CF125E2B4DAAEC5', 'B3A8099C349A45AE9AF9E272838E7712', 'FA3B9D9D5F3043708938B2EF49AAE4CE', '112.26.0.1/fastcgi/ws46', 'WebService46', '', '', '', 'DeviceCapabilities');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('02E28F63310144FAB797DB9FDE77507B', 'B3A8099C349A45AE9AF9E272838E7712', '8CEB70548B1D4367B00F1F686DB9AC7B', '112.26.0.1/fastcgi/ws47', 'WebService47', '', '', '', 'DocumentProperties');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('DE0882268A6F49F6A536FED4D14675A9', 'B3A8099C349A45AE9AF9E272838E7712', '10CA64A3BCE24AD6BDC3DC2D4AAB7A6A', '112.26.0.1/fastcgi/ws48', 'WebService48', '', '', '', 'FindFirstPrinterChangeNotification');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('95031FDE065646AEAD54C5B3B25EF5D1', 'B3A8099C349A45AE9AF9E272838E7712', '6652E6B634D8468A846D7F1693C5AC0C', '112.26.0.1/fastcgi/ws49', 'WebService49', '', '', '', 'FindClosePrinterChangeNotification');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('CB01BCA96DB84CEC9BCC68C7318FFD15', 'B3A8099C349A45AE9AF9E272838E7712', '5EE7A6AF6F614BA9960F4B0DCFD08706', '112.26.0.1/fastcgi/ws50', 'WebService50', '', '', '', 'FindNextPrinterChangeNotification');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('6526083BD6644A89A35498CA84D584CD', 'B3A8099C349A45AE9AF9E272838E7712', 'DFED5B0AD1A14E00BE91858F787209BF', '112.26.0.1/fastcgi/ws51', 'WebService51', '', '', '', 'FreePrinterNotifyInfo');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('B5F023D59F55414AAC66CC8EBA127D1D', 'B3A8099C349A45AE9AF9E272838E7712', '9859EB0B56234DCFBB9602BB53FFE98F', '112.26.0.1/fastcgi/ws52', 'WebService52', '', '', '', 'GetPrinterData');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('D8CA90A1C3C443DCA6A94F33C915DCA9', 'B3A8099C349A45AE9AF9E272838E7712', '5D9C0A10F0804A2A83C2CB7152B852B5', '112.26.0.1/fastcgi/ws53', 'WebService53', '', '', '', 'GetPrinterDriverDirectory');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('7A5589F17079402E90931475C0CA438F', 'B3A8099C349A45AE9AF9E272838E7712', 'C733244E4FDE4F138C1C04B1D8472AD8', '112.26.0.1/fastcgi/ws54', 'WebService54', '', '', '', 'GetPrintProcessorDirectory');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('F52B7A05B7B643BC956F2281A80EA9AC', 'B3A8099C349A45AE9AF9E272838E7712', 'EEAAC7B6F5CE4177B4FCCB49448B779B', '112.26.0.1/fastcgi/ws55', 'WebService55', '', '', '', 'ResetDC');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('EBB41F0E54924D0F889CF8A1D74BD04A', 'B3A8099C349A45AE9AF9E272838E7712', '71E5C940723B4210A252A16D941EA173', '112.26.0.1/fastcgi/ws56', 'WebService56', '', '', '', 'ReadPrinter');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('286813B6C5654A3CACB8C1CBF6EE06F8', 'B3A8099C349A45AE9AF9E272838E7712', '9E08F91C4CF64EDFA54ABA5FC76A579E', '112.26.0.1/fastcgi/ws57', 'WebService57', '', '', '', 'StartDocPrinter');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('38767AF35F274F2E834C9A9546162098', 'B3A8099C349A45AE9AF9E272838E7712', '3D3DBAC001DC4821AF6072ACF1F61B0F', '112.26.0.1/fastcgi/ws58', 'WebService58', '', '', '', 'AddFontResource');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('BEAC625C5AF043048E80FBDDC564D206', 'B3A8099C349A45AE9AF9E272838E7712', 'E5332373E5F541C3A3712B6C0218A34D', '112.26.0.1/fastcgi/ws59', 'WebService59', '', '', '', 'CreateScalableFontResource');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('85DFA52DECE74160BB068D49B69E9F8A', 'B3A8099C349A45AE9AF9E272838E7712', 'A1DE696481584C11897C9992BFEFE651', '112.26.0.1/fastcgi/ws60', 'WebService60', '', '', '', 'EnumFontFamilies');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('08F6A6F00CFB49E4ACA6D0D1054F82F8', 'B3A8099C349A45AE9AF9E272838E7712', '0231DC18D4E34B37A21DF1BA3D266A57', '112.26.0.1/fastcgi/ws61', 'WebService61', '', '', '', 'EnumFontFamiliesEx');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('B69EF9B8717B4610AA5D6D23F394F1D7', 'B3A8099C349A45AE9AF9E272838E7712', '36CF53B3005D491D8FB19F6454808BB6', '112.26.0.1/fastcgi/ws62', 'WebService62', '', '', '', 'GetAspectRatioFilterEx');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('F2B49DFD034646998E7B446D15861B20', 'B3A8099C349A45AE9AF9E272838E7712', '05A2BE5ABADE4A0888C89A2579EF0DF5', '112.26.0.1/fastcgi/ws63', 'WebService63', '', '', '', 'GetCharABCWidthsFloat');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('D145ED859F5246E982FE1DC0E4675344', 'B3A8099C349A45AE9AF9E272838E7712', '86387674CA434342BC97D33B69E91302', '112.26.0.1/fastcgi/ws64', 'WebService64', '', '', '', 'GetCharacterPlacement');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('962C386356F6420088826B9F0E8B685A', 'B3A8099C349A45AE9AF9E272838E7712', 'DC2E78A5838344BDB1E54674E591129E', '112.26.0.1/fastcgi/ws65', 'WebService65', '', '', '', 'GetFontLanguageInfo');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('B782D437A777442FB02B2DBB5A39A79E', 'B3A8099C349A45AE9AF9E272838E7712', 'D0236325CCAB4068A4517F4F7894B8B0', '112.26.0.1/fastcgi/ws66', 'WebService66', '', '', '', 'GetTextCharacterExtra');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('3AA5663AC2814297A47C81AE59F1E569', 'B3A8099C349A45AE9AF9E272838E7712', '9B8685C14C6D4332B36209FAED4A4C20', '112.26.0.1/fastcgi/ws67', 'WebService67', '', '', '', 'GetTextExtentExPoint');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('908061CE3390497088672EFB10C906EE', 'B3A8099C349A45AE9AF9E272838E7712', '28680283836D4356A9F1B68EDC07A034', '112.26.0.1/fastcgi/ws68', 'WebService68', '', '', '', 'GetTextExtentPoint');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('D3D607C16ACE4D7BBA62EA66FED3604F', 'B3A8099C349A45AE9AF9E272838E7712', 'B17CD2724BC04144B25BA9E9D555565C', '112.26.0.1/fastcgi/ws69', 'WebService69', '', '', '', 'RemoveFontResource');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('8A3089CEFB0D47119BD5683FDFD8819C', 'B3A8099C349A45AE9AF9E272838E7712', 'E35FA8201DAB4553860038D0949E8BA6', '112.26.0.1/fastcgi/ws70', 'WebService70', '', '', '', 'CheckMenuRadioItem');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('60340CFD6D5B4110A309F22BD1D72905', 'B3A8099C349A45AE9AF9E272838E7712', 'C4B43AB9082F46FAAD96A00A70B96A19', '112.26.0.1/fastcgi/ws71', 'WebService71', '', '', '', 'CreatePopupMenu');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('5292225AA68C41E0A08E7E7FA4055662', 'B3A8099C349A45AE9AF9E272838E7712', '02A66050CC554291B7B3C34866AEAD17', '112.26.0.1/fastcgi/ws72', 'WebService72', '', '', '', 'EnableMenuItem');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('E7AF34CD01294712811F0546AAF6A644', 'B3A8099C349A45AE9AF9E272838E7712', '6E6CA178BC5446CAA30906FA211D217C', '112.26.0.1/fastcgi/ws73', 'WebService73', '', '', '', 'GetMenuCheckMarkDimensions');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('CB10FBB5E1434BD6BD37271A61257445', 'B3A8099C349A45AE9AF9E272838E7712', '552EEB5CC11641EAB33870C263DCF486', '112.26.0.1/fastcgi/ws74', 'WebService74', '', '', '', 'GetMenuContextHelpId');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('55D4DE7E982A4D078B424E2088EC910D', 'B3A8099C349A45AE9AF9E272838E7712', 'E9FCD5E6BD9249C4AD733BBFAF82EA13', '112.26.0.1/fastcgi/ws75', 'WebService75', '', '', '', 'GetMenuDefaultItem');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('9FCA06B6D8444170BA4BEE81ACEBB452', 'B3A8099C349A45AE9AF9E272838E7712', 'FD9D21F89AA0443BADEC8D26A77C8FD5', '112.26.0.1/fastcgi/ws76', 'WebService76', '', '', '', 'GetMenuItemInfo');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('C33953564C9C4D1FB0BA5295498E1E41', 'B3A8099C349A45AE9AF9E272838E7712', 'AD6CB85341C34B56BDBEDC302619B6B9', '112.26.0.1/fastcgi/ws77', 'WebService77', '', '', '', 'GetSystemMenu');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('843C97DCB8654F5CBB363005D45C086E', 'B3A8099C349A45AE9AF9E272838E7712', 'DCB4147CD07D49EEB50FDA4D817A2629', '112.26.0.1/fastcgi/ws78', 'WebService78', '', '', '', 'MenuItemFromPoint');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('ADF1C44F6FD942378AD3BC23F8EF6917', 'B3A8099C349A45AE9AF9E272838E7712', '1081F32BC191463AA95801F84FB64C19', '112.26.0.1/fastcgi/ws79', 'WebService79', '', '', '', 'SetMenuContextHelpId');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('7B3A505D7AF2461EB48AA10C99BFCBA9', 'B3A8099C349A45AE9AF9E272838E7712', '6CFF00C601A04F6F8F85906F1A2502E3', '112.26.0.1/fastcgi/ws80', 'WebService80', '', '', '', 'SetMenuDefaultItem');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('F2233780CB8E4D44B1F66419053EF620', 'B3A8099C349A45AE9AF9E272838E7712', 'EC618AFE25AB4779B0890048C452ED5C', '112.26.0.1/fastcgi/ws81', 'WebService81', '', '', '', 'SetMenuItemBitmaps');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('0BF22D0E56094E2D8ACBC338FE5EB929', 'B3A8099C349A45AE9AF9E272838E7712', 'CA729B9656744DFA8F508F8A015BB06C', '112.26.0.1/fastcgi/ws82', 'WebService82', '', '', '', 'SetMenuItemInfo');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('5853C3817563413CA085A3F02E0E5F00', 'B3A8099C349A45AE9AF9E272838E7712', 'CA6115F4717E49D69FFB9AF8EB3CD98E', '112.26.0.1/fastcgi/ws83', 'WebService83', '', '', '', 'CreateCompatibleBitmap');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('EE6718E6A1984BD1B235B94477EB197C', 'B3A8099C349A45AE9AF9E272838E7712', 'D95B55584DB34439A2E34347419F04C6', '112.26.0.1/fastcgi/ws84', 'WebService84', '', '', '', 'CreateDIBSection');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('D9F102B961CA465C9CCA667D5ED2C471', 'B3A8099C349A45AE9AF9E272838E7712', 'D51DBB2073E04E1ABC1E64D8A822C0CC', '112.26.0.1/fastcgi/ws85', 'WebService85', '', '', '', 'CreateIconIndirect');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('01C0ED395CF3481AB70CB0FD04A0FAB1', 'B3A8099C349A45AE9AF9E272838E7712', '1A8EBCBA12D84A28B3E72BB04EEF2610', '112.26.0.1/fastcgi/ws86', 'WebService86', '', '', '', 'ExtractAssociatedIcon');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('092B610FDC2B479AA9779532C57E9443', 'B3A8099C349A45AE9AF9E272838E7712', '634D85F8BF12490DB24AEC50CC9E8AE3', '112.26.0.1/fastcgi/ws87', 'WebService87', '', '', '', 'GetBitmapDimensionEx');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('DEB2BC243AA34C46AFF729EABB4648F5', 'B3A8099C349A45AE9AF9E272838E7712', '8CDD10D2D20344DA91422A1C85428808', '112.26.0.1/fastcgi/ws88', 'WebService88', '', '', '', 'GetStretchBltMode');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('BC88AB005276478082E9C9D6F8BB682E', 'B3A8099C349A45AE9AF9E272838E7712', '47D95456FC9F4B9EA69526E1DE60DBBB', '112.26.0.1/fastcgi/ws89', 'WebService89', '', '', '', 'SetBitmapDimensionEx');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('D09FE5344BF949048BD8BC5CB9C207D3', 'B3A8099C349A45AE9AF9E272838E7712', 'ECB0B7866F3C49C6A299F8BB0990A224', '112.26.0.1/fastcgi/ws90', 'WebService90', '', '', '', 'SetDIBitsToDevice');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('654584582E3E458E8060EE52DF32C16C', 'B3A8099C349A45AE9AF9E272838E7712', '6F5ECF0DEE084D1BB0789A66EDB7687D', '112.26.0.1/fastcgi/ws91', 'WebService91', '', '', '', 'SetStretchBltMode');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('469B306E28654BB3AFF85C194B2E9A45', 'B3A8099C349A45AE9AF9E272838E7712', '896B8A8FBAED471F8ACF28A6BA127AFD', '112.26.0.1/fastcgi/ws92', 'WebService92', '', '', '', 'CreateBrushIndirect');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('3393FF6CAEA44FDBA9885ED527AE8C3F', 'B3A8099C349A45AE9AF9E272838E7712', 'CF26CC473E704680B18EEF909E23F981', '112.26.0.1/fastcgi/ws93', 'WebService93', '', '', '', 'CreatePatternBrush');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('8B8318BDA55D4371A37F431DA15CE054', 'B3A8099C349A45AE9AF9E272838E7712', '9A91C2D693B44BFD98A0FEEBA17FA64F', '112.26.0.1/fastcgi/ws94', 'WebService94', '', '', '', 'CreatePenIndirect');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('5A2E60AAFBFB415C89C960D0EBBCC397', 'B3A8099C349A45AE9AF9E272838E7712', '6FD5A3AEBBE44B46B765E31C31C2189C', '112.26.0.1/fastcgi/ws95', 'WebService95', '', '', '', 'DrawFocusRect');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('67C6ABC172D54C3FB3B4DD7BE499E5D0', 'B3A8099C349A45AE9AF9E272838E7712', '95C698DB3BB5448BBD1BCF93551E4D69', '112.26.0.1/fastcgi/ws96', 'WebService96', '', '', '', 'GetCurrentObject');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('723EBB10ED244CF4BBF23BE2F075A5E5', 'B3A8099C349A45AE9AF9E272838E7712', 'C5047E7BA6634392BAE387621BCE269B', '112.26.0.1/fastcgi/ws97', 'WebService97', '', '', '', 'GetCurrentPositionEx');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('9F5C6F6AE9F645B29D39F117DA554036', 'B3A8099C349A45AE9AF9E272838E7712', 'E1F744A970A4415A9FE69A15A3DBF755', '112.26.0.1/fastcgi/ws98', 'WebService98', '', '', '', 'GetEnhMetaFileDescription');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('4CC58B4BCF0C4EED9CABB454C35C8333', 'B3A8099C349A45AE9AF9E272838E7712', '6D5EEF97389849CF810B801F6D14F1FD', '112.26.0.1/fastcgi/ws99', 'WebService99', '', '', '', 'GetEnhMetaFileHeader');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('A39B305FA7F34BE192B87EFCFF1F6648', 'B3A8099C349A45AE9AF9E272838E7712', '181E4B3788934F1BB029DE023B603C66', '112.26.0.1/fastcgi/ws100', 'WebService100', '', '', '', 'GetEnhMetaFilePaletteEntries');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('F6F64836BF3B4C35A82F6BD56E3E60A9', '2406469941B149A6A796C06DEB2B157E', '4AB74BBD25154A6699B8773F383B27B6', '112.26.0.1/fastcgi/ws101', 'WebService101', '', '', '', 'dfsdddsa');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('BEC3F893FFFF498A8EB41A23DFDC0F8A', '2406469941B149A6A796C06DEB2B157E', 'B2E339715ACE469695A1C30309A554F5', '112.26.0.1/fastcgi/ws102', 'WebService102', '', '', '', 'aasdasdf');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('729902590DA54AAEBC3B3E26E498A7E2', '2406469941B149A6A796C06DEB2B157E', 'A31ECA2FDAED4753B5FE7FAAF901CB44', '112.26.0.1/fastcgi/ws103', 'WebService103', '', '', '', 'asdfdff');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('67B5C939067A47A6AABA08FDEEF530DE', '2406469941B149A6A796C06DEB2B157E', 'C58D00769C8647C2A8908F28C330161D', '112.26.0.1/fastcgi/ws104', 'WebService104', '', '', '', 'sdfsadfasdasdf');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('C2DEC9BA47994E9E91012428EC6B8ACE', '2406469941B149A6A796C06DEB2B157E', 'D9D4EA8B9720419EAEB0DD193344ACEE', '112.26.0.1/fastcgi/ws105', 'WebService105', '', '', '', 'ghdfghdgh');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('A62D59611EA0452F929AFDFE4F5CAE98', '2406469941B149A6A796C06DEB2B157E', '79A46D68456B4E618F345BFEC71CF460', '112.26.0.1/fastcgi/ws106', 'WebService106', '', '', '', 'dghdghdgfhsgfhafwret');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('464D821D15BD404D9B17B60FEDC570DB', '2406469941B149A6A796C06DEB2B157E', 'F9618B668EC74D27B1734C76D41DE7DF', '112.26.0.1/fastcgi/ws107', 'WebService107', '', '', '', 'sdzfgsdfgsgdbhdfg');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('880BC7F39B19464EBBD705FFB511E941', '2406469941B149A6A796C06DEB2B157E', '5D4BEA1AB98B4BE7AC0D398D526D26CA', '112.26.0.1/fastcgi/ws108', 'WebService108', '', '', '', 'hkfghjyunfh');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('DA65DBA80FE74D67B96AF63A4E8A5F7E', '2406469941B149A6A796C06DEB2B157E', '2EDB6BB624D64358BC72B270FE43FB36', '112.26.0.1/fastcgi/ws109', 'WebService109', '', '', '', 'fghyuhf');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('0FC1B5DF834B43C993B2B71E68071DAE', '2406469941B149A6A796C06DEB2B157E', 'AC3C6DF8ED184D5E9D9A0C8FE368CD85', '112.26.0.1/fastcgi/ws110', 'WebService110', '', '', '', 'dfghdtgdgh');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('4A0B8982CF294E9B813BF8D9816D495A', '2406469941B149A6A796C06DEB2B157E', 'FF8BAFD4A37F49CDB03CEB1E077756C3', '112.26.0.1/fastcgi/ws111', 'WebService111', '', '', '', 'wrtqwerqwet');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('FFCD2659C8F24C878EFA6E7652B17BB5', '2406469941B149A6A796C06DEB2B157E', '9FF06885E66640D4857C810403E7B8B4', '112.26.0.1/fastcgi/ws112', 'WebService112', '', '', '', 'yuruyhjfy');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('84308F2F056D4D92B5D83B33A4375696', '2406469941B149A6A796C06DEB2B157E', '66829EC999F74146BD98BDA38580DA83', '112.26.0.1/fastcgi/ws113', 'WebService113', '', '', '', 'hgjjkuyijh');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('979D5CC9FA9D4EFF826904E43EC07723', '2406469941B149A6A796C06DEB2B157E', '70520090D4CF4A5BBC63F29A0DB73A0C', '112.26.0.1/fastcgi/ws114', 'WebService114', '', '', '', 'wertywrwqerfgvfsgf');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('0F4B9840B6DE48088719664452237962', '2406469941B149A6A796C06DEB2B157E', '61E174EFB8BF407382D9B93594C746D8', '112.26.0.1/fastcgi/ws115', 'WebService115', '', '', '', 'jkuyidzxvfaarf');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('899730B110124D73BCE691544A769D0B', '2406469941B149A6A796C06DEB2B157E', 'DC8131D6C6E74FAB91C7A54D957A8473', '112.26.0.1/fastcgi/ws116', 'WebService116', '', '', '', 'qewrgthdfg');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('4B509AFFAFAA4CBCABF4D3E0F6E722CF', '2406469941B149A6A796C06DEB2B157E', '9DF3FA1957C44065860E8A2FF356EAF0', '112.26.0.1/fastcgi/ws117', 'WebService117', '', '', '', 'sdfgghgjhetyhdfghsty');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('C613D0EF979349EEB172859182173730', '2406469941B149A6A796C06DEB2B157E', '9C81DAC994E946FFA67D35A1F94BB58E', '112.26.0.1/fastcgi/ws118', 'WebService118', '', '', '', 'fghkjrtuyjjhgdgh');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('0BAACB09CD8441A19D6C4B7840739CD1', '2406469941B149A6A796C06DEB2B157E', '371C0C5DC9D442C6AF7DE269B28E03E5', '112.26.0.1/fastcgi/ws119', 'WebService119', '', '', '', 'dfghbxvcbdtysdvgsf');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('CF8839E9E0574D34ABA4C171946522DA', '2406469941B149A6A796C06DEB2B157E', '6468BFD2A4584220833BE1CAD7A462CA', '112.26.0.1/fastcgi/ws120', 'WebService120', '', '', '', 'ghbvgfhsghghjd');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('5A0586836A4A499ABAAA16717BF0EFBC', '2406469941B149A6A796C06DEB2B157E', 'DBF876D237D542B39CB04713A74D7C6C', '112.26.0.1/fastcgi/ws121', 'WebService121', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('670680EFBD664BC1BF096DDB56B739F2', '2406469941B149A6A796C06DEB2B157E', '25C17EE966BB4299979E09E77E351EE1', '112.26.0.1/fastcgi/ws122', 'WebService122', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('9604BF3829D34747B43C450BF8B9C6BA', '2406469941B149A6A796C06DEB2B157E', 'FE94CB4C9F15457CBDB228682A3F8EF5', '112.26.0.1/fastcgi/ws123', 'WebService123', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('AE03E3D343A042F18853F7A89BCF82D0', '2406469941B149A6A796C06DEB2B157E', 'C0140D61635C41C8A47C1C2A5C08D6C8', '112.26.0.1/fastcgi/ws124', 'WebService124', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('4B5773E277304AE7A6CB33675B3F5244', '2406469941B149A6A796C06DEB2B157E', 'DB771FF36CD64365925F4F8D8817FD9C', '112.26.0.1/fastcgi/ws125', 'WebService125', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('034645AFE235454BBEE345BF4A74F56C', '2406469941B149A6A796C06DEB2B157E', '5AC7C107E56C40E0A6F044AA38DC5805', '112.26.0.1/fastcgi/ws126', 'WebService126', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('0B8E8A351DC345A3A1B306328094CF45', '2406469941B149A6A796C06DEB2B157E', '03C7924D22314EFFA2BC1FC45B8CE0F6', '112.26.0.1/fastcgi/ws127', 'WebService127', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('6A9107F1791D4DC2ADBDB86F7DC29FF0', '2406469941B149A6A796C06DEB2B157E', 'AF8E0B686936427EAC17FEDD9BD8537B', '112.26.0.1/fastcgi/ws128', 'WebService128', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('D63B6917E6A444D5B29523EC9B5CAB08', '2406469941B149A6A796C06DEB2B157E', '2869CD6FD64C4FB99C71E835F4991CDA', '112.26.0.1/fastcgi/ws129', 'WebService129', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('6C5D05AB9D2847E6871591F08B6ADFE6', '2406469941B149A6A796C06DEB2B157E', '74426D6E2AF043BA86FA9099032CA5F8', '112.26.0.1/fastcgi/ws130', 'WebService130', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('0E283D467D6E400FA8355BDFFCF2A1A3', '2406469941B149A6A796C06DEB2B157E', 'C51F77957EAF4CC2A1F7977D68AA8A4C', '112.26.0.1/fastcgi/ws131', 'WebService131', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('E6F26B3EC3DD40DC828ADF9BAB9DDD85', '2406469941B149A6A796C06DEB2B157E', '01379E6A9C884E9680F23AA741D09600', '112.26.0.1/fastcgi/ws132', 'WebService132', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('7B0CF2A0732C42A4ABB5B376EC812B69', '2406469941B149A6A796C06DEB2B157E', 'C08E7A0AA1344F4EAD4CDA81262712AF', '112.26.0.1/fastcgi/ws133', 'WebService133', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('FC023F0E5C1A4ACD8B62C9C8CAFE3DBD', '2406469941B149A6A796C06DEB2B157E', '44229B79D9F140C6A6B530A5931C5950', '112.26.0.1/fastcgi/ws134', 'WebService134', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('FCE061E86CB84BA4A8C6DD49F3880440', '2406469941B149A6A796C06DEB2B157E', '2032A0E5677645C0B827CB9356FCCD8A', '112.26.0.1/fastcgi/ws135', 'WebService135', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('1E44E63D3D254F1EB511FB745CE12291', '2406469941B149A6A796C06DEB2B157E', '6D11784A0F224B09BE8C76B81C2374E2', '112.26.0.1/fastcgi/ws136', 'WebService136', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('63F6FDEA841E474A8721F76CAF26B0AA', '2406469941B149A6A796C06DEB2B157E', 'A280FDE5AFFF4A3792CCE26D94DB9FF4', '112.26.0.1/fastcgi/ws137', 'WebService137', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('0FB035FA8881415CA71F2276963744A6', '2406469941B149A6A796C06DEB2B157E', 'D5700E1D890344B5BCDFBBE963122C7A', '112.26.0.1/fastcgi/ws138', 'WebService138', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('EFCC245FEF2D4BD883AE066136E1FDEC', '2406469941B149A6A796C06DEB2B157E', 'B006850FAEB245399F57716D785D4414', '112.26.0.1/fastcgi/ws139', 'WebService139', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('30F235BF968948C692F05F6118E3AD7D', '2406469941B149A6A796C06DEB2B157E', 'C91E44CA7D534C768F748D0EC0264B0A', '112.26.0.1/fastcgi/ws140', 'WebService140', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('39E4BB58DBE04633954213210858F70E', '27E7D8482624498087BD1DABBD43FF96', 'DF0652C196C145A6B15F6DB9E0FA43BC', '112.26.0.1/fastcgi/ws141', 'WebService141', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('01D238135A6A44C2B1F11F87CF55190C', '27E7D8482624498087BD1DABBD43FF96', '4E3FCBDAA40F42CCA360E66254F2E0D5', '112.26.0.1/fastcgi/ws142', 'WebService142', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('90F1D3195B394E21853B251B2D37F3C5', '27E7D8482624498087BD1DABBD43FF96', 'FE7630C90D0F472AB6F33D1A398FA4F0', '112.26.0.1/fastcgi/ws143', 'WebService143', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('E30500EB238341DFB38A2411FACDBA82', '27E7D8482624498087BD1DABBD43FF96', '8705C5C4EDA141E08B5910E713A54001', '112.26.0.1/fastcgi/ws144', 'WebService144', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('72108851C8764B588BF723B6CB973986', '27E7D8482624498087BD1DABBD43FF96', 'A1A350F83FFF4C89BD9968F79A2F8538', '112.26.0.1/fastcgi/ws145', 'WebService145', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('797777C997B740958CABD9BA570C0F06', '27E7D8482624498087BD1DABBD43FF96', '5296CD4BA72B4695A3B696C555DB20BC', '112.26.0.1/fastcgi/ws146', 'WebService146', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('E3824EF2EB5648F4B59A8C5855C3B534', '27E7D8482624498087BD1DABBD43FF96', '6BC07B99611F4B7789BF4918B6B5BB20', '112.26.0.1/fastcgi/ws147', 'WebService147', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('839FABC34C4748939E09E0D6013D5769', '27E7D8482624498087BD1DABBD43FF96', '31CBC8184C95421788FCDBC4DEE9B8A4', '112.26.0.1/fastcgi/ws148', 'WebService148', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('8155BE5F8C1A47DB8EA177E302273888', '27E7D8482624498087BD1DABBD43FF96', 'B1C0142B44444D61BCBC6E2014817E54', '112.26.0.1/fastcgi/ws149', 'WebService149', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('CE3617E85FCE46B2AD6765CB7F785A12', '27E7D8482624498087BD1DABBD43FF96', '0BE739B14E63497B9666490DF29DB848', '112.26.0.1/fastcgi/ws150', 'WebService150', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('CC6D08CA75964280B3BC43A644AA7108', '27E7D8482624498087BD1DABBD43FF96', '7D8C212CB3D144058B5950E1DCB3AEA6', '112.26.0.1/fastcgi/ws151', 'WebService151', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('DABB18457E4146D6B4BB25F26E8A5D7B', '27E7D8482624498087BD1DABBD43FF96', 'F4E98C35AF7149B1B09770C453C82EFA', '112.26.0.1/fastcgi/ws152', 'WebService152', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('0840A3F05DF245ECB875ECF755A78DD9', '27E7D8482624498087BD1DABBD43FF96', 'BC3212955B164D0396F64F8BC7CE8DDF', '112.26.0.1/fastcgi/ws153', 'WebService153', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('8FC7449A61D84A08A54FB4AB85A6B491', '27E7D8482624498087BD1DABBD43FF96', '7BC70ED198A64F388DBE8CAC70B9E777', '112.26.0.1/fastcgi/ws154', 'WebService154', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('D54DD512F0774EFF9001082307EAF6BB', '27E7D8482624498087BD1DABBD43FF96', 'E816DDF16EB7490188D28929F4F5AF9B', '112.26.0.1/fastcgi/ws155', 'WebService155', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('E4116AA16B754632AA3939BF8156F3A4', '27E7D8482624498087BD1DABBD43FF96', '7DE6973C22904E0E8AAA27C7A5820AB7', '112.26.0.1/fastcgi/ws156', 'WebService156', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('C8DDE074B5B14961977753798C05A241', '27E7D8482624498087BD1DABBD43FF96', '155C7465303C4CE7A255AF56594AECEA', '112.26.0.1/fastcgi/ws157', 'WebService157', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('AE66E6E170064FFB89E261D8D2DED372', '27E7D8482624498087BD1DABBD43FF96', '85FB692E07574D9B96AA80EF21121BC0', '112.26.0.1/fastcgi/ws158', 'WebService158', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('A29CC58FE79547B7856256304532A753', '27E7D8482624498087BD1DABBD43FF96', 'C4AC1E285F254C048CFE37FF427ACFD6', '112.26.0.1/fastcgi/ws159', 'WebService159', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('CEF10775D6034DE788DE5B8715F36B83', '27E7D8482624498087BD1DABBD43FF96', 'B9EA74C17514475295270F4043B52EAF', '112.26.0.1/fastcgi/ws160', 'WebService160', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('4C5B9ECED67B44A78D1CB97A1677E294', '27E7D8482624498087BD1DABBD43FF96', '5D174F750C7346358CA03E03BC8BD73C', '112.26.0.1/fastcgi/ws161', 'WebService161', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('8E137BE28F0540D5B1845AC473EEF8B7', '27E7D8482624498087BD1DABBD43FF96', '9542474D347F4DC1A586790CCD6ADB4C', '112.26.0.1/fastcgi/ws162', 'WebService162', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('0304C31E64434189A426722B07B51835', '27E7D8482624498087BD1DABBD43FF96', 'A3696492891D4442AF1E957994AD1076', '112.26.0.1/fastcgi/ws163', 'WebService163', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('2725D191155341308806D884AD0DBD55', '27E7D8482624498087BD1DABBD43FF96', 'F480121E90914CA8816ECE00F124A138', '112.26.0.1/fastcgi/ws164', 'WebService164', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('2A52E57F49584DDC993F4FEB52F38590', '27E7D8482624498087BD1DABBD43FF96', '011991A8359645BC95388D22C4E30E96', '112.26.0.1/fastcgi/ws165', 'WebService165', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('3B5EE910DED349C48B36CDB21AD89BBA', '27E7D8482624498087BD1DABBD43FF96', '482C679A804145EA8CED3A2AE75CDB12', '112.26.0.1/fastcgi/ws166', 'WebService166', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('080A105B206849D7A8ECB5F46E8DEC4C', '27E7D8482624498087BD1DABBD43FF96', 'ADF6AEE8E2DD4417A01F658824FE3EF8', '112.26.0.1/fastcgi/ws167', 'WebService167', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('2C3D0C4329A345BD8757ECB0FEF70B31', '27E7D8482624498087BD1DABBD43FF96', 'ECFD885F76C543658B1207DAC150A96C', '112.26.0.1/fastcgi/ws168', 'WebService168', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('B579CEC338ED4E6FB9DDC261BA23FB4D', '27E7D8482624498087BD1DABBD43FF96', '38E13DAB097A46FD834C063074F591B2', '112.26.0.1/fastcgi/ws169', 'WebService169', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('603E82A3B74B44E090F926781578B757', '27E7D8482624498087BD1DABBD43FF96', 'DA4EDCC82B89468897A3BA2B2B56E6CC', '112.26.0.1/fastcgi/ws170', 'WebService170', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('B0DB76156E0C451DBF961E1253C00A13', '27E7D8482624498087BD1DABBD43FF96', '5DFBBDCCE04F4C3286E65F7F7D1D0A9F', '112.26.0.1/fastcgi/ws171', 'WebService171', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('063F19C7A0C741C893B6B721932E29BB', '27E7D8482624498087BD1DABBD43FF96', 'C8D9CD1DA80849B9A0779067AA51527A', '112.26.0.1/fastcgi/ws172', 'WebService172', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('0C2B8F66115A478C9D2008FEBA39A4A6', '27E7D8482624498087BD1DABBD43FF96', '2D82E4E304894D3886D727644F514278', '112.26.0.1/fastcgi/ws173', 'WebService173', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('1AADB314B9314879A3094F2B902C73A9', '27E7D8482624498087BD1DABBD43FF96', '05FE13FB5B0D47DE907EF389E688DA5A', '112.26.0.1/fastcgi/ws174', 'WebService174', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('13E74EE94C5C43F2867B3D294B793386', '27E7D8482624498087BD1DABBD43FF96', 'AF86E6BA6DD04698888262E875BC9775', '112.26.0.1/fastcgi/ws175', 'WebService175', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('820FB13259B44C9DA8063C7F1F39919D', '27E7D8482624498087BD1DABBD43FF96', '00B3884AE5F74577B2982AA837FD2617', '112.26.0.1/fastcgi/ws176', 'WebService176', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('6372BBFA668544819193F4FB2FB8F5E1', '27E7D8482624498087BD1DABBD43FF96', '6F6696D8474E454D8A3D84E9F3970194', '112.26.0.1/fastcgi/ws177', 'WebService177', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('13309408F2FB42E8BA62434D436839BD', '27E7D8482624498087BD1DABBD43FF96', '00F5896DD48F48FC976DF59278D4381B', '112.26.0.1/fastcgi/ws178', 'WebService178', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('C989B555F323447B9125830704519FD2', '27E7D8482624498087BD1DABBD43FF96', 'DB486F7D4CA74B11ADAC2EEF28466890', '112.26.0.1/fastcgi/ws179', 'WebService179', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('6634FBDB39534FACADBFA6A0A5E1A58E', '27E7D8482624498087BD1DABBD43FF96', '899BAFADA7C847AB8A18E22AAEEADD81', '112.26.0.1/fastcgi/ws180', 'WebService180', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('A4B1D907790A4001B74178D20F8F3B4B', '27E7D8482624498087BD1DABBD43FF96', 'FBE1032790B543A2A5768FBA642D53EA', '112.26.0.1/fastcgi/ws181', 'WebService181', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('8B16DAD1A19B455E8CC9E6FE0A7D4C49', '27E7D8482624498087BD1DABBD43FF96', '73F42D843F4747B89DB1D8861284352A', '112.26.0.1/fastcgi/ws182', 'WebService182', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('8F5EEDB2A24846FE894846FDACB64A5B', '27E7D8482624498087BD1DABBD43FF96', 'F436729250CB42B29F70A62F9312DD18', '112.26.0.1/fastcgi/ws183', 'WebService183', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('39EF15FAB99C43B4B0565B18A6AC7B9C', '27E7D8482624498087BD1DABBD43FF96', '07326C05EEF74A409F1C5E93E5D68CC7', '112.26.0.1/fastcgi/ws184', 'WebService184', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('A112351BF9F34A109B2DD990C50FBA00', '27E7D8482624498087BD1DABBD43FF96', '5F65C55BA8D647ED897C6EC6B3BC37A8', '112.26.0.1/fastcgi/ws185', 'WebService185', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('0AEB30566A9A400E8EC606EB7D10F950', '27E7D8482624498087BD1DABBD43FF96', '34AC23C5274B46F88A04D628ADB9B9B1', '112.26.0.1/fastcgi/ws186', 'WebService186', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('28C1DB2099E84BDDA3821A1DD8F3F6C6', '27E7D8482624498087BD1DABBD43FF96', '18B1214332DA4343980BDF5EF0945365', '112.26.0.1/fastcgi/ws187', 'WebService187', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('5B50C882C63A4CE6965B3797F9370867', '27E7D8482624498087BD1DABBD43FF96', '653C8EF7F8604A2384EB73430D3DF435', '112.26.0.1/fastcgi/ws188', 'WebService188', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('DBC0E913F8A74BBCB485CDE6D341C0D7', '27E7D8482624498087BD1DABBD43FF96', '317CC639E0CC4961898760040FF9773B', '112.26.0.1/fastcgi/ws189', 'WebService189', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('08548F1CFA7D4FDABB8D89773EF39854', '27E7D8482624498087BD1DABBD43FF96', '5FE5B1CDD478400582770D4CAAD353D7', '112.26.0.1/fastcgi/ws190', 'WebService190', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('A9937E1260C046418571B95FB40C43FD', '27E7D8482624498087BD1DABBD43FF96', 'CA788F11FAB8443E9D308F059DDF8240', '112.26.0.1/fastcgi/ws191', 'WebService191', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('99BCBE956DB441C2ADC1EF0EA93A808E', '27E7D8482624498087BD1DABBD43FF96', '16DACB8960D749B0AB9C57AE5C9F0946', '112.26.0.1/fastcgi/ws192', 'WebService192', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('137FB99E45334315805D7140E5AFF54F', '27E7D8482624498087BD1DABBD43FF96', 'EC4F2C37FA60453E951FEEB0693EED74', '112.26.0.1/fastcgi/ws193', 'WebService193', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('50CD31C62AEA456CA2A42C7CD259FB99', '27E7D8482624498087BD1DABBD43FF96', '2B32FD3A292C4263B43D8030AA9DE3E7', '112.26.0.1/fastcgi/ws194', 'WebService194', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('6F31892EAAE244D799012E092AC01B37', '27E7D8482624498087BD1DABBD43FF96', 'D5DAE44C5CEC40E8A3929793E47F90B6', '112.26.0.1/fastcgi/ws195', 'WebService195', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('B38CA0071C4B417DA327358AE3FDB022', '27E7D8482624498087BD1DABBD43FF96', '6B5B53132BF341FABFC11C05A6C0E13D', '112.26.0.1/fastcgi/ws196', 'WebService196', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('C25EBA68C4334BA7B2DE74527A3252AE', '27E7D8482624498087BD1DABBD43FF96', '8DBC65FDE40245DEA827A6B4D949BAF2', '112.26.0.1/fastcgi/ws197', 'WebService197', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('61777B7C8365465ABE3F526A049CA0BA', '27E7D8482624498087BD1DABBD43FF96', '6CB692669DC24006AB27D3623B44A502', '112.26.0.1/fastcgi/ws198', 'WebService198', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('7684818A16D1432C814911CBEAFAFEF0', '27E7D8482624498087BD1DABBD43FF96', '263F0A6D0F82428391BB5E79673121A7', '112.26.0.1/fastcgi/ws199', 'WebService199', '', '', '', '');

insert into sssl (SUUID, clusterID, SecurityID, URI, serviceName, Inputs, Outputs, SFD, keywords) values ('58648A7313754A5D93C8542E77CD147E', '27E7D8482624498087BD1DABBD43FF96', '8790157E23EA45F5A9B79E470D78D77F', '112.26.0.1/fastcgi/ws200', 'WebService200', '', '', '', '');

