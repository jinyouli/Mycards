--Fires of Shiranui
function c511002391.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    
    -- 双方场上的怪兽除破坏以外不能被送去墓地
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_TO_GRAVE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
    e2:SetTarget(c511002391.tgtg)
    c:RegisterEffect(e2)

    -- 不能作为同调、融合、连接素材
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
    e3:SetTarget(c511002391.tgtg)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    
    local e4 = e3:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e4)
    
    local e5 = e3:Clone()
    e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e5)
    
	---场上的怪兽不能解放
    local e6 = Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CANNOT_RELEASE)
    e6:SetRange(LOCATION_SZONE)
    e6:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
    e6:SetTarget(c511002391.tgtg)
    c:RegisterEffect(e6)
    
    -- 不能作为上级召唤的解放
    local e7 = Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    e7:SetRange(LOCATION_SZONE)
    e7:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
    e7:SetTarget(c511002391.tgtg)
    e7:SetValue(1)
    c:RegisterEffect(e7)
    
    local e8 = Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetCode(EFFECT_UNRELEASABLE_SUM)
    e8:SetRange(LOCATION_SZONE)
    e8:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
    e8:SetTarget(c511002391.tgtg)
    e8:SetValue(1)
    c:RegisterEffect(e8)
end

function c511002391.tgtg(e, c)
    return c:IsLocation(LOCATION_MZONE)
end
