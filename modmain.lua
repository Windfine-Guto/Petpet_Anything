GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

Assets = {

}

PrefabFiles = {
    "hand_pet_q"
}

local modid = 'handpet'
local distance = GetModConfigData(modid..'hand_distance') or 3
local handpet_tool = {
    [1] = "hand_pet_q",
    [2] = "metal_pipe_q",
}
local tool_size = 2

local function DoWobble(inst,doer)
    local duration = 0.3
    local intensity = 1
    local interval = 0.2  ---计数时间间隔

    if inst._hand_pet_count==nil then
        inst._hand_pet_count = 0
    end

    inst._hand_pet_count = inst._hand_pet_count + 1

    if inst._wobble_task then
        inst._wobble_task:Cancel()
        inst._wobble_task = nil
    end

    if not inst._wobble_original_scale then
        inst._wobble_original_scale = {inst.Transform:GetScale()}
    end

    if doer._handpet_tool_select==nil then
        doer._handpet_tool_select = 1
    end

    local handpet = SpawnPrefab(handpet_tool[doer._handpet_tool_select])
    handpet.entity:SetParent(inst.entity)

    local x1, y1, x2, y2 = inst.AnimState:GetVisualBB()
    local height = -y1 + y2
    handpet.Transform:SetPosition(0, height*0.75, 0)


    if handpet and handpet.prefab=="hand_pet_q" then
        ---摸的次数，到达就播放BGM
        if inst._hand_pet_count>=10 and doer.components.timer and not doer.components.timer:TimerExists("petpet_music_q_cd") then
            doer.SoundEmitter:PlaySound("Petpet_Anything/Petpet_Anything/petpet_music")
            inst._hand_pet_count = 0
            doer.components.timer:StartTimer("petpet_music_q_cd",6)
        end
    end

    local sx, sy, sz = inst._wobble_original_scale[1], inst._wobble_original_scale[2], inst._wobble_original_scale[3]
    inst._wobble_time = 0

    inst._wobble_task = inst:DoPeriodicTask(0, function()
        inst._wobble_time = inst._wobble_time + 0.016

        if inst._wobble_time >= interval then
            inst._hand_pet_count = nil
        end

        if inst._wobble_time >= duration then
            inst.Transform:SetScale(sx, sy, sz)
            inst._wobble_task:Cancel()
            inst._wobble_task = nil
            inst._wobble_original_scale = nil
            return
        end

        local t = inst._wobble_time
        local decay = (1 - t / duration) ^ 2

        local wy = math.sin(t * 30) * 0.35 * decay * intensity
        local wxz = -math.sin(t * 30) * 0.15 * decay * intensity
        local micro = math.sin(t * 50 + 1.2) * 0.08 * decay * intensity

        inst.Transform:SetScale(
            sx * (1 + wxz + micro),
            sy * (1 + wy + micro),
            sz * (1 + wxz + micro)
        )
    end)

    return true
end

AddStategraphState("wilson",State{
        name = "hand_pet_q",
        tags = { "canrotate", "waving", "handpet" },

        onenter = function(inst)
			inst.components.locomotor:Stop()
            local num = math.random(1,3)
            inst.AnimState:SetDeltaTimeMultiplier(2)
            inst.AnimState:PlayAnimation("emoteXL_waving"..num,false)
        end,

        timeline =
        {
            TimeEvent(5 * FRAMES, function(inst)
               inst:PerformBufferedAction()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function (inst)
            inst.AnimState:SetDeltaTimeMultiplier(1)
        end
    })
AddStategraphState("wilson_client",State{
        name = "hand_pet_q",
        tags = { "canrotate", "waving", "handpet" },

        onenter = function(inst)
			inst.components.locomotor:Stop()
            local num = math.random(1,3)
            inst.AnimState:SetDeltaTimeMultiplier(2)
            inst.AnimState:PlayAnimation("emoteXL_waving"..num,false)
        end,

        timeline =
        {
            TimeEvent(5 * FRAMES, function(inst)
                inst:PerformPreviewBufferedAction()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function (inst)
            inst.AnimState:SetDeltaTimeMultiplier(1)
        end
    })

local HAND_PET_Q = Action()
HAND_PET_Q.id = "HAND_PET_Q"
HAND_PET_Q.strfn = function (act)
    local locale = GLOBAL.LOC.GetLocaleCode()
    if locale == "zh" or locale == "zht" or locale=="zhr" then
        return "HAND_PET_ZH"
    else
        return "HAND_PET_EN"
    end
end
HAND_PET_Q.priority = -1
-- HAND_PET_Q.instant = true
HAND_PET_Q.mount_valid = true
HAND_PET_Q.distance = distance
HAND_PET_Q.fn = function (act)
    return DoWobble(act.target,act.doer)
end
AddAction(HAND_PET_Q)
STRINGS.ACTIONS.HAND_PET_Q = {
    HAND_PET_ZH = "摸摸",
    HAND_PET_EN = "Pet"
}

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.HAND_PET_Q, "hand_pet_q"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.HAND_PET_Q, "hand_pet_q"))

AddComponentAction("SCENE", "inspectable", function(inst, doer, actions, right)
    if right and inst then
        table.insert(actions, ACTIONS.HAND_PET_Q)
    end
end)

local select_mode = "handpet"
local key = GetModConfigData(modid..'hand_type') or 108

AddModRPCHandler("handpet_tool", "handpet_tool", function(inst)
    if inst and inst:IsValid() then
        if inst._handpet_tool_select==nil then
            inst._handpet_tool_select = 1
        end
        inst._handpet_tool_select = inst._handpet_tool_select + 1
        if inst._handpet_tool_select>tool_size then
            inst._handpet_tool_select = 1
        end
    end
end)

local function IsHUDScreen()
	local screen = TheFrontEnd:GetActiveScreen()
    return screen and screen.name == "HUD"
end
local function AddKeyListener(self)
    if self.owner and self.owner:HasTag("player") then
        self[select_mode..'handle'] = {}
        self.inst:ListenForEvent("onremove", function()
            for _, handler in pairs(self[select_mode..'handle']) do
                handler:Remove()
            end
        end)
        self[select_mode.."handle"].keydown = TheInput:AddKeyDownHandler(key, function()
    	if IsHUDScreen() then
            SendModRPCToServer(MOD_RPC["handpet_tool"]["handpet_tool"])
    	end
        end)
    end
end

AddClassPostConstruct("widgets/controls", AddKeyListener)