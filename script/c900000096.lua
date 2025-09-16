-- 奇迹的方舟
-- 原始动画效果参考[2,3](@ref)，OCG版为仪式魔法[2](@ref)
-- 本实现按用户要求改为永续魔法卡并调整效果

local s, id = GetID()

function s.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    
    -- 效果1：墓地效果无效化
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetTargetRange(LOCATION_GRAVE, LOCATION_GRAVE)
    e1:SetTarget(s.distarget)
    c:RegisterEffect(e1)
    
    -- 效果1补充：墓地怪兽不受其他卡影响
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_GRAVE, LOCATION_GRAVE)
    e2:SetValue(s.efilter)
    c:RegisterEffect(e2)
    
    -- 效果2：1回合1次，双方墓地全除外并回复LP
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 0))
    e3:SetCategory(CATEGORY_REMOVE + CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(s.rmtg)
    e3:SetOperation(s.rmop)
    c:RegisterEffect(e3)
    
    -- 效果3：对手战斗阶段开始时特召墓地怪兽
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id, 1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_PHASE + PHASE_BATTLE_START)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCondition(s.spcon)
    e4:SetTarget(s.sptg)
    e4:SetOperation(s.spop)
    c:RegisterEffect(e4)
    
    -- 效果4：被破坏时特召天界王 志那都
    local e5 = Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id, 2))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCondition(s.spcon2)
    e5:SetTarget(s.sptg2)
    e5:SetOperation(s.spop2)
    c:RegisterEffect(e5)
end

-- 效果1辅助函数：只无效墓地发动的效果
function s.distarget(e, c)
    return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)
end

-- 效果1辅助函数：免疫其他卡的影响
function s.efilter(e, te)
    return te:GetOwner() ~= e:GetOwner()
end

-- 效果2：除外双方墓地所有怪兽并回复LP
function s.rmtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        local g1 = Duel.GetMatchingGroup(Card.IsAbleToRemove, tp, LOCATION_GRAVE, 0, nil)
        local g2 = Duel.GetMatchingGroup(Card.IsAbleToRemove, 1 - tp, LOCATION_GRAVE, 0, nil)
        return #g1 + #g2 > 0
    end
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 0, PLAYER_ALL, 0)
    Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, 0)
end

function s.rmop(e, tp, eg, ep, ev, re, r, rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    
    local g1 = Duel.GetMatchingGroup(Card.IsAbleToRemove, tp, LOCATION_GRAVE, 0, nil)
    local g2 = Duel.GetMatchingGroup(Card.IsAbleToRemove, 1 - tp, LOCATION_GRAVE, 0, nil)
    local ct = 0
    
    if #g1 > 0 then
        local rg1 = Duel.Remove(g1, POS_FACEUP, REASON_EFFECT)
        ct = ct + rg1
    end
    if #g2 > 0 then
        local rg2 = Duel.Remove(g2, POS_FACEUP, REASON_EFFECT)
        ct = ct + rg2
    end
    
    if ct > 0 then
        Duel.Recover(tp, ct * 500, REASON_EFFECT)
    end
end

-- 效果3：对手战斗阶段开始时特召条件
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() ~= tp
end

-- 效果3：目标设置 - 随机选择墓地怪兽
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 0, PLAYER_ALL, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    
    local op = Duel.GetTurnPlayer()
    local count = Duel.GetMatchingGroupCount(Card.IsFaceup, op, LOCATION_MZONE, 0, nil)
    
    if count <= 0 then return end
    
    -- 获取双方墓地怪兽
    local g1 = Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned, tp, LOCATION_GRAVE, 0, nil, POS_FACEUP_DEFENSE)
    local g2 = Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned, 1 - tp, LOCATION_GRAVE, 0, nil, POS_FACEUP_DEFENSE)
    local g = Group.CreateGroup()
    g:Merge(g1)
    g:Merge(g2)
    
    if #g == 0 then return end
    
    -- 随机选择怪兽
    local sg = Group.CreateGroup()
    for i = 1, math.min(count, #g) do
        local rg = g:RandomSelect(tp, 1)
        sg:Merge(rg)
        g:Sub(rg)
    end
    
    -- 特殊召唤
    if #sg > 0 then
        local tc = sg:GetFirst()
        while tc do
            Duel.SpecialSummon(tc, 0, tc:GetOwner(), tc:GetOwner(), false, false, POS_FACEUP_DEFENSE)
            tc = sg:GetNext()
        end
    end
end

-- 效果4：被破坏时特召天界王的条件
function s.spcon2(e, tp, eg, ep, ev, re, r, rp)
    return rp == 1 - tp and e:GetHandler():IsPreviousControler(tp)
end

-- 效果4：特召天界王的目标设置
function s.sptg2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK + LOCATION_HAND + LOCATION_GRAVE, 0, 1, nil, e, tp)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK + LOCATION_HAND + LOCATION_GRAVE)
end

-- 效果4：天界王特召筛选
function s.spfilter(c, e, tp)
    return c:IsCode(00000000) and c:IsCanBeSpecialSummoned(e, 0, tp, true, false) -- 替换00000000为天界王 志那都的实际卡号
end

-- 效果4：特召天界王操作
function s.spop2(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.spfilter), tp, LOCATION_DECK + LOCATION_HAND + LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
    if #g > 0 then
        Duel.SpecialSummon(g, 0, tp, tp, true, false, POS_FACEUP)
    end
end
