local assets =
{
    Asset("ANIM", "anim/handpet.zip"),
    Asset("SOUNDPACKAGE", "sound/Petpet_Anything.fev"),
    Asset("SOUND", "sound/Petpet_Anything.fsb"),
}

local HANDPET = require("handpet_tools_table")
local function MakeHandpet(n)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("handpet")
        inst.AnimState:SetBuild("handpet")

        inst.AnimState:PlayAnimation(HANDPET[n].anim)
        inst.SoundEmitter:PlaySound(HANDPET[n].sound)

        -- inst.AnimState:SetFinalOffset(1)
        inst.Transform:SetScale(HANDPET[n].scale, HANDPET[n].scale, HANDPET[n].scale)
        inst.Transform:SetNoFaced()

        inst:AddTag("FX")
        inst:AddTag("DECOR")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        inst:ListenForEvent("animover", function() inst:Remove() end)

        return inst
    end

    return Prefab(HANDPET[n].prefab, fn, assets)
end

local hand = {}
for n=1, #HANDPET  do
    table.insert(hand, MakeHandpet(n))
end

return unpack(hand)