--殉道者 地狱狩猎者
function c77239331.initial_effect(c)
    --salvage
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239331,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c77239331.thtg)
    e1:SetOperation(c77239331.thop)
    c:RegisterEffect(e1)
	
	--
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239331,1))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c77239331.thtg1)
    e2:SetOperation(c77239331.thop1)
    c:RegisterEffect(e2)

	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239331.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239331.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239331.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239331.disop)
    c:RegisterEffect(e13)
end
--------------------------------------------------------------
function c77239331.filter(c)
    return c:IsAbleToHand()
end
function c77239331.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239331.filter,tp,LOCATION_GRAVE,0,2,nil) end
    local g=Duel.GetMatchingGroup(c77239331.filter,tp,LOCATION_GRAVE,0,nil)
    --Duel.SetOperationInfo(0,CATEGORY_ATOHAND,g,2,0,0)	
end
function c77239331.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239331.filter,tp,LOCATION_GRAVE,0,2,2,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--------------------------------------------------------------
function c77239331.filter1(c)
    return c:IsAbleToDeck()
end
function c77239331.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239331.filter1,tp,LOCATION_GRAVE,0,2,nil) end
    local g=Duel.GetMatchingGroup(c77239331.filter1,tp,LOCATION_GRAVE,0,nil)
    --Duel.SetOperationInfo(0,CATEGORY_ATOHAND,g,2,0,0)	
end
function c77239331.thop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239331.filter1,tp,LOCATION_GRAVE,0,2,2,nil)
    if g:GetCount()>0 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
end
---------------------------------------------------------------------------------
function c77239331.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239331.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239331.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end
