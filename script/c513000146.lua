--オベリスクの巨神兵
function c513000146.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10000000,2))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c513000146.ttcon)
	e1:SetOperation(c513000146.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c513000146.setcon)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(c513000146.sumsuc)
	c:RegisterEffect(e4)

	--to grave
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10000000,0))
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCondition(c513000146.tgcon)
	e6:SetTarget(c513000146.tgtg)
	e6:SetOperation(c513000146.tgop)
	c:RegisterEffect(e6)


	
    --unaffectable
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EFFECT_IMMUNE_EFFECT)
    e7:SetValue(c513000146.efilter)
    c:RegisterEffect(e7)
	
    --destroy
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(77240069,0))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCost(c513000146.descost)
    e7:SetTarget(c513000146.destg)
    e7:SetOperation(c513000146.desop)
    c:RegisterEffect(e7)

    --atk
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(77240069,1))
    e7:SetCategory(CATEGORY_ATKCHANGE)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCost(c513000146.descost)
    e7:SetOperation(c513000146.atkop)
    c:RegisterEffect(e7)

end

function c513000146.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c513000146.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c513000146.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c513000146.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c513000146.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c513000146.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c513000146.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end

function c513000146.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end

function c513000146.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,nil,2,e:GetHandler()) end
    local g=Duel.SelectReleaseGroup(tp,nil,2,2,e:GetHandler())
    Duel.Release(g,REASON_COST)
end
function c513000146.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c513000146.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,e:GetHandler())
    Duel.Destroy(g,REASON_EFFECT)
    Duel.Damage(1-tp,4000,REASON_EFFECT)
end

function c513000146.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetHandler():IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetRange(LOCATION_MZONE)
        e1:SetValue(99999999)
        c:RegisterEffect(e1)
    end
end