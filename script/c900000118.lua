local s,id,o=GetID()
function c900000118.initial_effect(c)
	
	--特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(123111,5))	
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c900000118.sptg)
	e1:SetOperation(c900000118.spop)
	c:RegisterEffect(e1)
	
	--从卡组、墓地选择卡加入手牌
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(123111,6))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c900000118.target)
	e2:SetOperation(c900000118.activate)
	c:RegisterEffect(e2)
	
	--效果无效
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(123111,7))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetTarget(s.target1)
	e3:SetOperation(s.activate1)
	c:RegisterEffect(e3)
	
	--免疫效果
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(123111,8))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetTarget(s.target2)
	e4:SetOperation(s.activate2)
	c:RegisterEffect(e4)
	
	--copy spell
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(123111,9))
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetTarget(c900000118.target5)
	e5:SetOperation(c900000118.operation5)
	c:RegisterEffect(e5)
end

function c900000118.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c900000118.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
	
	Duel.SetChainLimit(aux.FALSE)
end
function c900000118.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	
	local count=Duel.GetLocationCount(tp,LOCATION_MZONE)+1
	
	local g=Duel.SelectMatchingCard(tp,c900000118.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,count,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end

function c900000118.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	
	Duel.SetChainLimit(aux.FALSE)
end

function c900000118.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77239021,0))
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,60,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end

function s.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER)
end

function s.effilter(c)
	return c:IsFaceup() and c:GetFlagEffect(id)==0
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.effilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end

function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.effilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
		Duel.HintSelection(g)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		
		--indestructable
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4)

		local e5=e4:Clone()
		e5:SetCode(EFFECT_IMMUNE_EFFECT)
		e5:SetValue(s.efval)
		tc:RegisterEffect(e5)
	end
end

function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

-- 免疫效果判断：只免疫对方的效果
function s.efval(e, te)
    local tc = te:GetHandler()
    local tp = e:GetHandlerPlayer()
    return te:IsActiveType(TYPE_MONSTER) and tc:GetControler() ~= tp or
           te:IsActiveType(TYPE_SPELL) and tc:GetControler() ~= tp or
           te:IsActiveType(TYPE_TRAP) and tc:GetControler() ~= tp
end

function s.efilter(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActivated()
end

function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.effilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end

function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.effilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
		Duel.HintSelection(g)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end

function c900000118.filter5(c)
	return c:GetType()==TYPE_SPELL
end
function c900000118.target5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	
	Debug.Message("msg .0")
	if chk==0 then return Duel.IsExistingTarget(c900000118.filter5,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Debug.Message("msg .2")
	
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(0)

	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c900000118.filter5,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)

	
	local te=g:GetFirst():CheckActivateEffect(true,true,false)
	Duel.ClearTargetCard()
	e:SetProperty(te:GetProperty())
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local tg=te:GetTarget()

	
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end

	
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c900000118.operation5(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te:GetHandler():IsRelateToEffect(e) then
		e:SetLabel(te:GetLabel())
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		te:SetLabel(e:GetLabel())
		te:SetLabelObject(e:GetLabelObject())
	end
end