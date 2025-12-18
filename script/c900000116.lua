--殉道者 假死兽
function c900000116.initial_effect(c)
	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c900000116.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c900000116.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c900000116.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c900000116.disop)
    c:RegisterEffect(e13)

    -- 在墓地发动的特殊召唤效果
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCost(c900000116.spcost)
    e1:SetTarget(c900000116.sptg)
    e1:SetOperation(c900000116.spop)
    c:RegisterEffect(e1)
    
    -- 战斗破坏夺取怪兽效果
    local e2 = Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetCondition(c900000116.btcon)
    e2:SetTarget(c900000116.bttg)
    e2:SetOperation(c900000116.btop)
    c:RegisterEffect(e2)
end
----------------------------------------------------------------------
function c900000116.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c900000116.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c900000116.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end
----------------------------------------------------------------------

-- 特殊召唤代价：舍弃1张手牌
function c900000116.cfilter(c)
	return c:IsDiscardable()
end
function c900000116.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c900000116.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c900000116.cfilter,1,1,REASON_COST+REASON_DISCARD)
end

-- 特殊召唤目标设置
function c900000116.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 
        and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false) end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

-- 特殊召唤操作处理
function c900000116.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
        -- 给对方添加特殊召唤限制
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(0, 1)
        e1:SetReset(RESET_PHASE + PHASE_END)
        Duel.RegisterEffect(e1, tp)
    end
end

-- 战斗破坏条件检查
function c900000116.btcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToBattle()
end

-- 战斗破坏目标设置
function c900000116.bttg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    Duel.SetOperationInfo(0, CATEGORY_CONTROL, e:GetHandler():GetBattleTarget(), 1, 0, 0)
end

-- 战斗破坏操作处理：夺取被破坏的怪兽
function c900000116.btop(e, tp, eg, ep, ev, re, r, rp)
    local tc = e:GetHandler():GetBattleTarget()
    if tc and tc:IsLocation(LOCATION_GRAVE) and tc:IsReason(REASON_BATTLE) then
        Duel.GetControl(tc, tp, PHASE_END, 1)
    end
end