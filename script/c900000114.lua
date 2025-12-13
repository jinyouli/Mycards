--邪神アバター
function c900000114.initial_effect(c)
	-- 特殊召唤条件
	c:EnableReviveLimit()

	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)

	-- 效果1：特殊召唤条件（4只怪兽或1只「邪神 神之化身」）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(123111,3))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c900000114.spcon2)
	e2:SetTarget(c900000114.sptg2)
	e2:SetOperation(c900000114.spop2)
	c:RegisterEffect(e2)

	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(123111,4))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c900000114.spcon)
	e3:SetTarget(c900000114.sptg)
	e3:SetOperation(c900000114.spop)
	c:RegisterEffect(e3)

	-- 效果3：不受对方效果影响
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c900000114.efilter)
	c:RegisterEffect(e4)

	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_ATTACK_FINAL)
	e5:SetValue(c900000114.adval)
	c:RegisterEffect(e5)

	--def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e6:SetValue(c900000114.defval)
	c:RegisterEffect(e6)

	--limit spell trap
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(0,1)
	e7:SetValue(c900000114.aclimit)
	c:RegisterEffect(e7)

	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CHANGE_CODE)
	e8:SetValue(21208154) -- 「邪神 神之化身」
	e8:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	c:RegisterEffect(e8)
end

function c900000114.spfilter(c,tp)
	return c:IsCode(21208154) and Duel.GetMZoneCount(tp,c)>0
end
function c900000114.spcon2(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroupEx(c:GetControler(),c900000114.spfilter,1,REASON_SPSUMMON,false,nil,c:GetControler())
end
function c900000114.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c900000114.spfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c900000114.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end

function c900000114.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON)
	return rg:CheckSubGroup(aux.mzctcheckrel,4,4,tp,REASON_SPSUMMON)
end
function c900000114.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,aux.mzctcheckrel,true,4,4,tp,REASON_SPSUMMON)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c900000114.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
end

function c900000114.filter(c)
	return c:IsFaceup() and not c:IsCode(900000114) and not c:IsHasEffect(900000114) and not c:IsCode(21208154) and not c:IsHasEffect(21208154)
end
-- 不受对方效果影响
function c900000114.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c900000114.adval(e,c)
	local g=Duel.GetMatchingGroup(c900000114.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then
		return 1
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		return val+1000
	end
end
function c900000114.defval(e,c)
	local g=Duel.GetMatchingGroup(c900000114.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then
		return 1
	else
		local tg,val=g:GetMaxGroup(Card.GetDefense)
		return val+1000
	end
end
function c900000114.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
