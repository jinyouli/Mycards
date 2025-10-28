--スライム増殖炉
local s, id = GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	-- 效果定义
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetRange(LOCATION_SZONE) -- 效果在魔法与陷阱区域生效
    e1:SetCondition(s.spcon)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
end

-- 条件检查函数：检查是否是我方怪兽从场上被送去墓地
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    -- 遍历所有被送去墓地的卡
    for tc in aux.Next(eg) do
        -- 如果是怪兽、是我方控制、之前在场上的位置（怪兽区或魔法陷阱区，但通常是怪兽区）
        if tc:IsPreviousLocation(LOCATION_ONFIELD) and tc:IsControler(tp) and tc:IsType(TYPE_MONSTER) then
            return true
        end
    end
    return false
end

-- 效果处理函数：特殊召唤符合条件的怪兽
function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    -- 检查永续魔法卡本身是否在场上表侧表示存在
    if not c:IsFaceup() or not c:IsLocation(LOCATION_SZONE) then return end

    local g = eg:Filter(s.spfilter, nil, tp)
    if #g > 0 then
        for tc in aux.Next(g) do
            -- 检查怪兽是否在墓地且可以被特殊召唤
            if tc:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
                and tc:IsCanBeSpecialSummoned(e, 0, tp, false, false) then
                Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
            end
        end
    end
end

-- 辅助过滤函数：筛选我方场上送去墓地的怪兽
function s.spfilter(c, tp)
    return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
