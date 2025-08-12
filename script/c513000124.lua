--Infernity Zero (Anime)
--scripted by Keddy
function c513000124.initial_effect(c)
	c:EnableReviveLimit()
	--connot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)

	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(c513000124.ctcon)
	e4:SetOperation(c513000124.ctop)
	c:RegisterEffect(e4)

	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD)
	e01:SetCode(EFFECT_CHANGE_DAMAGE)
	e01:SetRange(LOCATION_MZONE)
	e01:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e01:SetTargetRange(1,0)
	e01:SetValue(c513000124.damval2)
	c:RegisterEffect(e01)
	local e02=e01:Clone()
	e02:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e02)

	local e03=Effect.CreateEffect(c)
	e03:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e03:SetCode(EVENT_LEAVE_FIELD)
	e03:SetRange(LOCATION_GRAVE)
	e03:SetOperation(c513000124.leaveop)
	e03:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	c:RegisterEffect(e03)

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

		local ge03=Effect.CreateEffect(c)
		ge03:SetType(EFFECT_TYPE_FIELD)
		ge03:SetCode(EFFECT_CHANGE_DAMAGE)
		ge03:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge03:SetTargetRange(1,0)
		ge03:SetValue(c513000124.damval)
		Duel.RegisterEffect(ge03,0)
		local ge04=ge03:Clone()
		ge04:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		Duel.RegisterEffect(ge04,0)

		local ge05=Effect.CreateEffect(c)
		ge05:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge05:SetCode(EVENT_ADJUST)
		ge05:SetOperation(c513000124.op)
		Duel.RegisterEffect(ge05,0)
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
		local ct=math.floor(val/500)
		e:GetHandler():AddCounter(0x1097,ct)
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
	local ct=math.floor(ev/500)
	e:GetHandler():AddCounter(0x1097,ct)
end
function c513000124.sdcon(e)
	return e:GetHandler():GetCounter(0x1097)>=3
end

