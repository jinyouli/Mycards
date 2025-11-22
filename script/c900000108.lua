-- 克隆研究所
local s, id = GetID()
function s.initial_effect(c)
    --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

    --生成衍生物
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_IGNITION) --  ignition 表示是自己的主要阶段发动
    e1:SetRange(LOCATION_SZONE) -- 魔法陷阱区域
    e1:SetTarget(s.tktg)
    e1:SetOperation(s.tkop)
    c:RegisterEffect(e1)
end

function s.filter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN)
end

-- 效果的目标处理函数（检查发动条件）
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk == 0 then
        -- 检查双方场上是否存在可获得的表侧表示怪兽
        return Duel.IsExistingMatchingCard(s.filter, tp, 0, LOCATION_MZONE, 1, nil) or
               Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_MZONE, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_CONTROL, nil, 1, 0, 0)
end

function s.tkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
        local tc=g:Select(tp,1,1,nil):GetFirst()

        local c = e:GetHandler()
		local code = tc:GetOriginalCode()
        local originalRace = tc:GetOriginalRace()
        local originalAttribute = tc:GetOriginalAttribute()
        local originalLevel = tc:GetOriginalLevel()
        local originalAttack = tc:GetBaseAttack()
        local originalDefense = tc:GetBaseDefense()

        local ft=5
        ft=math.min(ft,(Duel.GetLocationCount(tp,LOCATION_MZONE)))
        if ft<=0 then return end
        repeat
            local token=Duel.CreateToken(tp,900000109)
            Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)

            local e1 = Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_BASE_ATTACK)
            e1:SetValue(originalAttack)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
            token:RegisterEffect(e1,true)

            local e2 = Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_SET_BASE_DEFENSE)
            e2:SetValue(originalDefense)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
            token:RegisterEffect(e2,true)

            local e3 = Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_CHANGE_LEVEL)
            e3:SetValue(originalLevel)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
            token:RegisterEffect(e3,true)

            local e4 = Effect.CreateEffect(c)
            e4:SetType(EFFECT_TYPE_SINGLE)
            e4:SetCode(EFFECT_CHANGE_RACE)
            e4:SetValue(originalRace)
            e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
            token:RegisterEffect(e4,true)

            local e5 = Effect.CreateEffect(c)
            e5:SetType(EFFECT_TYPE_SINGLE)
            e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
            e5:SetValue(originalAttribute)
            e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
            token:RegisterEffect(e5,true)

            -- 将Token特殊召唤到场上
            Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)

            token:CopyEffect(code, RESET_EVENT+RESETS_STANDARD, 1) 
            -- 复制名字
            local e6=Effect.CreateEffect(c)
            e6:SetType(EFFECT_TYPE_SINGLE)
            e6:SetCode(EFFECT_CHANGE_CODE)
            e6:SetValue(code)
            e6:SetReset(RESET_EVENT+RESETS_STANDARD)
            token:RegisterEffect(e6)

            ft=ft-1
        until ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(123111,2))
        Duel.SpecialSummonComplete()
	end
end