-- 鸣神的瀑布
local s, id = GetID()
function s.initial_effect(c)
    
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    
    -- 永续效果：双方手牌怪兽不能送去墓地
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_TO_GRAVE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_HAND, LOCATION_HAND)
    e2:SetTarget(function(e, c)
        return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_HAND)
    end)
    c:RegisterEffect(e2)
    
    -- 处理特殊情况的额外效果（防止通过其他区域间接送墓）
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_REMOVE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_HAND, LOCATION_HAND)
    e3:SetTarget(function(e, c)
        return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_HAND)
    end)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    
    -- 防止手牌怪兽作为cost送去墓地
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_USE_AS_COST)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTargetRange(LOCATION_HAND, LOCATION_HAND)
    e4:SetTarget(function(e, c)
        return c:IsType(TYPE_MONSTER)
    end)
    c:RegisterEffect(e4)
    
    -- 当卡片离场时的重置效果
    local e5 = Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetCode(EVENT_LEAVE_FIELD_P)
    e5:SetOperation(s.resetop)
    c:RegisterEffect(e5)
end

-- 重置操作函数
function s.resetop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsStatus(STATUS_DESTROY_CONFIRMED) then
        -- 当卡片被破坏时，解除所有效果
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_CANNOT_TO_GRAVE)
        e1:SetTargetRange(1, 1)
        e1:SetReset(RESET_PHASE + PHASE_END)
        e1:SetTarget(function(e, c)
            return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_HAND)
        end)
        Duel.RegisterEffect(e1, tp)
    end
end