 --上古死灵钥匙(ZCG)
function c77240334.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(c77240334.limfilter),LOCATION_SZONE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c77240334.activate2)
	c:RegisterEffect(e1)
	--remain field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
    --return back
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77240334,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c77240334.condition)
	e3:SetTarget(c77240334.target)
	e3:SetOperation(c77240334.activate)
	c:RegisterEffect(e3)

	if not c77240334.global_check then
		c77240334.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		ge1:SetCountLimit(1)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		ge1:SetOperation(c77240334.chkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function c77240334.limfilter(c)
    return c:IsCode(77240324) or c:IsCode(77240329) or c:IsCode(77240330) or c:IsCode(77240331) or c:IsCode(77240332) or c:IsCode(77240333) or c:IsCode(77240334)
end

function c77240334.activate2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():SetTurnCounter(0)
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c77240334.descon)
	e1:SetOperation(c77240334.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,5)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,5)
	c77240334[e:GetHandler()]=e1
end

function c77240334.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end

function c77240334.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==5 then
		Duel.Win(1-tp,0x13)
		c:ResetFlagEffect(1082946)
	end
end

function c77240334.condition(c)
	return Duel.GetTurnCount()>=2
end

function c77240334.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77240334.fil2,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_FZONE+LOCATION_SZONE,1,nil) or Duel.IsExistingMatchingCard(c77240334.fil,tp,0xff,0xff,1,nil) end
end
function c77240334.activate(e,tp,eg,ep,ev,re,r,rp)

	local t={}
	local turnNum=Duel.GetTurnCount()
	local l=1
	while l<=turnNum do
		t[l]=l
		l=l+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77240334,0))
	num=Duel.AnnounceNumber(tp,table.unpack(t))-1

	local g=Duel.GetMatchingGroup(c77240334.fil2,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_FZONE+LOCATION_SZONE,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			loc=tc:GetFlagEffectLabel(77240334-3+num*4)
			if loc==1 then
				Duel.SendtoDeck(tc,tc:GetFlagEffectLabel(77240334-1+num*4),2,REASON_EFFECT)
			elseif loc==2 then
				Duel.SendtoHand(tc,tc:GetFlagEffectLabel(77240334-1+num*4),REASON_EFFECT)
			elseif loc==8 then
				if tc:IsType(TYPE_FIELD) then
				    Duel.MoveToField(tc,tp,tc:GetFlagEffectLabel(77240334-1+num*4),LOCATION_FZONE,tc:GetFlagEffectLabel(77240334-2+num*4),true)
				else
					if not Duel.MoveToField(tc,tp,tc:GetFlagEffectLabel(77240334-1+num*4),loc,tc:GetFlagEffectLabel(77240334-2+num*4),true) then
						Duel.ChangePosition(tc,tc:GetFlagEffectLabel(77240334-2+num*4))
					end
				end
			elseif loc==4 then
				if not Duel.MoveToField(tc,tp,tc:GetFlagEffectLabel(77240334-1+num*4),loc,tc:GetFlagEffectLabel(77240334-2+num*4),true) then
					Duel.ChangePosition(tc,tc:GetFlagEffectLabel(77240334-2+num*4))
				end
			elseif loc==10 then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			elseif loc==20 then
				Duel.Remove(tc,tc:GetFlagEffectLabel(77240334-2+num*4),REASON_EFFECT)
			elseif loc==64 then
				Duel.SendtoDeck(tc,tc:GetFlagEffectLabel(77240334-1+num*4),2,REASON_EFFECT)
			elseif loc==100 then
				Duel.SendtoExtraP(tc,tc:GetFlagEffectLabel(77240334-1+num*4),REASON_EFFECT)
			end
			if tc:GetSequence()~=tc:GetFlagEffectLabel(77240334+num*4) then
					Duel.MoveSequence(tc,tc:GetFlagEffectLabel(77240334+num*4))
				end
			tc=g:GetNext()
		end
	end
	local g=Duel.GetMatchingGroup(c77240334.fil,tp,0xff,0xff,nil)
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_FZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_FZONE+LOCATION_SZONE,nil)
	if g:GetCount()>0 then
		if g1:GetCount()>0 then
		local tc=g1:GetFirst()
			while tc do
				local seq=tc:GetSequence()
				g=g:Filter(c77240334.fil3,nil,seq)
				tc=g1:GetNext()
			end
		end
		if g:GetCount()>0 then
			local tc1=g:GetFirst()
			while tc1 do
				Duel.SpecialSummonStep(tc1,0,tc1:GetFlagEffectLabel(77240334-1+num*4),tc1:GetFlagEffectLabel(77240334-1+num*4),true,true,tc1:GetFlagEffectLabel(77240334-2+num*4))
				if tc1:GetSequence()~=tc1:GetFlagEffectLabel(77240334+num*4) then
					Duel.MoveSequence(tc1,tc1:GetFlagEffectLabel(77240334+num*4))
				end
				tc1=g:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
	end

	Duel.SetLP(tp,_G["mhp"..num])
	Duel.SetLP(1-tp,_G["ehp"..num])
end
function c77240334.fil(c)

	if num == nil then
		num=0
	end

	return (c:GetFlagEffectLabel(77240334-3+num*4)==LOCATION_MZONE and not c:IsLocation(LOCATION_MZONE)) or 
	(c:GetFlagEffectLabel(77240334-3+num*4)==LOCATION_HAND and not c:IsLocation(LOCATION_HAND)) or 
	(c:GetFlagEffectLabel(77240334-3+num*4)==LOCATION_DECK and not c:IsLocation(LOCATION_DECK)) or 
	(c:GetFlagEffectLabel(77240334-3+num*4)==LOCATION_GRAVE and not c:IsLocation(LOCATION_GRAVE)) or 
	(c:GetFlagEffectLabel(77240334-3+num*4)==LOCATION_REMOVED and not c:IsLocation(LOCATION_REMOVED)) or 
	(c:GetFlagEffectLabel(77240334-3+num*4)==LOCATION_EXTRA and not c:IsLocation(LOCATION_EXTRA))
	or 
	(c:GetFlagEffectLabel(77240334-3+num*4)==LOCATION_FZONE and not c:IsLocation(LOCATION_FZONE))
	or 
	(c:GetFlagEffectLabel(77240334-3+num*4)==LOCATION_SZONE and not c:IsLocation(LOCATION_SZONE))
end
function c77240334.fil2(c)

	if num == nil then
		num=0
	end

	return c:GetFlagEffectLabel(77240334-3+num*4)~=c:GetLocation() or c:GetFlagEffectLabel(77240334-2+num*4)~=c:GetPosition() or c:GetFlagEffectLabel(77240334-1+num*4)~=c:GetControler()
end
function c77240334.fil3(c,seq)
	return c:GetFlagEffectLabel(77240334+num*4)~=seq
end
function c77240334.chkop(e,tp,eg,ep,ev,re,r,rp)
	local turnCount=Duel.GetTurnCount()-1
	local g=Duel.GetMatchingGroup(nil,tp,0xff,0xff,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_EXTRA) and tc:IsFaceup() and tc:IsType(TYPE_PENDULUM) then
			tc:RegisterFlagEffect(77240334-3+turnCount*4,0,0,1,100)
		else
			tc:RegisterFlagEffect(77240334-3+turnCount*4,0,0,1,tc:GetLocation())
		end
		tc:RegisterFlagEffect(77240334-2+turnCount*4,0,0,1,tc:GetPosition())
		tc:RegisterFlagEffect(77240334-1+turnCount*4,0,0,1,tc:GetControler())
		tc:RegisterFlagEffect(77240334+turnCount*4,0,0,1,tc:GetSequence())
		tc=g:GetNext()
	end
	_G["mhp"..turnCount]=Duel.GetLP(tp)
    _G["ehp"..turnCount]=Duel.GetLP(1-tp)
end
	