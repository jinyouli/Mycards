--卡通龙骑士黑魔导少女(ZCG)
local s, id = GetID()
function s.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCode2(c,53183600,90960358,true,true)
    --spsummon
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --direct attack
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_DIRECT_ATTACK)
    e4:SetCondition(s.dircon)
    c:RegisterEffect(e4)
    --destroy
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetCondition(s.sdescon)
    e3:SetOperation(s.sdesop)
    c:RegisterEffect(e3)
    --remove
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(s.cost)
    e2:SetTarget(s.retg)
    e2:SetOperation(s.operation)
    c:RegisterEffect(e2)
end

function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost, tp, LOCATION_GRAVE, 0, 1, nil) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectMatchingCard(tp, Card.IsAbleToRemoveAsCost, tp, LOCATION_GRAVE, 0, 1, 2, nil)
    local ct = Duel.Remove(g, POS_FACEUP, REASON_COST)
    e:SetLabel(ct)
end

function s.retg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chk == 0 then return Duel.GetMatchingGroupCount(aux.TRUE, tp, 0, LOCATION_ONFIELD, nil) > 0 end
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    local ct = e:GetLabel()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g = Duel.SelectMatchingCard(tp, aux.TRUE, tp, 0, LOCATION_ONFIELD, ct, ct, nil)
    Duel.Destroy(g, REASON_EFFECT)
end

function s.dirfilter2(c)
    return c:IsFaceup() and c:IsType(TYPE_TOON)
end

function s.dircon(e)
    return not Duel.IsExistingMatchingCard(s.dirfilter2, e:GetHandlerPlayer(), 0, LOCATION_MZONE, 1, nil)
end

function s.filter(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_GRAVE, 0, 1, nil) end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_GRAVE)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SELECT)
    local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
    local tc = g:GetFirst()
    local c = e:GetHandler()

    local opt = Duel.SelectOption(e:GetHandlerPlayer(), aux.Stringid(id, 2), aux.Stringid(id, 3))
    if opt == 0 then
        Duel.SendtoHand(tc, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, tc)

        local e02 = Effect.CreateEffect(tc)
        e02:SetType(EFFECT_TYPE_SINGLE) -- 单体效果，影响自身
        e02:SetCode(EFFECT_REMAIN_FIELD) -- 效果代码：留在场上
        tc:RegisterEffect(e02)
        Card.ReplaceEffect(tc,15259703,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)

    else
        Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
        local m=_G["c15259703"]
        if m then
            if m.cost then
                m.cost(te, tep, eg, ep, ev, re, r, rp, 1)
            end
        end
    end
 
    local e2=Effect.CreateEffect(tc)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(15259703)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_HAND)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	tc:RegisterEffect(e2)
end

function s.sfilter(c)
    return c:IsReason(REASON_DESTROY) and c:IsPreviousPosition(POS_FACEUP) and (c:GetPreviousCodeOnField() == 15259703 or c:GetPreviousCodeOnField() == 900000079 or c:GetPreviousCodeOnField() == 511001251) and c:IsPreviousLocation(LOCATION_ONFIELD)
end

function s.sdescon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.sfilter, 1, nil)
end

function s.sdesop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Destroy(e:GetHandler(), REASON_EFFECT)
end
