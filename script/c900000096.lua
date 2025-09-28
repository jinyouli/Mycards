-- 奇迹的方舟
local s, id = GetID()
function s.initial_effect(c)
    --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
    
    -- 效果1：墓地效果无效化
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetTargetRange(LOCATION_GRAVE, LOCATION_GRAVE)
    e1:SetTarget(s.distarget)
    c:RegisterEffect(e1)

    
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
    e4:SetCountLimit(1)
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
    e5:SetTarget(s.sptg2)
    e5:SetOperation(s.spop2)
    c:RegisterEffect(e5)

	--necro valley
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetCode(EFFECT_NECRO_VALLEY)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_GRAVE,0)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetTargetRange(0,LOCATION_GRAVE)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_NECRO_VALLEY)
	e8:SetRange(LOCATION_SZONE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetTargetRange(1,0)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetTargetRange(0,1)
	c:RegisterEffect(e9)

	--disable
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_CHAIN_SOLVING)
	e10:SetRange(LOCATION_SZONE)
	e10:SetOperation(s.disop)
	c:RegisterEffect(e10)

end

-- 效果1辅助函数：只无效墓地发动的效果
function s.distarget(e, c)
    return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)
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

function s.filter(c,tp,eg,ep,ev,re,r,rp)
    return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) 
end

function s.rmop(e, tp, eg, ep, ev, re, r, rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    
    local g1 = Duel.GetMatchingGroup(s.filter, tp, LOCATION_GRAVE, 0, nil)
    local g2 = Duel.GetMatchingGroup(s.filter, 1 - tp, LOCATION_GRAVE, 0, nil)
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
    local g1 = Duel.GetMatchingGroup(function(c) return c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_SPECIAL, tp, false, false) end, tp, LOCATION_GRAVE, 0, nil)



    local g2 = Duel.GetMatchingGroup(function(c) return c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_SPECIAL, 1-tp, false, false) end, 1-tp, LOCATION_GRAVE, 0, nil)

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
      
            Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP_DEFENSE)
            tc = sg:GetNext()
        end
    end
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
    return c:IsCode(900000097) and c:IsCanBeSpecialSummoned(e, 0, tp, true, false) -- 替换900000097为天界王 志那都的实际卡号
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

function s.disfilter(c,re)
	return c:IsRelateToEffect(re)
end

function s.discheck(ev,category,re)
	local ex,tg,ct,p,v=Duel.GetOperationInfo(ev,category)
	if not ex then return false end

	if v==LOCATION_GRAVE then
		return true
	end

    if tg and tg:GetCount()>0 then
		return tg:IsExists(s.disfilter,1,nil,re)
	end
	return false
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not Duel.IsChainDisablable(ev) then return end
	local res=false

	if not res and s.discheck(ev,CATEGORY_SPECIAL_SUMMON,re) then res=true end
	if not res and s.discheck(ev,CATEGORY_TOHAND,re) then res=true end
	if not res and s.discheck(ev,CATEGORY_TODECK,re) then res=true end
	if not res and s.discheck(ev,CATEGORY_TOEXTRA,re) then res=true end
	if not res and s.discheck(ev,CATEGORY_LEAVE_GRAVE,re) then res=true end
	if not res and s.discheck(ev,CATEGORY_REMOVE,re) then res=true end
	if res then Duel.NegateEffect(ev,true) end
end

