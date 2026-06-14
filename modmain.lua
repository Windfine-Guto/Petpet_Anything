GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

Assets = {
}

PrefabFiles = {
    "hand_pet_q"
}

-- local intensity = GetModConfigData() or 1.5

local function DoWobble(inst, duration, intensity)
    duration = duration or 0.5
    intensity = intensity or 1.5

    if inst._wobble_task then
        inst._wobble_task:Cancel()
        inst._wobble_task = nil
    end

    if not inst._wobble_original_scale then
        inst._wobble_original_scale = {inst.Transform:GetScale()}
    end

    if not inst._hand_pet then
        local handpet = SpawnPrefab("hand_pet_q")
        handpet.entity:SetParent(inst.entity)
        local sx, sy, sz = inst._wobble_original_scale[1], inst._wobble_original_scale[2], inst._wobble_original_scale[3]

        local x1, y1, x2, y2 = inst.AnimState:GetVisualBB()
        local height = -y1 + y2
        -- local base_width = 1.0
        -- local anim_width = x2 - x1
        -- local scale = anim_width / base_width/1.5
        -- handpet.Transform:SetScale(scale, scale, scale)
        handpet.Transform:SetPosition(0, height*0.8, 0)

        inst._hand_pet = handpet
    end

    local sx, sy, sz = inst._wobble_original_scale[1], inst._wobble_original_scale[2], inst._wobble_original_scale[3]
    inst._wobble_time = 0

    inst._wobble_task = inst:DoPeriodicTask(0, function()
        inst._wobble_time = inst._wobble_time + 0.016

        if inst._wobble_time >= duration then
            inst.Transform:SetScale(sx, sy, sz)
            inst._wobble_task:Cancel()
            inst._wobble_task = nil
            inst._wobble_time = nil
            inst._wobble_original_scale = nil
            if inst._hand_pet then
                inst._hand_pet:Remove()
                inst._hand_pet = nil
            end
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
end

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
HAND_PET_Q.priority = 0
HAND_PET_Q.instant = true
HAND_PET_Q.mount_valid = true
HAND_PET_Q.distance = 20
HAND_PET_Q.fn = function (act)
    local target = act.target
    DoWobble(target,1,1)
    return true
end
AddAction(HAND_PET_Q)
STRINGS.ACTIONS.HAND_PET_Q = {
    HAND_PET_ZH = "摸",
    HAND_PET_EN = "Pet"
}

AddComponentAction("SCENE", "health", function(inst, doer, actions, right)
    if right and inst then
        table.insert(actions, ACTIONS.HAND_PET_Q)
    end
end)

AddComponentAction("SCENE", "locomotor", function(inst, doer, actions, right)
    if right and inst then
        table.insert(actions, ACTIONS.HAND_PET_Q)
    end
end)