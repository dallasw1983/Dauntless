Load(SettingName) {
IniRead, SettingValue, %A_AppData%\DauntlessQOL\Dauntless-QOL-Settings.ini, Settings, %SettingName%, %A_SPACE%
return % SettingValue
}