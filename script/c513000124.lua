--Infernity Zero (Anime)
function c513000124.initial_effect(c)
	c:EnableReviveLimit()
	--connot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)

	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c513000124.ctcon)
	e2:SetOperation(c513000124.ctop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(c513000124.damval2)
	c:RegisterEffect(e3)

	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetOperation(c513000124.leaveop)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	c:RegisterEffect(e5)

	--self destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_SELF_DESTROY)
	e6:SetCondition(c513000124.sdcon)
	c:RegisterEffect(e6)
	if not c513000124.global_check then
		c513000124.global_check=true

		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_CHANGE_DAMAGE)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetTargetRange(1,0)
		ge1:SetValue(c513000124.damval)
		Duel.RegisterEffect(ge1,0)

		local ge2=ge1:Clone()
		ge2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		Duel.RegisterEffect(ge2,0)

		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetOperation(c513000124.op)
		Duel.RegisterEffect(ge3,0)
	end
end

function c513000124.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_RELAY_SOUL=0x1a
	Duel.Win(e:GetLabel(),WIN_REASON_RELAY_SOUL)
end

function c513000124.damval(e,re,val,r,rp,rc)
	if Duel.GetLP(0)<=val and not c513000124.can_show and not c513000124.is_special then
		c513000124.can_show=true
		return Duel.GetLP(0)-1
	end
	return val
end

function c513000124.damval2(e,re,val,r,rp,rc)
	if Duel.GetLP(0)<=val then
		-- local ct=math.floor(val/500)
		-- e:GetHandler():AddCounter(0x1097,ct)
		if val>1000 then
			e:GetHandler():AddCounter(0x1097,1)
		end

		return Duel.GetLP(0)-1
	end
	return val
end

function c513000124.op(e,tp,eg,ep,ev,re,r,rp)
	
	if c513000124.can_show then
		c513000124.can_show=false

		local op=aux.SelectFromOptions(tp,{true,aux.Stringid(77239255,4)},{true,aux.Stringid(77239255,5)})
		if op==1 then
			local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			g:RemoveCard(e:GetHandler())
			Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
			
			local c=e:GetHandler()	
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
				Duel.SendtoGrave(c,REASON_RULE)
			else
				Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
				c513000124.is_special=true
			end
		end
		if op==2 then
			Duel.SetLP(tp,0)
		end
	end
end

function c513000124.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c513000124.ctop(e,tp,eg,ep,ev,re,r,rp)
	-- local ct=math.floor(ev/500)
	if ev>1000 then
		e:GetHandler():AddCounter(0x1097,1)
	end
end
function c513000124.sdcon(e)
	return e:GetHandler():GetCounter(0x1097)>=3
end

