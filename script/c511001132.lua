-- 海市蜃楼的支配者
function c511001132.initial_effect(c)
    -- 激活后作为永续陷阱在场上存在
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    
    --destroy spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c511001132.spcon1)
    e2:SetOperation(c511001132.spop)
    c:RegisterEffect(e2)

    --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c511001132.daop)
	c:RegisterEffect(e3)

    c511001132.pre_damage_lp = 0
end

function c511001132.daop(e,tp,eg,ep,ev,re,r,rp)
    c511001132.pre_damage_lp = Duel.GetLP(p)
end

function c511001132.filter1(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001132.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(c511001132.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,Duel.GetLocationCount(tp,LOCATION_MZONE),tp,LOCATION_GRAVE)
end
function c511001132.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c511001132.filter1,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp)
    if g:GetCount()>0 then
        local fid=e:GetHandler():GetFieldID()
        local tc=g:GetFirst()
        while tc do
        Duel.MoveToField(tc, tp, tp, LOCATION_MZONE, POS_FACEUP, true)
        tc=g:GetNext()
        end
    end

    local ph=Duel.GetCurrentPhase()
    if ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then
        local current_lp = Duel.GetLP(p)
        if current_lp < c511001132.pre_damage_lp then
            Duel.Recover(p, c511001132.pre_damage_lp - current_lp, REASON_EFFECT)
        end
    end
end

function c511001132.filter2(c,tp)
    return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY)
    and c:GetControler()==tp and c:IsLocation(LOCATION_GRAVE)
    and c:IsType(TYPE_MONSTER)
end
function c511001132.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c511001132.filter2,1,nil,tp)
end