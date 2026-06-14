local assets =
{
    Asset("ANIM", "anim/handpet.zip"),
}

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("handpet_q")
    inst.AnimState:SetBuild("handpet_q")
    inst.AnimState:PlayAnimation("handpet", true)
	-- inst.AnimState:SetFinalOffset(1)

	-- inst.Transform:SetNoFaced()

    inst:AddTag("FX")
    inst:AddTag("DECOR")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("hand_pet_q", fn1, assets)