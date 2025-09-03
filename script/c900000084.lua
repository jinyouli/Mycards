--时之逆流
function c900000084.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c900000084.target)
	e1:SetOperation(c900000084.activate)
	c:RegisterEffect(e1)
	if not c900000084.global_check then
		c900000084.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE+PHASE_END)
		ge1:SetCountLimit(1)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ge1:SetOperation(c900000084.chkop)
		Duel.RegisterEffect(ge1,0)
		
	end
end
function c900000084.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c900000084.fil2,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_FZONE+LOCATION_SZONE,1,nil) or Duel.IsExistingMatchingCard(c900000084.fil,tp,0xff,0xff,1,nil) end
end
function c900000084.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c900000084.fil2,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_FZONE+LOCATION_SZONE,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			loc=tc:GetFlagEffectLabel(900000084-3)
			if loc==1 then
				Duel.SendtoDeck(tc,tc:GetFlagEffectLabel(900000084-1),2,REASON_EFFECT)
			elseif loc==2 then
				Duel.SendtoHand(tc,tc:GetFlagEffectLabel(900000084-1),REASON_EFFECT)
			elseif loc==4 or loc==8 then
				if not Duel.MoveToField(tc,tp,tc:GetFlagEffectLabel(900000084-1),loc,tc:GetFlagEffectLabel(900000084-2),true) then
					Duel.ChangePosition(tc,tc:GetFlagEffectLabel(900000084-2))
				end
			elseif loc==10 then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			elseif loc==20 then
				Duel.Remove(tc,tc:GetFlagEffectLabel(900000084-2),REASON_EFFECT)
			elseif loc==64 then
				Duel.SendtoDeck(tc,tc:GetFlagEffectLabel(900000084-1),2,REASON_EFFECT)
			elseif loc==100 then
				Duel.SendtoExtraP(tc,tc:GetFlagEffectLabel(900000084-1),REASON_EFFECT)
			end
			if tc:GetSequence()~=tc:GetFlagEffectLabel(900000084) then
					Duel.MoveSequence(tc,tc:GetFlagEffectLabel(900000084))
				end
			tc=g:GetNext()
		end
	end
	local g=Duel.GetMatchingGroup(c900000084.fil,tp,0xff,0xff,nil)
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_FZONE+LOCATION_SZONE,nil)
	if g:GetCount()>0 then
		if g1:GetCount()>0 then
		local tc=g1:GetFirst()
			while tc do
				local seq=tc:GetSequence()
				g=g:Filter(c900000084.fil3,nil,seq)
				tc=g1:GetNext()
			end
		end
		if g:GetCount()>0 then
			local tc1=g:GetFirst()
			while tc1 do
				Duel.SpecialSummonStep(tc1,0,tc1:GetFlagEffectLabel(900000084-1),tc1:GetFlagEffectLabel(900000084-1),true,true,tc1:GetFlagEffectLabel(900000084-2))
				if tc1:GetSequence()~=tc1:GetFlagEffectLabel(900000084) then
					Duel.MoveSequence(tc1,tc1:GetFlagEffectLabel(900000084))
				end
				tc1=g:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c900000084.fil(c)
	return (c:GetFlagEffectLabel(900000084-3)==LOCATION_MZONE and not c:IsLocation(LOCATION_MZONE)) or 
	(c:GetFlagEffectLabel(900000084-3)==LOCATION_HAND and not c:IsLocation(LOCATION_HAND)) or 
	(c:GetFlagEffectLabel(900000084-3)==LOCATION_DECK and not c:IsLocation(LOCATION_DECK)) or 
	(c:GetFlagEffectLabel(900000084-3)==LOCATION_GRAVE and not c:IsLocation(LOCATION_GRAVE)) or 
	(c:GetFlagEffectLabel(900000084-3)==LOCATION_REMOVED and not c:IsLocation(LOCATION_REMOVED)) or 
	(c:GetFlagEffectLabel(900000084-3)==LOCATION_EXTRA and not c:IsLocation(LOCATION_EXTRA))
	or 
	(c:GetFlagEffectLabel(900000084-3)==LOCATION_FZONE and not c:IsLocation(LOCATION_FZONE))
	or 
	(c:GetFlagEffectLabel(900000084-3)==LOCATION_SZONE and not c:IsLocation(LOCATION_SZONE))
end
function c900000084.fil2(c)
	return c:GetFlagEffectLabel(900000084-3)~=c:GetLocation() or c:GetFlagEffectLabel(900000084-2)~=c:GetPosition() or c:GetFlagEffectLabel(900000084-1)~=c:GetControler()
end
function c900000084.fil3(c,seq)
	return c:GetFlagEffectLabel(900000084)~=seq
end
function c900000084.chkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0xff,0xff,nil)
	local tc=g:GetFirst()
	while tc do
		tc:ResetFlagEffect(900000084-3)
		tc:ResetFlagEffect(900000084-2)
		tc:ResetFlagEffect(900000084-1)
		tc:ResetFlagEffect(900000084)
		if tc:IsLocation(LOCATION_EXTRA) and tc:IsFaceup() and tc:IsType(TYPE_PENDULUM) then
			tc:RegisterFlagEffect(900000084-3,0,0,1,100)
		else
			tc:RegisterFlagEffect(900000084-3,0,0,1,tc:GetLocation())
		end
		tc:RegisterFlagEffect(900000084-2,0,0,1,tc:GetPosition())
		tc:RegisterFlagEffect(900000084-1,0,0,1,tc:GetControler())
		tc:RegisterFlagEffect(900000084,0,0,1,tc:GetSequence())
		tc=g:GetNext()
	end
end

