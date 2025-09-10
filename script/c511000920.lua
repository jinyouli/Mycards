--呪い移し
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end

function s.filter(c)
    return c:IsType(TYPE_SPELL) and c:IsFaceup() and c:GetOriginalCode()~=id
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)

	Duel.NegateEffect(ev)
	local tc=re:GetHandler()
	local c=e:GetHandler()
	local tpe=tc:GetType()
	
	if tc:IsType(TYPE_EQUIP+TYPE_CONTINUOUS) then

		-- 获取目标卡的原始代码
		local code = tc:GetOriginalCode()
		
		-- 复制永续魔法的效果
		local cid = c:CopyEffect(code, RESET_EVENT+RESETS_STANDARD, 1)
		c:CancelToGrave()
		
		-- 记录复制的效果
		local e01 = Effect.CreateEffect(c)
		e01:SetType(EFFECT_TYPE_SINGLE)
		e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e01:SetCode(EFFECT_CHANGE_CODE)
		e01:SetValue(123111)
		e01:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e01)
		
	else

		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(tpe)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e1)
		local te=tc:GetActivateEffect()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		Duel.BreakEffect()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end

	if (tpe&TYPE_FIELD)~=0 then
		local of=Duel.GetFieldCard(1-tp,LOCATION_FZONE,0)
		if of then Duel.Destroy(of,REASON_RULE) end
		of=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
		Duel.MoveToField(tc, 1-tp, tp, LOCATION_FZONE, POS_FACEUP, true)
	end
end