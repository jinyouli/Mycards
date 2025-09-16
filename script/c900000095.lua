-- 確率變動 (Probability Fluctuation) 陷阱卡
local s, id = GetID()

function s.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
e1:SetCountLimit(1)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TOSS_DICE_NEGATE)
	e1:SetOperation(s.diceop)
    e1:SetCountLimit(1)
e1:SetCondition(s.coincon)	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)

    --coin
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_COIN_NEGATE)
	e2:SetOperation(s.coinop)
    e2:SetCountLimit(1)
e2:SetCondition(s.coincon)
    e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end


function s.coincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)==0
end


function s.diceop(e, tp, eg, ep, ev, re, r, rp)

if Duel.GetFlagEffect(tp,id)~=0 then return end

    s.previous_results = {}
    local original_result = Duel.GetDiceResult()
    Debug.Message("初始 : " .. original_result)

	if Duel.SelectYesNo(tp,aux.Stringid(39454112,0)) then
    
   Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)

 table.insert(s.previous_results, original_result)

        local new_dice_result = s.reroll_dice(original_result)
        Debug.Message("变化值: " .. new_dice_result)
        Duel.SetDiceResult(new_dice_result)
	end
end


function s.coinop(e, tp, eg, ep, ev, re, r, rp)

if Duel.GetFlagEffect(tp,id)~=0 then return end

    s.previous_results = {}
    local original_result = Duel.GetCoinResult()
    Debug.Message("初始 : " .. original_result)

	if Duel.SelectYesNo(tp,aux.Stringid(39454112,0)) then

Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
        table.insert(s.previous_results, original_result)

        local new_coin_result = s.reroll_coin(original_result)
        Debug.Message("变化值: " .. new_coin_result)
        Duel.SetCoinResult(new_coin_result)
	end
end

function s.reroll_dice(original_result)
    local new_result = Duel.TossDice(tp, 1)
    while table.contains(s.previous_results, new_result) do
        new_result = Duel.TossDice(tp, 1)
    end
    
    return new_result
end


function s.reroll_coin(original_result)
    local new_result = Duel.TossCoin(tp, 1)
    while table.contains(s.previous_results, new_result) do
        new_result = Duel.TossCoin(tp, 1)
    end
    
    return new_result
end

-- 辅助函数：检查表中是否包含某个值
function table.contains(t, value)
    for _, v in ipairs(t) do
        if v == value then
            return true
        end
    end
    return false
end
