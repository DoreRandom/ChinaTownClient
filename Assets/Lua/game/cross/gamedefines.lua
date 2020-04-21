ERROR_CODE = {
    Ok = 0,
    Common = 1,
    ScriptError = 2,
    Token = 1001,
    PlayerToken = 1002,
    InLogin = 1003,--已经有人在登陆了
    NoExistPlayer = 1004,--不存在该角色
    ReEnter = 1005, --重入
    InvalidPlayerToken = 1006 --playerToken无效
}


BROADCAST_TYPE = {
    ROOM_TYPE = 1
}
-------------------------
--头像范围
HEAD_RANGE = {
    Min = 1,
    Max = 72
}
--开始的分数
BEGIN_SCORE = 0
