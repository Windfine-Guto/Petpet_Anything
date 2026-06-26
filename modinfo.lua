local modid = 'handpet'
local cur = (locale == 'zh' or locale == 'zhr') and 'zh' or 'en'

version = '1.0.2'
author = 'over_dragon、Guto'

forumthread = ''
api_version = 10
priority = -1 -- 加载优先级，越低加载越晚，默认为0

dst_compatible = true -- 联机版适配性
dont_starve_compatible = false -- 单机版适配性
reign_of_giants_compatible = false -- 单机版：巨人国适配性
all_clients_require_mod = true -- 服务端/所有端模组
-- server_only_mod = true -- 仅服务端模组
-- client_only_mod = true -- 仅客户端模组
server_filter_tags = {} -- 创意工坊模组分类标签
icon_atlas = 'modicon.xml' -- 图集
icon = 'modicon.tex' -- 图标

local op={{'A',97},{'B',98},{'C',99},{'D',100},{'E',101},{'F',102},{'G',103},
{'H',104},{'I',105},{'J',106},{'K',107},{'L',108},{'M',109},{'N',110},{'O',111},
{'P',112},{'Q',113},{'R',114},{'S',115},{'T',116},{'U',117},{'V',118},{'W',119},
{'X',120},{'Y',121},{'Z',122}}

local LANGS = {
    ['zh'] = {
        name = '摸摸万物',
        description = '如果你一直摸一个东西，就会播放一首神秘妙妙音乐……',
        config = {
            {modid..'hand_type','摸的工具切换按键','',108,op},
            {modid..'hand_distance','摸的距离','手的长度',3,{
                {'3',3},
                {'5',5},
                {'10',10},
                {'20',20}
            }},
            }
    },
    ['en'] = {
        name = 'PetPet Anything',
        description = 'A mysterious whimsical melody will play if you keep petting an object……',
        config = {
            {modid..'hand_type', 'Petting Tool Key', '', 108,op},
            {modid..'hand_distance', 'Hand Reach Distance', 'Hand Length', 3, {
                {'3',3},
                {'5',5},
                {'10',10},
                {'20',20}
            }},
        }
    }
}

name = LANGS[cur].name
description = version..'\n'..LANGS[cur].description
local config = LANGS[cur].config or {}
local _configuration_options = {}
for i = 1, #config do
    local options = {}
    if config[i][5] then
        for k = 1, #config[i][5] do
            options[k] = {description = config[i][5][k][1], data = config[i][5][k][2]}
        end
    end
    _configuration_options[i] = {
        name = config[i][1],
        label = config[i][2],
        hover = config[i][3] or '',
        default = config[i][4] or false,
        options = #options>0 and options or {{description = "", data = false}},
    }
end

configuration_options = _configuration_options