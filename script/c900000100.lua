-- 绝杀神印
function c900000100.initial_effect(c)
    -- 一回合一次的多选效果
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetDescription(aux.Stringid(19910101, 0))
    c:RegisterEffect(e1)

    -- 主要效果
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(19910101, 1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1) -- 1回合1次
    e2:SetCondition(c900000100.condition)
    e2:SetTarget(c900000100.target)
    e2:SetOperation(c900000100.operation)
    c:RegisterEffect(e2)
end

-- 条件：主要阶段
function c900000100.condition(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2
end

-- 目标：选择效果
function c900000100.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    local op = 0
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EFFECT)
    op = Duel.SelectOption(tp, aux.Stringid(123111, 0), aux.Stringid(123111, 1))
    e:SetLabel(op)
end

-- 操作：执行效果
function c900000100.operation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end

    local op = e:GetLabel()
    -- 效果1：跳过对方回合
    if op == 0 then
        -- 跳过对方的下个回合
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(0, 1)
        e1:SetCode(EFFECT_SKIP_TURN)
        e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN, 1)
        Duel.RegisterEffect(e1, tp)
        Duel.Hint(HINT_OPSELECTED, 1-tp, aux.Stringid(19910101, 2))

    -- 效果2：直接攻击
    elseif op == 1 then
        -- 我方怪兽可以直接攻击
        local e2 = Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_DIRECT_ATTACK)
        e2:SetTargetRange(LOCATION_MZONE, 0)
        e2:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e2, tp)
        Duel.Hint(HINT_OPSELECTED, 1-tp, aux.Stringid(19910101, 3))
    end
end
