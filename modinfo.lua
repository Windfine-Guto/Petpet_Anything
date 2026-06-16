local modid = 'handpet'
local cur = (locale == 'zh' or locale == 'zhr') and 'zh' or 'en'

version = '1.0.0'
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



local LANGS = {
    ['zh'] = {
        name = '摸摸万物',
        description = '',
        config = {
            {modid..'hand_type','摸的工具','',1,{
                {'手',1},
                {'钢管',2},
            }},
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
        description = '',
        config = {
            {modid..'hand_type', 'Petting Tool', '', 1, {
                {'Hand', 1},
                {'Steel Pipe', 2},
            }},
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