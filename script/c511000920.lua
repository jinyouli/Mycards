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
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
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

	-- 获取目标卡的原始代码
	local code = tc:GetOriginalCode()
	
	if tc:IsType(TYPE_CONTINUOUS) then
        c:CancelToGrave()
		-- 复制永续魔法的效果
		c:CopyEffect(code, RESET_EVENT+RESETS_STANDARD, 1)
		
		-- 修改卡名
		local e01 = Effect.CreateEffect(c)
		e01:SetType(EFFECT_TYPE_SINGLE)
		e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e01:SetCode(EFFECT_CHANGE_CODE)
		e01:SetValue(code)
		e01:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e01)

        Duel.SendtoGrave(tc,REASON_RULE)
    
    elseif tc:IsType(TYPE_EQUIP) then
        
        c:CancelToGrave()
        -- 清空当前卡的所有效果
        c:ResetEffect(RESET_CARD, RESET_EVENT)
        -- 复制效果
        c:CopyEffect(code, RESET_EVENT+RESETS_STANDARD, 1)

        -- 修改卡名
		local e01 = Effect.CreateEffect(c)
		e01:SetType(EFFECT_TYPE_SINGLE)
		e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e01:SetCode(EFFECT_CHANGE_CODE)
		e01:SetValue(code)
		e01:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e01)
        
        -- 选择要装备的怪兽
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
        local ec = Duel.SelectMatchingCard(tp, Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil):GetFirst()
        if not ec then return end
        
        -- 装备到选择的怪兽
        if not Duel.Equip(tp, c, ec) then return end

        Duel.SendtoGrave(tc,REASON_RULE)
		
	else
        -- 通常魔法/场地魔法
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

		local token = Duel.CreateToken(tp, 900000094)
		if not token then return end

		-- 将Token放置到场地魔法区域（LOCATION_FZONE）
		if Duel.MoveToField(token, tp, tp, LOCATION_FZONE, POS_FACEUP, true) then
			token:CopyEffect(code,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,1)

			-- 修改卡名
			local e01 = Effect.CreateEffect(token)
			e01:SetType(EFFECT_TYPE_SINGLE)
			e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e01:SetCode(EFFECT_CHANGE_CODE)
			e01:SetValue(code)
			e01:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e01)
		end

	end
end