local assets =
{
    Asset("ANIM", "anim/handpet.zip"),
    Asset("SOUNDPACKAGE", "sound/Petpet_Anything.fev"),
    Asset("SOUND", "sound/Petpet_Anything.fsb"),
}

local function fn(data)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("handpet")
    inst.AnimState:SetBuild("handpet")
    if data.type=="hand" then
        inst.AnimState:PlayAnimation("handpet")
        inst.SoundEmitter:PlaySound("Petpet_Anything/Petpet_Anything/rubber_duck")
    else
        inst.AnimState:PlayAnimation("metal_pipe")
        inst.SoundEmitter:PlaySound("Petpet_Anything/Petpet_Anything/metal_pipe")
    end

	-- inst.AnimState:SetFinalOffset(1)
    inst.Transform:SetScale(2, 2, 2)
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

local function HandFn()
    return fn({
        type = "hand",
    })
end

local function MetalFn()
    return fn({
        type = "metal_pipe",
    })
end

return Prefab("hand_pet_q", HandFn, assets),
        Prefab("metal_pipe_q", MetalFn, assets)