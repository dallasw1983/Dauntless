Save(SettingName, SettingValue) {
IniWrite, %SettingValue%, %A_AppData%\DauntlessQOL\Dauntless-QOL-Settings.ini, Settings, %SettingName%
return
}