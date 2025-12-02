--naturia bamboo shoot
function c900000081.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c900000081.mfilter,5,2,c900000081.ovfilter,aux.Stringid(77239255,3),3,c900000081.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c900000081.atkval)
	c:RegisterEffect(e1)

	--不会被战斗破坏
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)

	--limit spell trap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(c900000081.aclimit)
	c:RegisterEffect(e3)

	--limit monster
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetValue(c900000081.acmonsterlimit)
	c:RegisterEffect(e4)
end

function c900000081.mfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PLANT)
end
function c900000081.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsCode(900000081)
end
function c900000081.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,900000081)==0 end
	Duel.RegisterFlagEffect(tp,900000081,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c900000081.atkval(e,c)
	return c:GetOverlayCount()*200
end

function c900000081.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c900000081.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function c900000081.acmonsterlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end