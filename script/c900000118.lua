function c900000118.initial_effect(c)
	--特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(123111,5))	
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c900000118.sptg)
	e1:SetOperation(c900000118.operation)
	c:RegisterEffect(e1)
	
	--从卡组、墓地选择卡加入手牌
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(123111,6))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c900000118.target2)
	e2:SetOperation(c900000118.operation2)
	c:RegisterEffect(e2)
	
		--效果无效
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(123111,7))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetTarget(c900000118.target3)
	e3:SetOperation(c900000118.operation3)
	c:RegisterEffect(e3)
	
		--免疫效果
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(123111,8))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetTarget(c900000118.target4)
	e4:SetOperation(c900000118.operation4)
	c:RegisterEffect(e4)
	

	--copy spell
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(123111,9))
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(c900000118.target5)
	e5:SetOperation(c900000118.operation5)
	c:RegisterEffect(e5)
	
	--Negate
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e6:SetDescription(aux.Stringid(123111,10))
	e6:SetType(EFFECT_TYPE_ACTIVATE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCondition(c900000118.discon)
	e6:SetTarget(c900000118.distg)
	e6:SetOperation(c900000118.disop)
	c:RegisterEffect(e6)
	
end

function c900000118.discon(e,tp,eg,ep,ev,re,r,rp)

	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and ep==1-tp

end

function c900000118.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c900000118.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end




function c900000118.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c900000118.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
	
	Duel.SetChainLimit(aux.FALSE)
end
function c900000118.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	
	local count=Duel.GetLocationCount(tp,LOCATION_MZONE)+1
	
	local g=Duel.SelectMatchingCard(tp,c900000118.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,count,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end

function c900000118.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	
	Duel.SetChainLimit(aux.FALSE)
end

function c900000118.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77239021,0))
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,60,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end

function c900000118.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER)
end

function c900000118.effilter(c)
	return c:IsFaceup() and c:GetFlagEffect(id)==0
end
function c900000118.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c900000118.effilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end

function c900000118.operation4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c900000118.effilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
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
		e5:SetValue(c900000118.efval)
		tc:RegisterEffect(e5)
	end
end

function c900000118.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

-- 免疫效果判断：只免疫对方的效果
function c900000118.efval(e, te)
    local tc = te:GetHandler()
    local tp = e:GetHandlerPlayer()
    return te:IsActiveType(TYPE_MONSTER) and tc:GetControler() ~= tp or
           te:IsActiveType(TYPE_SPELL) and tc:GetControler() ~= tp or
           te:IsActiveType(TYPE_TRAP) and tc:GetControler() ~= tp
end

function c900000118.efilter(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActivated()
end

function c900000118.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c900000118.effilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end

function c900000118.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c900000118.effilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
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
	return c:IsType(TYPE_SPELL)
end

function c900000118.target5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
    	return Duel.IsExistingMatchingCard(c900000118.filter5,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,e,tp)
	end

	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
	
  Duel.SetChainLimit(aux.FALSE)
end
function c900000118.operation5(e,tp,eg,ep,ev,re,r,rp)
  
  local g1=Duel.SelectMatchingCard(tp,c900000118.filter5,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g1:GetCount()==0 then
		return
	end
  
	local tc=g1:GetFirst()
	local tpe=tc:GetType()
	local te=tc:GetActivateEffect()
	local tg=te:GetTarget()
	local co=te:GetCost()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	if (tpe&TYPE_EQUIP+TYPE_CONTINUOUS)~=0 or tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	elseif (tpe&TYPE_FIELD)~=0 then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
	tc:CreateEffectRelation(te)
	if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
	if tg then
		if tc:IsSetCard(0x95) then
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		else
			tg(te,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	Duel.BreakEffect()
local t1=Duel.GetFirstTarget()

	if (tpe&TYPE_EQUIP)~=0 then
		
		if not Duel.Equip(tp,tc,t1) then return end
	end
	
	if t1 then
	  t1:CreateEffectRelation(te)
  end
	
	if op then 
		op(te,tp,eg,ep,ev,re,r,rp)
	end
	
  if t1 then
	  t1:ReleaseEffectRelation(te)
  end

	tc:ReleaseEffectRelation(te)
end


