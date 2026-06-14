local assets =
{
    Asset("ANIM", "anim/handpet.zip"),
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
        inst.AnimState:PlayAnimation("handpet", true)
    else
        inst.AnimState:PlayAnimation("metal_pipe", true)
    end
    
	-- inst.AnimState:SetFinalOffset(1)

	inst.Transform:SetNoFaced()

    inst:AddTag("FX")
    inst:AddTag("DECOR")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

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