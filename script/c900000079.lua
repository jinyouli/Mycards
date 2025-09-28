--卡通世界(Anime)
local s, id = GetID()
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOON))
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)

	--destroy not
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(s.reptg)
	e4:SetValue(s.repval)
	c:RegisterEffect(e4)

	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,1))
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCountLimit(1)
	e11:SetTarget(s.mtarget2)
	e11:SetOperation(s.moperation2)
	c:RegisterEffect(e11)
	

	--avoid battle damage
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetTargetRange(LOCATION_MZONE,0)
	e12:SetTarget(s.target)
	e12:SetValue(1)
	c:RegisterEffect(e12)
end

function s.target(e,c)
	return c:IsType(TYPE_TOON)
end

function s.filter3(c)
	return not c:IsType(TYPE_TOON) and not c:IsSetCard(0x62) and c:IsFaceup()
end
function s.mtarget2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter3,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter3,tp,LOCATION_MZONE,0,1,20,nil)
end
function s.moperation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	for tc in aux.Next(g) do
        if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then

            local e6=Effect.CreateEffect(tc)
            e6:SetType(EFFECT_TYPE_SINGLE)
            e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
            e6:SetCondition(s.dircon)
            e6:SetCode(EFFECT_DIRECT_ATTACK)
            e6:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e6,true)

            local e7=Effect.CreateEffect(tc)
            e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
            e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e7:SetRange(LOCATION_MZONE)
            e7:SetCode(EVENT_LEAVE_FIELD)
            e7:SetCondition(s.sdescon)
            e7:SetOperation(s.sdesop)
            e7:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e7,true)

			local e8=Effect.CreateEffect(tc)
			e8:SetType(EFFECT_TYPE_SINGLE)
			e8:SetCode(EFFECT_ADD_TYPE)
			e8:SetValue(TYPE_TOON)
            e8:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e8,true)

			-- 名字卡通化
			local e9 = Effect.CreateEffect(tc)
			e9:SetType(EFFECT_TYPE_SINGLE)
			e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e9:SetCode(EFFECT_CHANGE_CODE)
			e9:SetValue(123111)
			e9:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e9,true)

        end
    end
end

function s.indes(e,c)
	return not c or not c:IsType(TYPE_TOON)
end

function s.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function s.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function s.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(s.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end

function s.sfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousCodeOnField()==15259703 and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.sdescon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.sfilter,1,nil)
end
function s.sdesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsType(TYPE_TOON) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	return true
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
